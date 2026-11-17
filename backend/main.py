
import os
import time
import threading
from uuid import UUID

import psycopg
from argon2 import PasswordHasher
from argon2.exceptions import (
    InvalidHashError,
    VerificationError,
    VerifyMismatchError,
)
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException, Request
from pydantic import BaseModel, Field

load_dotenv()

app = FastAPI(title="LearnAble API")


# ============================================================
# PASSWORD HASHING
# ============================================================

password_hasher = PasswordHasher()


def hash_learner_password(password: str) -> str:
    return password_hasher.hash(password)


def verify_learner_password(
    password: str,
    stored_hash: str,
) -> bool:
    try:
        return password_hasher.verify(stored_hash, password)
    except (
        VerifyMismatchError,
        VerificationError,
        InvalidHashError,
    ):
        return False


# ============================================================
# DATABASE CONNECTION
# ============================================================

def get_db_connection():
    return psycopg.connect(
        host=os.getenv("DB_HOST"),
        port=os.getenv("DB_PORT"),
        dbname=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        connect_timeout=5,
    )


# ============================================================
# BASIC LOGIN ATTEMPT LIMITING
# Local prototype only. Resets when the server restarts.
# ============================================================

MAX_LOGIN_ATTEMPTS = 5
LOGIN_WINDOW_SECONDS = 15 * 60

_login_attempts = {}
_login_lock = threading.Lock()


def check_login_limit(client_key: str):
    now = time.monotonic()

    with _login_lock:
        attempts = [
            timestamp
            for timestamp in _login_attempts.get(client_key, [])
            if now - timestamp < LOGIN_WINDOW_SECONDS
        ]

        _login_attempts[client_key] = attempts

        if len(attempts) >= MAX_LOGIN_ATTEMPTS:
            raise HTTPException(
                status_code=429,
                detail=(
                    "Too many login attempts. "
                    "Please try again later."
                ),
            )


def record_failed_login(client_key: str):
    now = time.monotonic()

    with _login_lock:
        attempts = [
            timestamp
            for timestamp in _login_attempts.get(client_key, [])
            if now - timestamp < LOGIN_WINDOW_SECONDS
        ]

        attempts.append(now)
        _login_attempts[client_key] = attempts


def clear_login_attempts(client_key: str):
    with _login_lock:
        _login_attempts.pop(client_key, None)


# ============================================================
# LEARNER MATCHING
# ============================================================

def find_matching_learners(cur, name: str, password: str):
    """
    Find learners with the supplied name and verify
    their stored Argon2 password hashes.

    Passwords are never stored in plaintext.
    """

    cur.execute(
        """
        SELECT learner_id, password_hash
        FROM learners
        WHERE LOWER(TRIM(name)) = LOWER(TRIM(%s))
          AND password_hash IS NOT NULL
        """,
        (name,),
    )

    matches = []

    for learner_id, stored_hash in cur.fetchall():
        if verify_learner_password(password, stored_hash):
            matches.append(learner_id)

    return matches


# ============================================================
# HOME
# ============================================================

@app.get("/")
def home():
    return {
        "message":
            "LearnAble FastAPI backend is running successfully"
    }


# ============================================================
# DATABASE TEST
# ============================================================

@app.get("/db-test")
def test_database():
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute(
                    "SELECT current_database(), version()"
                )
                database, version = cur.fetchone()

        return {
            "status": "connected",
            "database": database,
            "postgresql_version": version.split(",")[0],
        }

    except psycopg.Error:
        raise HTTPException(
            status_code=503,
            detail=(
                "Database connection failed. "
                "Check backend configuration."
            ),
        )


# ============================================================
# LEARNER COUNT
# ============================================================

@app.get("/learners")
def get_learners():
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute(
                    "SELECT COUNT(*) FROM learners"
                )
                count = cur.fetchone()[0]

        return {
            "total_learners": count
        }

    except psycopg.Error:
        raise HTTPException(
            status_code=503,
            detail="Unable to retrieve learners",
        )


# ============================================================
# LEARNER CREATION MODEL
# ============================================================

class LearnerCreate(BaseModel):
    name: str = Field(min_length=1, max_length=100)
    age: int = Field(ge=3, le=18)
    grade: str = Field(min_length=1, max_length=30)
    avatar: str | None = None
    password: str = Field(min_length=8, max_length=128)


# ============================================================
# CREATE LEARNER WITH PASSWORD
# ============================================================

@app.post("/learners", status_code=201)
def create_learner(learner: LearnerCreate):
    normalized_name = learner.name.strip()

    if not normalized_name:
        raise HTTPException(
            status_code=422,
            detail="Learner name cannot be empty",
        )

    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:

                # Prevent concurrent registrations from creating
                # identical name/password credentials.
                cur.execute(
                    "SELECT pg_advisory_xact_lock(%s)",
                    (20261118,),
                )

                matches = find_matching_learners(
                    cur,
                    normalized_name,
                    learner.password,
                )

                if matches:
                    raise HTTPException(
                        status_code=409,
                        detail=(
                            "A learner with this name and "
                            "password already exists. "
                            "Please choose another password."
                        ),
                    )

                hashed_password = hash_learner_password(
                    learner.password
                )

                cur.execute(
                    """
                    INSERT INTO learners
                        (name, age, grade, avatar, password_hash)
                    VALUES (%s, %s, %s, %s, %s)
                    RETURNING learner_id
                    """,
                    (
                        normalized_name,
                        learner.age,
                        learner.grade,
                        learner.avatar,
                        hashed_password,
                    ),
                )

                learner_id = cur.fetchone()[0]

        return {
            "message": "Learner created successfully",
            "learner_id": str(learner_id),
        }

    except psycopg.Error:
        raise HTTPException(
            status_code=503,
            detail="Unable to create learner",
        )


# ============================================================
# SUBJECT ENROLLMENT MODEL
# ============================================================

class SubjectEnrollment(BaseModel):
    subject_names: list[str]


# ============================================================
# SAVE LEARNER SUBJECTS
# ============================================================

@app.post("/learners/{learner_id}/subjects")
def save_learner_subjects(
    learner_id: UUID,
    enrollment: SubjectEnrollment,
):
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:

                cur.execute(
                    """
                    SELECT 1
                    FROM learners
                    WHERE learner_id = %s
                    """,
                    (learner_id,),
                )

                if cur.fetchone() is None:
                    raise HTTPException(
                        status_code=404,
                        detail="Learner not found",
                    )

                cur.execute(
                    """
                    SELECT subject_id, subject_name
                    FROM subjects
                    """
                )

                available = {
                    name: subject_id
                    for subject_id, name in cur.fetchall()
                }

                names = set(enrollment.subject_names)

                if not names.issubset(available.keys()):
                    raise HTTPException(
                        status_code=400,
                        detail="Invalid subject selected",
                    )

                cur.execute(
                    """
                    DELETE FROM learner_subjects
                    WHERE learner_id = %s
                    """,
                    (learner_id,),
                )

                for name in names:
                    cur.execute(
                        """
                        INSERT INTO learner_subjects
                            (learner_id, subject_id)
                        VALUES (%s, %s)
                        """,
                        (
                            learner_id,
                            available[name],
                        ),
                    )

        return {
            "message": "Subjects saved successfully",
            "selected_subjects": sorted(names),
        }

    except psycopg.Error:
        raise HTTPException(
            status_code=503,
            detail="Unable to save subjects",
        )


# ============================================================
# NAME + PASSWORD LOGIN MODEL
# ============================================================

class LearnerLogin(BaseModel):
    name: str = Field(min_length=1, max_length=100)
    password: str = Field(min_length=1)


# ============================================================
# LOGIN USING NAME AND PASSWORD
# ============================================================

@app.post("/learners/login")
def login_learner(
    credentials: LearnerLogin,
    request: Request,
):
    client_key = (
        request.client.host
        if request.client is not None
        else "unknown"
    )

    check_login_limit(client_key)

    normalized_name = credentials.name.strip()

    if not normalized_name:
        record_failed_login(client_key)
        raise HTTPException(
            status_code=401,
            detail="Invalid name or password",
        )

    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                matches = find_matching_learners(
                    cur,
                    normalized_name,
                    credentials.password,
                )

        if len(matches) == 0:
            record_failed_login(client_key)

            raise HTTPException(
                status_code=401,
                detail="Invalid name or password",
            )

        if len(matches) > 1:
            record_failed_login(client_key)

            raise HTTPException(
                status_code=409,
                detail=(
                    "Multiple learner profiles have "
                    "identical login credentials. "
                    "Please contact the administrator."
                ),
            )

        learner_id = matches[0]

        clear_login_attempts(client_key)

        return {
            "message": "Login successful",
            "learner_id": str(learner_id),
        }

    except psycopg.Error:
        raise HTTPException(
            status_code=503,
            detail="Unable to log in",
        )


# ============================================================
# GET LEARNER PROFILE
# ============================================================

@app.get("/learners/{learner_id}")
def get_learner_profile(learner_id: UUID):
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:

                cur.execute(
                    """
                    SELECT
                        learner_id,
                        name,
                        age,
                        grade,
                        avatar
                    FROM learners
                    WHERE learner_id = %s
                    """,
                    (learner_id,),
                )

                learner = cur.fetchone()

                if learner is None:
                    raise HTTPException(
                        status_code=404,
                        detail="Learner not found",
                    )

                cur.execute(
                    """
                    SELECT s.subject_name
                    FROM learner_subjects ls
                    JOIN subjects s
                        ON ls.subject_id = s.subject_id
                    WHERE ls.learner_id = %s
                    ORDER BY s.subject_name
                    """,
                    (learner_id,),
                )

                subjects = [
                    row[0]
                    for row in cur.fetchall()
                ]

        return {
            "learner_id": str(learner[0]),
            "name": learner[1],
            "age": learner[2],
            "grade": learner[3],
            "avatar": learner[4],
            "selected_subjects": subjects,
        }

    except psycopg.Error:
        raise HTTPException(
            status_code=503,
            detail="Unable to retrieve learner profile",
        )

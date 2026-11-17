--
-- PostgreSQL database dump
--

\restrict y79OOH5Tyztbs5KcaRddOtqt0c5qUCeRhjMA7SRkesVtaOjaBkXWY7zpetsEkdg

-- Dumped from database version 17.12
-- Dumped by pg_dump version 17.12

-- Started on 2026-11-18 01:09:17

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2 (class 3079 OID 24581)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 4851 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 24635)
-- Name: learner_subjects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.learner_subjects (
    learner_id uuid NOT NULL,
    subject_id uuid NOT NULL,
    enrolled_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 218 (class 1259 OID 24618)
-- Name: learners; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.learners (
    learner_id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(100) NOT NULL,
    age integer NOT NULL,
    grade character varying(30) NOT NULL,
    avatar character varying(255),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    password_hash text,
    CONSTRAINT learners_age_check CHECK (((age >= 3) AND (age <= 18)))
);


--
-- TOC entry 219 (class 1259 OID 24626)
-- Name: subjects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subjects (
    subject_id uuid DEFAULT gen_random_uuid() NOT NULL,
    subject_name character varying(100) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 4698 (class 2606 OID 24640)
-- Name: learner_subjects learner_subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.learner_subjects
    ADD CONSTRAINT learner_subjects_pkey PRIMARY KEY (learner_id, subject_id);


--
-- TOC entry 4692 (class 2606 OID 24625)
-- Name: learners learners_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.learners
    ADD CONSTRAINT learners_pkey PRIMARY KEY (learner_id);


--
-- TOC entry 4694 (class 2606 OID 24632)
-- Name: subjects subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY (subject_id);


--
-- TOC entry 4696 (class 2606 OID 24634)
-- Name: subjects subjects_subject_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_subject_name_key UNIQUE (subject_name);


--
-- TOC entry 4699 (class 2606 OID 24641)
-- Name: learner_subjects learner_subjects_learner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.learner_subjects
    ADD CONSTRAINT learner_subjects_learner_id_fkey FOREIGN KEY (learner_id) REFERENCES public.learners(learner_id);


--
-- TOC entry 4700 (class 2606 OID 24646)
-- Name: learner_subjects learner_subjects_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.learner_subjects
    ADD CONSTRAINT learner_subjects_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subjects(subject_id);


-- Completed on 2026-11-18 01:09:18

--
-- PostgreSQL database dump complete
--

\unrestrict y79OOH5Tyztbs5KcaRddOtqt0c5qUCeRhjMA7SRkesVtaOjaBkXWY7zpetsEkdg


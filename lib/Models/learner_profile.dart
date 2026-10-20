/// Abhi ka learner. Baad mein PostgreSQL se load hoga.

class LearnerProfile {
  final String nickname;
  final int age;
  final String grade;
  final String avatarPath;

  const LearnerProfile({
    required this.nickname,
    required this.age,
    required this.grade,
    required this.avatarPath,
  });

  static LearnerProfile current = const LearnerProfile(
    nickname: 'Maya',
    age: 9,
    grade: 'Grade 4',
    avatarPath: 'assets/pngs/avatars/avatar_1.png',
  );

  Map<String, dynamic> toMap() => {
    'nickname': nickname,
    'age': age,
    'grade': grade,
    'avatar': avatarPath,
  };
}

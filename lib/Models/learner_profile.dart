
class LearnerProfile {
  final String? learnerId;
  final String nickname;
  final int age;
  final String grade;
  final String avatarPath;

  const LearnerProfile({
    this.learnerId,
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
    'learner_id': learnerId,
    'nickname': nickname,
    'age': age,
    'grade': grade,
    'avatar': avatarPath,
  };
}

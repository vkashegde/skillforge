/// Profile entity representing user preferences
class ProfileEntity {
  final String userId;
  final String? goal;
  final String? skillLevel;
  final String? timeCommitment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProfileEntity({
    required this.userId,
    this.goal,
    this.skillLevel,
    this.timeCommitment,
    this.createdAt,
    this.updatedAt,
  });
}

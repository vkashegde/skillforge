import '../../domain/entities/profile_entity.dart';

/// Profile model for Supabase
class ProfileModel {
  final String userId;
  final String? goal;
  final String? skillLevel;
  final String? timeCommitment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProfileModel({
    required this.userId,
    this.goal,
    this.skillLevel,
    this.timeCommitment,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'goal': goal,
      'skill_level': skillLevel,
      'time_commitment': timeCommitment,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userId: json['user_id'] as String,
      goal: json['goal'] as String?,
      skillLevel: json['skill_level'] as String?,
      timeCommitment: json['time_commitment'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      userId: userId,
      goal: goal,
      skillLevel: skillLevel,
      timeCommitment: timeCommitment,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      userId: entity.userId,
      goal: entity.goal,
      skillLevel: entity.skillLevel,
      timeCommitment: entity.timeCommitment,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}

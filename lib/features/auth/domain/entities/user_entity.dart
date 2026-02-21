/// User entity representing authenticated user
class UserEntity {
  final String id;
  final String? email;
  final String? fullName;
  final String? avatarUrl;

  const UserEntity({
    required this.id,
    this.email,
    this.fullName,
    this.avatarUrl,
  });
}

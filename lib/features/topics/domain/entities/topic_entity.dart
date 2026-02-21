/// Topic entity representing a theory/article topic
class TopicEntity {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String content;
  final String? difficulty;
  final String? category;
  final int? orderIndex;
  final int? estimatedTimeMinutes;
  final List<String>? prerequisites;
  final List<String>? learningObjectives;
  final Map<String, dynamic>? examples;
  final Map<String, dynamic>? visualizations;
  final bool isPublished;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TopicEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.content,
    this.difficulty,
    this.category,
    this.orderIndex,
    this.estimatedTimeMinutes,
    this.prerequisites,
    this.learningObjectives,
    this.examples,
    this.visualizations,
    required this.isPublished,
    this.createdAt,
    this.updatedAt,
  });
}

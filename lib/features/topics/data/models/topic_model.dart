import '../../domain/entities/topic_entity.dart';

/// Topic model for Supabase
class TopicModel {
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

  TopicModel({
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'content': content,
      'difficulty': difficulty,
      'category': category,
      'order_index': orderIndex,
      'estimated_time_minutes': estimatedTimeMinutes,
      'prerequisites': prerequisites,
      'learning_objectives': learningObjectives,
      'examples': examples,
      'visualizations': visualizations,
      'is_published': isPublished,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      content: json['content'] as String,
      difficulty: json['difficulty'] as String?,
      category: json['category'] as String?,
      orderIndex: json['order_index'] as int?,
      estimatedTimeMinutes: json['estimated_time_minutes'] as int?,
      prerequisites: json['prerequisites'] != null
          ? List<String>.from(json['prerequisites'] as List)
          : null,
      learningObjectives: json['learning_objectives'] != null
          ? List<String>.from(json['learning_objectives'] as List)
          : null,
      examples: json['examples'] as Map<String, dynamic>?,
      visualizations: json['visualizations'] as Map<String, dynamic>?,
      isPublished: json['is_published'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  TopicEntity toEntity() {
    return TopicEntity(
      id: id,
      name: name,
      slug: slug,
      description: description,
      content: content,
      difficulty: difficulty,
      category: category,
      orderIndex: orderIndex,
      estimatedTimeMinutes: estimatedTimeMinutes,
      prerequisites: prerequisites,
      learningObjectives: learningObjectives,
      examples: examples,
      visualizations: visualizations,
      isPublished: isPublished,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory TopicModel.fromEntity(TopicEntity entity) {
    return TopicModel(
      id: entity.id,
      name: entity.name,
      slug: entity.slug,
      description: entity.description,
      content: entity.content,
      difficulty: entity.difficulty,
      category: entity.category,
      orderIndex: entity.orderIndex,
      estimatedTimeMinutes: entity.estimatedTimeMinutes,
      prerequisites: entity.prerequisites,
      learningObjectives: entity.learningObjectives,
      examples: entity.examples,
      visualizations: entity.visualizations,
      isPublished: entity.isPublished,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}

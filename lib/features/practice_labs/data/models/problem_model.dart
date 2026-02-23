import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/problem_entity.dart';

part 'problem_model.g.dart';

/// Problem model for data layer (JSON serializable)
@JsonSerializable()
class ProblemModel extends ProblemEntity {
  const ProblemModel({
    required super.id,
    required super.title,
    required super.description,
    required super.examples,
    required super.constraints,
    required super.tags,
    required super.difficulty,
    super.starterCode,
    super.starterCodeByLanguage,
    required super.testCases,
    super.hint,
    super.solution,
    super.acceptanceRate,
    super.totalSubmissions,
  });

  factory ProblemModel.fromJson(Map<String, dynamic> json) =>
      _$ProblemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProblemModelToJson(this);

  /// Convert to entity
  ProblemEntity toEntity() => ProblemEntity(
        id: id,
        title: title,
        description: description,
        examples: examples,
        constraints: constraints,
        tags: tags,
        difficulty: difficulty,
        starterCode: starterCode,
        starterCodeByLanguage: starterCodeByLanguage,
        testCases: testCases,
        hint: hint,
        solution: solution,
        acceptanceRate: acceptanceRate,
        totalSubmissions: totalSubmissions,
      );
}

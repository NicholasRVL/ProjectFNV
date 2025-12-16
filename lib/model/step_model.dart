class StepModel {
  final int? id;
  final int? recipeId;
  final int? position;
   String? instruction;
   String? tips;

  StepModel({
    this.id,
    this.recipeId,
    this.position,
    this.instruction,
    this.tips,
  });

  factory StepModel.fromJson(Map<String, dynamic> json) {
    return StepModel(
      id: json['id'],
      recipeId: json['recipe_id'],
      position: json['position'] ?? 0,
      instruction: json['instruction']?.toString(),
      tips: json['tips']?.toString(),
    );
  }
}
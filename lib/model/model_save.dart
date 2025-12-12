class SaveModel {
  final int id;
  final int userId;
  final int recipeId;

  SaveModel({
    required this.id,
    required this.userId,
    required this.recipeId,
  });

  factory SaveModel.fromJson(Map<String, dynamic> json) {
    return SaveModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      recipeId: json['recipe_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'recipe_id': recipeId,
    };
  }
}

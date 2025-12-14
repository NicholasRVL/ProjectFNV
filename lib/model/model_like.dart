class LikeModel {
  final int id;
  final int userId;
  final int recipeId;

  LikeModel({
    required this.id,
    required this.userId,
    required this.recipeId,
  });

  factory LikeModel.fromJson(Map<String, dynamic> json) {
    return LikeModel(
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
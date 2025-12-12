class RatingModel {
  final int id;
  final int userId;
  final int recipeId;
  final int score;

  RatingModel({
    required this.id,
    required this.userId,
    required this.recipeId,
    required this.score,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      recipeId: json['recipe_id'] ?? 0,
      score: json['score'] ?? 0,
    );
  }
}

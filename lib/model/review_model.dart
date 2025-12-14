class ReviewModel {
  final int? id;
  final int? userId;
  final int? recipeId;
  final String? content;
  final int? rating;

  final bool? isModerated;
  final int? moderatedBy;
  final DateTime? moderatedAt;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  ReviewModel({
    this.id,
    this.userId,
    this.recipeId,
    this.content,
    this.rating,
    this.isModerated,
    this.moderatedBy,
    this.moderatedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      userId: json['user_id'],
      recipeId: json['recipe_id'],
      content: json['content']?.toString(),
      rating: json['rating'],
      isModerated: json['is_moderated'],
      moderatedBy: json['moderated_by'],
      moderatedAt: json['moderated_at'] != null
          ? DateTime.tryParse(json['moderated_at'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
}
import 'package:fnv/model/model_kategori.dart';
import 'model_kategori.dart';
import 'model_bahan.dart';
import 'model_alat.dart';
import 'step_model.dart';
import 'rating_model.dart';
import 'review_model.dart';

class ModelResep {
  final int? id;
  final int? userId;
  final int? categoryId;

  final String? title;
  final String? slug;
  final String? description;
  final String? background;
  final String? visibility;
  final String? coverImage;

  final int? prepTime;
  final int? cookTime;
  final int? servings;

  final double? averageRating;
  final int? likesCount;
  final int? savesCount;

  final ModelKategori? category;
  final List<IngredientModel> ingredients;
  final List<ModelAlat> tools;
  final List<StepModel> steps;
  final List<RatingModel> ratings;
  final List<ReviewModel> reviews;

  ModelResep({
    this.id,
    this.userId,
    this.categoryId,
    this.title,
    this.slug,
    this.description,
    this.background,
    this.prepTime,
    this.cookTime,
    this.servings,
    this.visibility,
    this.coverImage,
    this.averageRating,
    this.likesCount,
    this.savesCount,
    this.category,
    this.ingredients = const [],
    this.tools = const [],
    this.steps = const [],
    this.ratings = const [],
    this.reviews = const [],
  });

  factory ModelResep.fromJson(Map<String, dynamic> json) {
    return ModelResep(
      id: json['id'],
      userId: json['user_id'],
      categoryId: json['category_id'],

      title: json['title'],
      slug: json['slug'],
      description: json['description'],
      background: json['background'],
      visibility: json['visibility'],
      coverImage: json['cover_image'],

      prepTime: json['prep_time'],
      cookTime: json['cook_time'],
      servings: json['servings'],

      averageRating: json['average_rating']?.toDouble(),
      likesCount: json['likes_count'],
      savesCount: json['saves_count'],

      category: json['category'] != null
          ? ModelKategori.fromJson(json['category'])
          : null,

      ingredients: (json['ingredients'] as List? ?? [])
          .map((e) => IngredientModel.fromJson(e))
          .toList(),

      tools: (json['tools'] as List? ?? [])
          .map((e) => ModelAlat.fromJson(e))
          .toList(),

      steps: (json['steps'] as List? ?? [])
          .map((e) => StepModel.fromJson(e))
          .toList(),

      ratings: (json['ratings'] as List? ?? [])
          .map((e) => RatingModel.fromJson(e))
          .toList(),

      reviews: (json['reviews'] as List? ?? [])
          .map((e) => ReviewModel.fromJson(e))
          .toList(),
    );
  }
}

class ModelAlat {
  final int? id;
  final int? recipeId;
   String? name;

  ModelAlat({
    this.id,
    this.recipeId,
    this.name,
  });

  factory ModelAlat.fromJson(Map<String, dynamic> json) {
    return ModelAlat(
      id: json['id'],
      recipeId: json['recipe_id'],
      name: json['name']?.toString(),
    );
  }
}
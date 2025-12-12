class IngredientModel {
  final int? id;
  final int? recipeId;
  final String? name;
  final String? quantity;
  final String? unit;

  IngredientModel({
    this.id,
    this.recipeId,
    this.name,
    this.quantity,
    this.unit,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      id: json['id'],
      recipeId: json['recipe_id'],
      name: json['name']?.toString(),
      quantity: json['quantity']?.toString(),
      unit: json['unit']?.toString(),
    );
  }
}

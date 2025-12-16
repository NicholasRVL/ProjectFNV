class ModelBahan {
  final int? id;
  final int? recipeId;
   String? name;
  String? quantity;
   String? unit;

  ModelBahan({
    this.id,
    this.recipeId,
    this.name,
    this.quantity,
    this.unit,
  });

  factory ModelBahan.fromJson(Map<String, dynamic> json) {
    return ModelBahan(
      id: json['id'],
      recipeId: json['recipe_id'],
      name: json['name']?.toString(),
      quantity: json['quantity']?.toString(),
      unit: json['unit']?.toString(),
    );
  }
}

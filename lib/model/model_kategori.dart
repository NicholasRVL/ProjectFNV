class ModelKategori {
  final int? id;
  final String? name;
  final String? slug;
  final String? description;

  ModelKategori({
    this.id,
    this.name,
    this.slug,
    this.description,
  });

  factory ModelKategori.fromJson(Map<String, dynamic> json) {
    return ModelKategori(
      id: json['id'],
      name: json['name']?.toString(),
      slug: json['slug']?.toString(),
      description: json['description']?.toString(),
    );
  }
}

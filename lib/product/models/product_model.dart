class ProductModel {
  final int id;
  final String name;
  final String description;
  final int stock;
  final bool available;
  final String expired;
  final int idCategory;
  final String? categoryName;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.stock,
    required this.available,
    required this.expired,
    required this.idCategory,
    this.categoryName,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      stock: json['stock'] ?? 0,
      available: json['available'] ?? false,
      expired: json['expired'] ?? '',
      idCategory: json['id_category'] ?? 0,
      categoryName: json['category']?['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'stock': stock,
      'available': available,
      'expired': expired,
      'id_category': idCategory,
    };
  }

  ProductModel copyWith({
    int? id,
    String? name,
    String? description,
    int? stock,
    bool? available,
    String? expired,
    int? idCategory,
    String? categoryName,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      stock: stock ?? this.stock,
      available: available ?? this.available,
      expired: expired ?? this.expired,
      idCategory: idCategory ?? this.idCategory,
      categoryName: categoryName ?? this.categoryName,
    );
  }
}
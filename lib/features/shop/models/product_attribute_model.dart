class ProductAttributeModel {
  String? name;
  final List<String>? value;
  ProductAttributeModel({this.name, this.value});

  /// Json Map
  toJson() {
    return {'Name': name, 'Value': value};
  }

  // Map Jon oriented document snapshot from Firebase to Model
  factory ProductAttributeModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) return ProductAttributeModel();
    return ProductAttributeModel(
      name: data['Name'] ?? '',
      value: List<String>.from(data['Value'] ?? []),
    );
  }
}

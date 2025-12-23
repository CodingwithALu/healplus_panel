class UnitNameModel {
  String name;
  String price;
  UnitNameModel({required this.name, required this.price});
  // Empty
  static UnitNameModel empty() {
    return UnitNameModel(name: '', price: '');
  }

  // Convert Models to Json structure so that you can store data in Firebase
  Map<String, dynamic> toJson() {
    return {'name': name, 'price': price};
  }

  factory UnitNameModel.formJson(Map<String, dynamic> document) {
    final data = document;
    // Map Json Record to the Model
    return UnitNameModel(name: data['name'] ?? '', price: data['price'] ?? '');
  }
}

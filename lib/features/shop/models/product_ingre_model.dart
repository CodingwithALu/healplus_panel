
class ProductIngreModel {
  String title;
  String body;
  ProductIngreModel({
    required this.title,
    required this.body
  });
  // Empty
  static ProductIngreModel empty() {
    return ProductIngreModel(title: '', body: '');
  }

  // Convert Models to Json structure so that you can store data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
    };
  }
  factory ProductIngreModel.formJson(Map<String, dynamic> document) {
    final data = document;
    // Map Json Record to the Model
    return ProductIngreModel(
      title: data['title'] ?? '',
      body: data['body'] ?? '',
    );
  }
}

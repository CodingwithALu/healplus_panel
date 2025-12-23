class ReviewItemModel {
  int rating;
  String comment;
  String date;
  String name;
  String? url;

  ReviewItemModel({
    required this.rating,
    required this.comment,
    required this.date,
    required this.name,
    this.url,
  });

  factory ReviewItemModel.fromJson(Map<String, dynamic> json) {
    return ReviewItemModel(
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      date: json['date'] ?? '',
      name: json['name'] ?? '',
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'comment': comment,
      'date': date,
      'name': name,
      'url': url,
    };
  }
}
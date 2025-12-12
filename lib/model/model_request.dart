class Request {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String reason;
  final String contact;
  final String status;

  Request({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.reason,
    required this.contact,
    required this.status,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      reason: json['reason'] ?? '',
      contact: json['contact'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'title': title,
      'description': description,
      'reason': reason,
      'contact': contact,
      'status': status,
    };
  }
}

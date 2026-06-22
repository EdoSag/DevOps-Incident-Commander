import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class IncidentComment {
  const IncidentComment({
    required this.id,
    required this.userName,
    required this.text,
    required this.createdAt,
  });

  factory IncidentComment.fromJson(Map<String, dynamic> json) {
    return IncidentComment(
      id: json['id'] as String,
      userName: json['userName'] as String? ?? 'Anonymous',
      text: json['text'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  final String id;

  final String userName;

  final String text;

  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

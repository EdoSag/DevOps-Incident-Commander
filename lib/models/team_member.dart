import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class TeamMember {
  const TeamMember({
    required this.id,
    required this.name,
    required this.title,
    required this.avatarColor,
    required this.isOnCall,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
      avatarColor: json['avatarColor'] as int? ?? 0xFF42A5F5,
      isOnCall: json['isOnCall'] as bool? ?? false,
    );
  }

  final String id;

  final String name;

  final String title;

  final int avatarColor;

  final bool isOnCall;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'avatarColor': avatarColor,
      'isOnCall': isOnCall,
    };
  }

  TeamMember copyWith({
    String? id,
    String? name,
    String? title,
    int? avatarColor,
    bool? isOnCall,
  }) {
    return TeamMember(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      avatarColor: avatarColor ?? this.avatarColor,
      isOnCall: isOnCall ?? this.isOnCall,
    );
  }
}

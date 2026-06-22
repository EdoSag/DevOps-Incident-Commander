import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:devops_incident_commander_dashboard/user_role.dart';

@NowaGenerated()
class OrganizationMember {
  const OrganizationMember({
    required this.id,
    required this.organizationId,
    required this.userId,
    required this.role,
    required this.joinedAt,
    this.displayName,
  });

  factory OrganizationMember.fromJson(Map<String, dynamic> json) {
    return OrganizationMember(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      userId: json['user_id'] as String,
      role: UserRole.values.firstWhere(
        (e) => e.name == (json['role'] as String),
        orElse: () => UserRole.responder,
      ),
      joinedAt: DateTime.parse(json['joined_at'] as String),
      displayName: json['display_name'] as String?,
    );
  }

  final String id;

  final String organizationId;

  final String userId;

  final UserRole role;

  final DateTime joinedAt;

  final String? displayName;

  String get resolvedDisplayName {
    return displayName ?? 'No Available Data';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'user_id': userId,
      'role': role.name,
      'joined_at': joinedAt.toIso8601String(),
      'display_name': displayName,
    };
  }

  OrganizationMember copyWith({UserRole? role, String? displayName}) {
    return OrganizationMember(
      id: id,
      organizationId: organizationId,
      userId: userId,
      role: role ?? this.role,
      joinedAt: joinedAt,
      displayName: displayName ?? this.displayName,
    );
  }
}

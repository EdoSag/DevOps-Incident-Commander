import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:devops_incident_commander_dashboard/user_role.dart';

@NowaGenerated()
class OrgInvite {
  const OrgInvite({
    required this.id,
    required this.organizationId,
    required this.code,
    required this.createdBy,
    required this.roleToGrant,
    required this.useCount,
    required this.revoked,
    required this.createdAt,
    this.maxUses,
    this.expiresAt,
  });

  factory OrgInvite.fromJson(Map<String, dynamic> json) {
    return OrgInvite(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      code: json['code'] as String,
      createdBy: json['created_by'] as String,
      roleToGrant: UserRole.values.firstWhere(
        (e) => e.name == (json['role_to_grant'] as String),
        orElse: () => UserRole.responder,
      ),
      useCount: json['use_count'] as int? ?? 0,
      revoked: json['revoked'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      maxUses: json['max_uses'] as int?,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
    );
  }

  final String id;

  final String organizationId;

  final String code;

  final String createdBy;

  final UserRole roleToGrant;

  final int useCount;

  final bool revoked;

  final DateTime createdAt;

  final int? maxUses;

  final DateTime? expiresAt;

  bool get isExpired {
    return expiresAt != null && expiresAt!.isBefore(DateTime.now());
  }

  bool get isExhausted {
    return maxUses != null && useCount >= maxUses!;
  }

  bool get isActive {
    return !revoked && !isExpired && !isExhausted;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'code': code,
      'created_by': createdBy,
      'role_to_grant': roleToGrant.name,
      'use_count': useCount,
      'revoked': revoked,
      'created_at': createdAt.toIso8601String(),
      'max_uses': maxUses,
      'expires_at': expiresAt?.toIso8601String(),
    };
  }
}

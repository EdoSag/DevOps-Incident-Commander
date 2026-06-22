import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:devops_incident_commander_dashboard/user_role.dart';

@NowaGenerated()
enum JoinRequestStatus {
  pending,
  approved,
  denied,
  expired;

  String get displayName {
    switch (this) {
      case JoinRequestStatus.pending:
        return 'Pending';
      case JoinRequestStatus.approved:
        return 'Approved';
      case JoinRequestStatus.denied:
        return 'Denied';
      case JoinRequestStatus.expired:
        return 'Expired';
    }
  }
}

@NowaGenerated()
class JoinRequest {
  const JoinRequest({
    required this.id,
    required this.requesterUserId,
    required this.token,
    required this.status,
    required this.requestedRole,
    required this.expiresAt,
    required this.createdAt,
    this.organizationId,
    this.resolvedBy,
    this.resolvedAt,
    this.requesterDisplayName,
  });

  factory JoinRequest.fromJson(Map<String, dynamic> json) {
    return JoinRequest(
      id: json['id'] as String,
      requesterUserId: json['requester_user_id'] as String,
      token: json['token'] as String,
      status: JoinRequestStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String),
        orElse: () => JoinRequestStatus.pending,
      ),
      requestedRole: UserRole.values.firstWhere(
        (e) => e.name == (json['requested_role'] as String),
        orElse: () => UserRole.responder,
      ),
      expiresAt: DateTime.parse(json['expires_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      organizationId: json['organization_id'] as String?,
      resolvedBy: json['resolved_by'] as String?,
      resolvedAt: json['resolved_at'] != null
          ? DateTime.parse(json['resolved_at'] as String)
          : null,
      requesterDisplayName: json['requester_display_name'] as String?,
    );
  }

  final String id;

  final String requesterUserId;

  final String token;

  final JoinRequestStatus status;

  final UserRole requestedRole;

  final DateTime expiresAt;

  final DateTime createdAt;

  final String? organizationId;

  final String? resolvedBy;

  final DateTime? resolvedAt;

  final String? requesterDisplayName;

  bool get isExpired {
    return expiresAt.isBefore(DateTime.now());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requester_user_id': requesterUserId,
      'token': token,
      'status': status.name,
      'requested_role': requestedRole.name,
      'expires_at': expiresAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'organization_id': organizationId,
      'resolved_by': resolvedBy,
      'resolved_at': resolvedAt?.toIso8601String(),
      'requester_display_name': requesterDisplayName,
    };
  }
}

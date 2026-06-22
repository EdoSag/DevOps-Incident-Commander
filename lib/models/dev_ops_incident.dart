import 'package:devops_incident_commander_dashboard/incident_status.dart';
import 'package:devops_incident_commander_dashboard/incident_provider.dart';
import 'package:devops_incident_commander_dashboard/models/organization_member.dart';
import 'package:devops_incident_commander_dashboard/models/incident_comment.dart';
import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class DevOpsIncident {
  const DevOpsIncident({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.urgency,
    required this.serviceData,
    required this.createdAt,
    required this.provider,
    this.acknowledgedAt,
    this.assignedAt,
    this.resolvedAt,
    this.assignedToMemberId,
    this.assignedToMember,
    this.rawProviderPayload,
    this.comments = const [],
  });

  factory DevOpsIncident.fromJson(Map<String, dynamic> json) {
    return DevOpsIncident(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: IncidentStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String),
        orElse: () => IncidentStatus.triggered,
      ),
      urgency: json['urgency'] as String,
      serviceData: json['service_data'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      provider: IncidentProvider.values.firstWhere(
        (e) => e.name == (json['provider'] as String),
        orElse: () => IncidentProvider.pagerDuty,
      ),
      acknowledgedAt: json['acknowledged_at'] != null
          ? DateTime.parse(json['acknowledged_at'] as String)
          : null,
      assignedAt: json['assigned_at'] != null
          ? DateTime.parse(json['assigned_at'] as String)
          : null,
      resolvedAt: json['resolved_at'] != null
          ? DateTime.parse(json['resolved_at'] as String)
          : null,
      assignedToMemberId: json['assigned_to'] as String?,
      rawProviderPayload: json['raw_provider_payload'] as Map<String, dynamic>?,
      comments: (json['comments'] as List<dynamic>? ?? [])
          .map((e) => IncidentComment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final String id;

  final String title;

  final String description;

  final IncidentStatus status;

  final String urgency;

  final String serviceData;

  final DateTime createdAt;

  final IncidentProvider provider;

  final DateTime? acknowledgedAt;

  final DateTime? assignedAt;

  final DateTime? resolvedAt;

  final String? assignedToMemberId;

  final OrganizationMember? assignedToMember;

  final Map<String, dynamic>? rawProviderPayload;

  final List<IncidentComment> comments;

  DevOpsIncident copyWith({
    String? id,
    String? title,
    String? description,
    IncidentStatus? status,
    String? urgency,
    String? serviceData,
    DateTime? createdAt,
    IncidentProvider? provider,
    DateTime? acknowledgedAt,
    DateTime? assignedAt,
    DateTime? resolvedAt,
    String? assignedToMemberId,
    OrganizationMember? assignedToMember,
    Map<String, dynamic>? rawProviderPayload,
    List<IncidentComment>? comments,
  }) {
    return DevOpsIncident(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      urgency: urgency ?? this.urgency,
      serviceData: serviceData ?? this.serviceData,
      createdAt: createdAt ?? this.createdAt,
      provider: provider ?? this.provider,
      acknowledgedAt: acknowledgedAt ?? this.acknowledgedAt,
      assignedAt: assignedAt ?? this.assignedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      assignedToMemberId: assignedToMemberId ?? this.assignedToMemberId,
      assignedToMember: assignedToMember ?? this.assignedToMember,
      rawProviderPayload: rawProviderPayload ?? this.rawProviderPayload,
      comments: comments ?? this.comments,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.name,
      'urgency': urgency,
      'service_data': serviceData,
      'created_at': createdAt.toIso8601String(),
      'provider': provider.name,
      'acknowledged_at': acknowledgedAt?.toIso8601String(),
      'assigned_at': assignedAt?.toIso8601String(),
      'resolved_at': resolvedAt?.toIso8601String(),
      'assigned_to': assignedToMemberId,
      'raw_provider_payload': rawProviderPayload,
    };
  }
}

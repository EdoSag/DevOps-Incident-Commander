import 'package:devops_incident_commander_dashboard/incident_status.dart';
import 'package:devops_incident_commander_dashboard/incident_provider.dart';
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
    this.resolvedAt,
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
      serviceData: json['serviceData'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      provider: IncidentProvider.values.firstWhere(
        (e) => e.name == (json['provider'] as String),
        orElse: () => IncidentProvider.pagerDuty,
      ),
      resolvedAt: json['resolvedAt'] != null
          ? DateTime.parse(json['resolvedAt'] as String)
          : null,
    );
  }

  factory DevOpsIncident.fromPagerDuty(Map<String, dynamic> json) {
    final event = json['event'] as Map<String, dynamic>? ?? {};
    final data = event['data'] as Map<String, dynamic>? ?? {};
    final id =
        data['id'] as String? ?? 'pd-${DateTime.now().millisecondsSinceEpoch}';
    final title = data['title'] as String? ?? 'PagerDuty Alert';
    final service = data['service'] as Map<String, dynamic>? ?? {};
    final serviceName = service['summary'] as String? ?? 'unknown-service';
    final severity = data['severity'] as String? ?? 'high';
    return DevOpsIncident(
      id: id,
      title: title,
      description:
          data['description'] as String? ??
          'A PagerDuty incident was triggered.',
      status: IncidentStatus.triggered,
      urgency: severity,
      serviceData: serviceName,
      createdAt: DateTime.now(),
      provider: IncidentProvider.pagerDuty,
    );
  }

  factory DevOpsIncident.fromGitHub(Map<String, dynamic> json) {
    final workflowRun = json['workflow_run'] as Map<String, dynamic>? ?? {};
    final id =
        'gh-${workflowRun['id'] ?? DateTime.now().millisecondsSinceEpoch}';
    final name = workflowRun['name'] as String? ?? 'Build Workflow';
    final repo =
        (json['repository'] as Map<String, dynamic>?)?['full_name']
            as String? ??
        'github-repo';
    final headBranch = workflowRun['head_branch'] as String? ?? 'main';
    return DevOpsIncident(
      id: id,
      title: 'Workflow Run Failed: ${name}',
      description:
          'The production deployment workflow on branch "${headBranch}" failed.',
      status: IncidentStatus.triggered,
      urgency: 'high',
      serviceData: repo,
      createdAt: DateTime.now(),
      provider: IncidentProvider.githubActions,
    );
  }

  factory DevOpsIncident.fromAWS(Map<String, dynamic> json) {
    final alarmName = json['AlarmName'] as String? ?? 'AWS CloudWatch Alarm';
    final alarmDescription =
        json['AlarmDescription'] as String? ??
        'An AWS CloudWatch Alarm has triggered.';
    final id = 'aws-${DateTime.now().millisecondsSinceEpoch}';
    final trigger = json['Trigger'] as Map<String, dynamic>? ?? {};
    final metricName = trigger['MetricName'] as String? ?? 'EC2 Instance';
    return DevOpsIncident(
      id: id,
      title: alarmName,
      description: alarmDescription,
      status: IncidentStatus.triggered,
      urgency: 'critical',
      serviceData: 'AWS: ${metricName}',
      createdAt: DateTime.now(),
      provider: IncidentProvider.aws,
    );
  }

  factory DevOpsIncident.fromGCP(Map<String, dynamic> json) {
    final incident = json['incident'] as Map<String, dynamic>? ?? {};
    final id =
        'gcp-${incident['incident_id'] ?? DateTime.now().millisecondsSinceEpoch}';
    final policyName =
        incident['policy_name'] as String? ?? 'GCP Policy Triggered';
    final resourceName = incident['resource_name'] as String? ?? 'GCP Resource';
    final summary =
        incident['summary'] as String? ?? 'GCP Monitoring alert triggered.';
    return DevOpsIncident(
      id: id,
      title: policyName,
      description: summary,
      status: IncidentStatus.triggered,
      urgency: 'medium',
      serviceData: 'GCP: ${resourceName}',
      createdAt: DateTime.now(),
      provider: IncidentProvider.gcp,
    );
  }

  factory DevOpsIncident.fromAzure(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final essentials = data['essentials'] as Map<String, dynamic>? ?? {};
    final id =
        'azure-${essentials['alertId'] ?? DateTime.now().millisecondsSinceEpoch}';
    final alertName =
        essentials['alertRule'] as String? ?? 'Azure Monitor Alert';
    final resource =
        essentials['targetResource'] as String? ?? 'Azure Resource';
    final severity = essentials['severity'] as String? ?? 'Sev1';
    return DevOpsIncident(
      id: id,
      title: alertName,
      description:
          'Azure Monitor alert triggered for ${resource}. Severity: ${severity}',
      status: IncidentStatus.triggered,
      urgency: severity == 'Sev0' || severity == 'Sev1' ? 'critical' : 'high',
      serviceData: 'Azure: ${resource.split('/').last}',
      createdAt: DateTime.now(),
      provider: IncidentProvider.azure,
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

  final DateTime? resolvedAt;

  DevOpsIncident copyWith({
    String? id,
    String? title,
    String? description,
    IncidentStatus? status,
    String? urgency,
    String? serviceData,
    DateTime? createdAt,
    IncidentProvider? provider,
    DateTime? resolvedAt,
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
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.name,
      'urgency': urgency,
      'serviceData': serviceData,
      'createdAt': createdAt.toIso8601String(),
      'provider': provider.name,
      'resolvedAt': resolvedAt?.toIso8601String(),
    };
  }
}

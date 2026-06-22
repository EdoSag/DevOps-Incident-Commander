import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart' hide Border, BoxDecoration;
import 'package:devops_incident_commander_dashboard/models/dev_ops_incident.dart';
import 'package:devops_incident_commander_dashboard/incident_provider.dart';
import 'package:devops_incident_commander_dashboard/incident_status.dart';
import 'package:devops_incident_commander_dashboard/models/incident_comment.dart';
import 'package:devops_incident_commander_dashboard/globals/app_state.dart';
import 'package:devops_incident_commander_dashboard/user_role.dart';
import 'package:go_router/go_router.dart';

@NowaGenerated()
class IncidentDetailScreen extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const IncidentDetailScreen({super.key, required this.incident});

  final DevOpsIncident incident;

  @override
  State<IncidentDetailScreen> createState() {
    return _IncidentDetailScreenState();
  }
}

@NowaGenerated()
class _IncidentDetailScreenState extends State<IncidentDetailScreen> {
  late final TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  String _getMockStackTrace(DevOpsIncident inc) {
    final timestamp = inc.createdAt.toIso8601String();
    switch (inc.provider) {
      case IncidentProvider.aws:
        return '[FATAL] ${timestamp} - AWS CloudWatch Alert Triggered\n[ERROR] AlarmName: ${inc.title}\n[ERROR] MetricName: CPUUtilization\n[ERROR] Dimensions: [InstanceId: i-0f12a]\n[WARN] Connection pool exhausted on target server. Active: 1024, Pending: 450.\n[WARN] health_check.go:82 - HTTP Probe failed: Timeout of 5000ms exceeded.\nat github.com/ops/auth-service/v2/db.getConnection(db.go:42)\nat github.com/ops/auth-service/v2/handlers.LoginHandler(login.go:108)\n[SYS-ALERT] Auto-scaling trigger initiated, but target subnet is out of IPs.\n[SYS-WARN] Subnet ID: subnet-0f12a89 - 0 available IP addresses in IPAM.\n';
      case IncidentProvider.gcp:
        return '[FATAL] ${timestamp} - GCP Cloud Monitoring Incident\n[ERROR] Policy: ${inc.title}\n[ERROR] Resource Type: gcloud_run_revision\n[ERROR] Container crashed: Out of Memory (OOM) Killed.\n[INFO] Container instance exited with code 137 (OOMKilled).\n[WARN] Heap size exceeded 512MB limit. Memory utilization at 104.2%.\nat /app/node_modules/express/lib/router/index.js:284:7\nat /app/server.js:45:12\n[SYS-INFO] Route fallback initiated. Latency threshold exceeded 5000ms.\n';
      case IncidentProvider.azure:
        return '[FATAL] ${timestamp} - Azure Monitor Alert Rule Fired\n[ERROR] AlertRule: ${inc.title}\n[ERROR] TargetResource: /subscriptions/abc/resourceGroups/prod/providers/Microsoft.DBforPostgreSQL\n[WARN] PostgreSQL replication lag exceeded threshold of 15s. Current lag: 42.1s.\n[WARN] Replication stream broken between master replica and read node.\n[ERROR] Connection failed: connection timed out.\nat Microsoft.Azure.PostgreSQL.Connection.Open()\nat App.DataAccess.SqlConnector.ExecuteQuery(String sql)\n';
      case IncidentProvider.githubActions:
        return '[FATAL] ${timestamp} - GitHub Action Workflow Run Failed\n[INFO] Repo: ${inc.serviceData}\n[INFO] Workflow: Production Build & Deploy\n[INFO] Job: deploy_to_prod (Run #1489)\n[ERROR] Step: "Run Migrations" returned exit code 1.\n[ERROR] stderr: psql: error: connection to server on port 5432 failed: Connection refused.\n[ERROR] Is the database running on host and accepting TCP/IP connections?\n[SYS-WARN] Workflow execution halted. Automatic rollback triggered.\n';
      case IncidentProvider.pagerDuty:
        return '[FATAL] ${timestamp} - PagerDuty Webhook v3 Incident Triggered\n[INFO] Service: ${inc.serviceData}\n[INFO] Alert Summary: ${inc.title}\n[WARN] Third-party payment gateway integration reporting 504 Gateway Timeouts.\n[WARN] HTTP POST to https://api.stripe.com/v3/charges failed. Retry #3.\n[ERROR] Rate of transaction failure exceeded 12% in the last 5 minutes.\nat Stripe.WebhookHandler.ProcessEvent(StripeEvent event)\nat BillingService.Controllers.WebhookController.Post()\n';
    }
  }

  Color _getProviderColor(IncidentProvider provider) {
    switch (provider) {
      case IncidentProvider.aws:
        return Colors.orange.shade700;
      case IncidentProvider.gcp:
        return Colors.green.shade600;
      case IncidentProvider.azure:
        return Colors.blue.shade600;
      case IncidentProvider.githubActions:
        return Colors.blueGrey.shade800;
      case IncidentProvider.pagerDuty:
        return Colors.red.shade600;
    }
  }

  Color _getStatusColor(IncidentStatus status) {
    switch (status) {
      case IncidentStatus.triggered:
        return Colors.red.shade600;
      case IncidentStatus.acknowledged:
        return Colors.amber.shade600;
      case IncidentStatus.escalated:
        return Colors.deepOrange.shade800;
      case IncidentStatus.resolved:
        return Colors.green.shade600;
    }
  }

  Widget _buildTimelineStep(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isActive,
    required Color color,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? color
                    : (isActive
                          ? color.withOpacity(0.2)
                          : Colors.grey.shade800),
                border: Border.all(
                  color: isCompleted || isActive ? color : Colors.grey.shade600,
                  width: 2,
                ),
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive ? color : Colors.transparent,
                        ),
                      ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted ? color : Colors.grey.shade800,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isCompleted || isActive
                      ? Colors.white
                      : Colors.grey.shade500,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade400),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommentBubble(IncidentComment comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF0F111A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1E2235)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                comment.userName,
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
              Text(
                '${comment.createdAt.hour.toString().padLeft(2, '0')}:${comment.createdAt.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(color: Colors.grey, fontSize: 9),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            comment.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final freshIncident = appState.incidents.firstWhere(
      (i) => i.id == widget.incident.id,
      orElse: () => widget.incident,
    );
    final isViewer = appState.currentUserRole == UserRole.viewer;
    final isTriggered = freshIncident.status == IncidentStatus.triggered;
    final isAcknowledged = freshIncident.status == IncidentStatus.acknowledged;
    final isEscalated = freshIncident.status == IncidentStatus.escalated;
    final isResolved = freshIncident.status == IncidentStatus.resolved;
    final createdTimeFormatted =
        '${freshIncident.createdAt.hour.toString().padLeft(2, '0')}:${freshIncident.createdAt.minute.toString().padLeft(2, '0')}:${freshIncident.createdAt.second.toString().padLeft(2, '0')}';
    return Scaffold(
      backgroundColor: const Color(0xFF0F111A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141724),
        elevation: 0,
        title: Text(
          'Incident Details',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/home-page');
            }
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(freshIncident.status).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getStatusColor(freshIncident.status).withOpacity(0.4),
                ),
              ),
              child: Text(
                freshIncident.status.displayName,
                style: TextStyle(
                  color: _getStatusColor(freshIncident.status),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (isViewer)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 16,
                ),
                color: Colors.red.shade900.withOpacity(0.9),
                child: const Row(
                  children: const [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'READ-ONLY VIEWER MODE: Actions and comments are restricted.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 4,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _getStatusColor(freshIncident.status),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                freshIncident.title,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getProviderColor(
                                        freshIncident.provider,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      freshIncident.provider.displayName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E2235),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      freshIncident.serviceData,
                                      style: TextStyle(
                                        color: Colors.blueGrey.shade200,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141724),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF1E2235)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.person_pin_rounded,
                                color: Colors.blueAccent.shade400,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Incident Owner',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    freshIncident.assignedTo?.name ??
                                        'Unassigned',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              icon: const Icon(
                                Icons.assignment_ind_outlined,
                                color: Colors.blueAccent,
                              ),
                              onChanged: isViewer
                                  ? null
                                  : (value) {
                                      if (value != null) {
                                        appState.assignIncident(
                                          freshIncident.id,
                                          value!,
                                        );
                                      }
                                    },
                              items: appState.teamRoster
                                  .map(
                                    (member) => DropdownMenuItem<String>(
                                      value: member.id,
                                      child: Text(
                                        member.name,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141724),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'DESCRIPTION',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            freshIncident.description,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.grey.shade300,
                                  height: 1.4,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'STACK TRACE / OPERATIONAL LOGS',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF070913),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade900),
                      ),
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 180),
                        child: SingleChildScrollView(
                          child: SelectableText(
                            _getMockStackTrace(freshIncident),
                            style: const TextStyle(
                              color: Color(0xFFD4D4D4),
                              fontFamily: 'Courier',
                              fontSize: 11,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'COLLABORATIVE WAR ROOM NOTES',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141724),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF1E2235)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (freshIncident.comments.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'No war-room logs written. Be the first to comment.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            )
                          else
                            Container(
                              constraints: const BoxConstraints(maxHeight: 180),
                              child: ListView(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                children: freshIncident.comments
                                    .map(
                                      (comment) => _buildCommentBubble(comment),
                                    )
                                    .toList(),
                              ),
                            ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _commentController,
                                  enabled: !isViewer,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: isViewer
                                        ? 'Commenting is restricted in Viewer mode.'
                                        : 'Enter war-room update note...',
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 11,
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFF0F111A),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF1E2235),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: isViewer
                                    ? null
                                    : () {
                                        if (_commentController.text
                                            .trim()
                                            .isNotEmpty) {
                                          appState.addIncidentComment(
                                            freshIncident.id,
                                            _commentController.text,
                                          );
                                          _commentController.clear();
                                          FocusScope.of(context).unfocus();
                                        }
                                      },
                                icon: const Icon(
                                  Icons.send_rounded,
                                  color: Colors.blueAccent,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'INCIDENT LIFECYCLE TIMELINE',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141724),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildTimelineStep(
                            context,
                            title: 'Incident Triggered',
                            subtitle:
                                'Automated alert received from ${freshIncident.provider.displayName} monitoring webhook at ${createdTimeFormatted}.',
                            isCompleted: true,
                            isActive: false,
                            color: Colors.red.shade600,
                          ),
                          _buildTimelineStep(
                            context,
                            title: isEscalated
                                ? 'Incident Escalated'
                                : 'Incident Acknowledged',
                            subtitle: isEscalated
                                ? 'Incident escalated to Tier 3 Lead DevOps Engineer.'
                                : (isAcknowledged || isResolved
                                      ? 'On-call engineer acknowledged incident.'
                                      : 'Awaiting operator acknowledgment.'),
                            isCompleted:
                                isAcknowledged || isEscalated || isResolved,
                            isActive: isTriggered,
                            color: isEscalated
                                ? Colors.deepOrange.shade800
                                : Colors.amber.shade600,
                          ),
                          _buildTimelineStep(
                            context,
                            title: 'Incident Resolved',
                            subtitle: isResolved
                                ? 'Marked as resolved. System telemetry back to normal operating thresholds.'
                                : 'Awaiting resolution actions.',
                            isCompleted: isResolved,
                            isActive: isAcknowledged || isEscalated,
                            color: Colors.green.shade600,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF141724),
                border: Border(
                  top: BorderSide(color: Color(0xFF1E2235), width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isResolved || isEscalated || isViewer
                          ? null
                          : () async {
                              await appState.escalateIncident(freshIncident.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.deepOrange.shade900,
                                  content: const Text(
                                    'Incident escalated to Tier 3 Support.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                      icon: const Icon(Icons.warning_amber_rounded, size: 18),
                      label: const Text('ESCALATE'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.deepOrange.shade400,
                        disabledForegroundColor: Colors.grey.shade700,
                        side: BorderSide(
                          color: isResolved || isEscalated || isViewer
                              ? Colors.grey.shade800
                              : Colors.deepOrange.shade600,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: isResolved || isViewer
                          ? null
                          : () async {
                              await appState.resolveIncident(freshIncident.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green.shade900,
                                  content: const Text(
                                    'Incident marked as Resolved.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: const Text('RESOLVE'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade800,
                        disabledForegroundColor: Colors.grey.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

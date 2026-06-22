import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart' hide Border, BoxDecoration;
import 'package:devops_incident_commander_dashboard/incident_provider.dart';
import 'package:devops_incident_commander_dashboard/incident_status.dart';
import 'package:devops_incident_commander_dashboard/globals/app_state.dart';
import 'package:go_router/go_router.dart';
import 'package:devops_incident_commander_dashboard/user_role.dart';

@NowaGenerated()
class HomePage extends StatelessWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const HomePage({super.key});

  String _getRelativeTime(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.isNegative) {
      return 'just now';
    }
    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  Color _getProviderColor(IncidentProvider provider) {
    switch (provider) {
      case IncidentProvider.aws:
        return const Color(0xFFFF9900);
      case IncidentProvider.gcp:
        return const Color(0xFF0F9D58);
      case IncidentProvider.azure:
        return const Color(0xFF007FFF);
      case IncidentProvider.githubActions:
        return const Color(0xFF24292E);
      case IncidentProvider.pagerDuty:
        return const Color(0xFFDF1D24);
    }
  }

  Color _getStatusColor(IncidentStatus status) {
    switch (status) {
      case IncidentStatus.triggered:
        return const Color(0xFFEF5350);
      case IncidentStatus.acknowledged:
        return const Color(0xFFFFB74D);
      case IncidentStatus.escalated:
        return const Color(0xFFD32F2F);
      case IncidentStatus.resolved:
        return const Color(0xFF66BB6A);
    }
  }

  Color _getMemberColor(String memberId) {
    const palette = [
      Color(0xFFEF5350),
      Color(0xFFFFB74D),
      Color(0xFF42A5F5),
      Color(0xFFAB47BC),
      Color(0xFF66BB6A),
    ];
    return palette[memberId.hashCode.abs() % palette.length];
  }

  Widget _buildKpiCard(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF141724),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 14, color: color),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.4,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF141724),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E2235)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF1E2235),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 45,
                        height: 14,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2235),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 70,
                        height: 14,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2235),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2235),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 60,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2235),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        width: 75,
                        height: 20,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2235),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadarTab(BuildContext context, AppState appState) {
    final incidents = appState.incidents;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildKpiCard(
                context,
                label: 'ACTIVE INCIDENTS',
                value: '${appState.activeIncidentsCount}',
                color: const Color(0xFFEF5350),
                icon: Icons.notifications_active_outlined,
              ),
              const SizedBox(width: 8),
              _buildKpiCard(
                context,
                label: 'TRIGGERED ALERTS',
                value: '${appState.triggeredAlertsCount}',
                color: const Color(0xFFFFB74D),
                icon: Icons.error_outline_rounded,
              ),
              const SizedBox(width: 8),
              _buildKpiCard(
                context,
                label: 'SYSTEM UPTIME',
                value: appState.systemUptime,
                color: const Color(0xFF66BB6A),
                icon: Icons.speed_outlined,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'ACTIVE INFRASTRUCTURE RADAR',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: appState.isLoading
                ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (context, index) => _buildSkeletonItem(),
                  )
                : incidents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: ShapeDecoration(
                            color: const Color(0xFF66BB6A).withOpacity(0.1),
                            shape: CircleBorder(
                              side: BorderSide(
                                color: const Color(
                                  0xFF66BB6A,
                                ).withOpacity(0.25),
                                width: 2,
                              ),
                            ),
                          ),
                          child: const Icon(
                            Icons.verified_user_outlined,
                            size: 48,
                            color: Color(0xFF66BB6A),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'All Systems Operational',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'No active production failures or deployment blocks reported.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.grey.shade400,
                                  height: 1.4,
                                ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () => appState.loadIncidents(),
                          icon: const Icon(Icons.sync),
                          label: const Text('Simulate Webhook Fetch'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E2235),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(color: Color(0xFF333852)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: incidents.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final incident = incidents[index];
                      final barColor = _getStatusColor(incident.status);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141724),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF1E2235),
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: () {
                              context.push('/incident-detail', extra: incident);
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 110,
                                  color: barColor,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 3,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: _getProviderColor(
                                                      incident.provider,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    incident
                                                        .provider
                                                        .displayName,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  incident.serviceData,
                                                  style: TextStyle(
                                                    color: Colors
                                                        .blueGrey
                                                        .shade300,
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (incident.assignedToMember !=
                                                null)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: _getMemberColor(
                                                    incident
                                                        .assignedToMember!
                                                        .id,
                                                  ).withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  border: Border.all(
                                                    color: _getMemberColor(
                                                      incident
                                                          .assignedToMember!
                                                          .id,
                                                    ).withOpacity(0.3),
                                                  ),
                                                ),
                                                child: Text(
                                                  incident.assignedToMember!
                                                      .resolvedDisplayName
                                                      .split(' ')
                                                      .first,
                                                  style: TextStyle(
                                                    color: _getMemberColor(
                                                      incident
                                                          .assignedToMember!
                                                          .id,
                                                    ),
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          incident.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          incident.description,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Colors.grey.shade400,
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.access_time_rounded,
                                                  size: 11,
                                                  color: Colors.grey.shade500,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  _getRelativeTime(
                                                    incident.createdAt,
                                                  ),
                                                  style: TextStyle(
                                                    color: Colors.grey.shade500,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                if (incident
                                                    .comments
                                                    .isNotEmpty) ...[
                                                  const SizedBox(width: 12),
                                                  Icon(
                                                    Icons
                                                        .chat_bubble_outline_rounded,
                                                    size: 11,
                                                    color: Colors.grey.shade500,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '${incident.comments.length}',
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade500,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                            if (incident.status ==
                                                IncidentStatus.triggered)
                                              SizedBox(
                                                height: 26,
                                                child: ElevatedButton(
                                                  onPressed:
                                                      appState.currentUserRole ==
                                                          UserRole.viewer
                                                      ? null
                                                      : () => appState
                                                            .acknowledgeIncident(
                                                              incident.id,
                                                            ),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFFFFB74D),
                                                    foregroundColor:
                                                        Colors.black,
                                                    elevation: 0,
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                        ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'Acknowledge',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            else if (incident.status ==
                                                IncidentStatus.resolved)
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.check_circle,
                                                    size: 12,
                                                    color: Color(0xFF66BB6A),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    'Resolved',
                                                    style: TextStyle(
                                                      color:
                                                          Colors.green.shade400,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            else
                                              Text(
                                                incident.status.displayName,
                                                style: TextStyle(
                                                  color: _getStatusColor(
                                                    incident.status,
                                                  ),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsProgressBar(
    String label,
    double percentage,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${(percentage * 100).toInt()}%',
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: percentage,
            backgroundColor: const Color(0xFF1E2235),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) {
      return 'No Available Data';
    }
    if (duration.inMinutes < 60) {
      return '${duration.inMinutes} Min';
    }
    final hours = duration.inMinutes / 60;
    return '${hours.toStringAsFixed(1)} Hr';
  }

  Widget _buildAnalyticsTab(BuildContext context, AppState appState) {
    final analytics = appState.analytics;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Operational Service Metrics'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF141724),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1E2235)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MTTA',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDuration(analytics.meanTimeToAcknowledge),
                            style: const TextStyle(
                              color: Color(0xFFFFB74D),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Mean Time to Acknowledge',
                            style: TextStyle(color: Colors.grey, fontSize: 9),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 50,
                      color: const Color(0xFF1E2235),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MTTR',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDuration(analytics.meanTimeToResolve),
                            style: const TextStyle(
                              color: Color(0xFF66BB6A),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Mean Time to Resolve',
                            style: TextStyle(color: Colors.grey, fontSize: 9),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildSectionHeader('Incident Volume by Provider'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF141724),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1E2235)),
            ),
            child: analytics.totalIncidents == 0
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'No Available Data',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  )
                : Column(
                    children: [
                      _buildAnalyticsProgressBar(
                        'AWS CloudWatch',
                        analytics.providerPercentage(IncidentProvider.aws),
                        const Color(0xFFFF9900),
                      ),
                      _buildAnalyticsProgressBar(
                        'GCP Cloud Monitoring',
                        analytics.providerPercentage(IncidentProvider.gcp),
                        const Color(0xFF0F9D58),
                      ),
                      _buildAnalyticsProgressBar(
                        'Azure Monitor',
                        analytics.providerPercentage(IncidentProvider.azure),
                        const Color(0xFF007FFF),
                      ),
                      _buildAnalyticsProgressBar(
                        'GitHub Actions',
                        analytics.providerPercentage(
                          IncidentProvider.githubActions,
                        ),
                        const Color(0xFF24292E),
                      ),
                      _buildAnalyticsProgressBar(
                        'PagerDuty',
                        analytics.providerPercentage(
                          IncidentProvider.pagerDuty,
                        ),
                        const Color(0xFFDF1D24),
                      ),
                    ],
                  ),
          ),
          _buildSectionHeader('Operational Efficiency'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF141724),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1E2235)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.grey,
                      size: 24,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'No Available Data',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'SLO Integrity',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Icon(
                      Icons.flash_on_rounded,
                      color: Colors.grey,
                      size: 24,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'No Available Data',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Auto-Remediation',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Icon(
                      Icons.groups_outlined,
                      color: Colors.blueAccent,
                      size: 24,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDuration(analytics.meanTimeToAssignment),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Avg Assignment',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRosterTab(BuildContext context, AppState appState) {
    final members = appState.organizationMembers;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Organization Members'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF141724),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1E2235)),
            ),
            child: members.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'No Available Data',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                  )
                : Column(
                    children: members
                        .map(
                          (member) => Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: _getMemberColor(
                                    member.id,
                                  ).withOpacity(0.15),
                                  child: Text(
                                    member.resolvedDisplayName
                                        .split(' ')
                                        .where((p) => p.isNotEmpty)
                                        .map((e) => e[0])
                                        .take(2)
                                        .join(),
                                    style: TextStyle(
                                      color: _getMemberColor(member.id),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  member.resolvedDisplayName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  member.role.displayName,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              if (member != members.last)
                                const Divider(
                                  color: Color(0xFF1E2235),
                                  indent: 70,
                                ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
          ),
          _buildSectionHeader('Your Access Level'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF141724),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1E2235)),
            ),
            child: Row(
              children: [
                Icon(
                  appState.currentUserRole == UserRole.viewer
                      ? Icons.lock_outline_rounded
                      : Icons.lock_open_rounded,
                  size: 16,
                  color: appState.currentUserRole == UserRole.viewer
                      ? const Color(0xFFEF5350)
                      : const Color(0xFF66BB6A),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    appState.currentUserRole == UserRole.viewer
                        ? 'Viewer: Read-only. All actions (Acknowledge, Escalate, Resolve, Assign, Comments) are disabled.'
                        : appState.currentUserRole == UserRole.commander
                        ? 'Commander: Full operational and organization-management access.'
                        : 'Responder: Full operational mutations and collaboration enabled.',
                    style: TextStyle(
                      color: appState.currentUserRole == UserRole.viewer
                          ? const Color(0xFFEF5350)
                          : const Color(0xFF66BB6A),
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (appState.currentUserRole == UserRole.commander)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Manage roles, invites, and QR approvals from Settings → Organization.',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.blueGrey,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF0F111A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141724),
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEF5350),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'INCIDENT COMMANDER',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              context.push('/settings');
            },
          ),
          IconButton(
            icon: appState.isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.refresh, color: Colors.white),
            onPressed: appState.isLoading
                ? null
                : () => appState.loadIncidents(),
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: appState.currentTabIndex,
          children: [
            _buildRadarTab(context, appState),
            _buildAnalyticsTab(context, appState),
            _buildRosterTab(context, appState),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF141724),
        currentIndex: appState.currentTabIndex,
        onTap: (index) => appState.setTabIndex(index),
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.blueGrey,
        selectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.radar_rounded),
            label: 'Incident Radar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            label: 'Team Roster',
          ),
        ],
      ),
    );
  }
}

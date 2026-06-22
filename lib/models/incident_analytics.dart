import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:devops_incident_commander_dashboard/incident_provider.dart';

@NowaGenerated()
class IncidentAnalytics {
  const IncidentAnalytics({
    required this.totalIncidents,
    required this.providerCounts,
    this.meanTimeToAcknowledge,
    this.meanTimeToResolve,
    this.meanTimeToAssignment,
  });

  const IncidentAnalytics.empty()
    : totalIncidents = 0,
      providerCounts = const {},
      meanTimeToAcknowledge = null,
      meanTimeToResolve = null,
      meanTimeToAssignment = null;

  final int totalIncidents;

  final Map<IncidentProvider, int> providerCounts;

  final Duration? meanTimeToAcknowledge;

  final Duration? meanTimeToResolve;

  final Duration? meanTimeToAssignment;

  double providerPercentage(IncidentProvider provider) {
    if (totalIncidents == 0) {
      return 0;
    }
    return (providerCounts[provider] ?? 0) / totalIncidents;
  }
}

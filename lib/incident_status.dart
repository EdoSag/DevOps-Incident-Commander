import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
enum IncidentStatus {
  triggered,
  acknowledged,
  escalated,
  resolved;

  String get displayName {
    switch (this) {
      case IncidentStatus.triggered:
        return 'Triggered';
      case IncidentStatus.acknowledged:
        return 'Acknowledged';
      case IncidentStatus.escalated:
        return 'Escalated';
      case IncidentStatus.resolved:
        return 'Resolved';
    }
  }
}

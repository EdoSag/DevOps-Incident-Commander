import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
enum IncidentProvider {
  gcp,
  aws,
  azure,
  githubActions,
  pagerDuty;

  String get displayName {
    switch (this) {
      case IncidentProvider.gcp:
        return 'GCP';
      case IncidentProvider.aws:
        return 'AWS';
      case IncidentProvider.azure:
        return 'Azure';
      case IncidentProvider.githubActions:
        return 'GitHub Actions';
      case IncidentProvider.pagerDuty:
        return 'PagerDuty';
    }
  }
}

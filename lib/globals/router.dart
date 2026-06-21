import 'package:go_router/go_router.dart';
import 'package:devops_incident_commander_dashboard/pages/home_page.dart';
import 'package:devops_incident_commander_dashboard/models/dev_ops_incident.dart';
import 'package:devops_incident_commander_dashboard/pages/incident_detail_screen.dart';
import 'package:devops_incident_commander_dashboard/pages/settings_screen.dart';
import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
final GoRouter appRouter = GoRouter(
  initialLocation: '/home-page',
  routes: [
    GoRoute(path: '/home-page', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/incident-detail',
      builder: (context, state) {
        final incident = state.extra as DevOpsIncident;
        return IncidentDetailScreen(incident: incident);
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

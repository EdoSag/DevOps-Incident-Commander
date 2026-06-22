import 'package:go_router/go_router.dart';
import 'package:devops_incident_commander_dashboard/pages/home_page.dart';
import 'package:devops_incident_commander_dashboard/models/dev_ops_incident.dart';
import 'package:devops_incident_commander_dashboard/pages/incident_detail_screen.dart';
import 'package:devops_incident_commander_dashboard/pages/settings_screen.dart';
import 'package:devops_incident_commander_dashboard/pages/onboarding_screen.dart';
import 'package:devops_incident_commander_dashboard/pages/qr_scan_screen.dart';
import 'package:devops_incident_commander_dashboard/globals/app_state.dart';
import 'package:nowa_runtime/nowa_runtime.dart';

GoRouter? _cachedRouter;

@NowaGenerated()
GoRouter routerFor(AppState appState) {
  return _cachedRouter ??= _buildAppRouter(appState);
}

GoRouter _buildAppRouter(AppState appState) {
  return GoRouter(
    initialLocation: '/home-page',
    refreshListenable: appState,
    redirect: (context, state) {
      final loggedIn = appState.currentUser != null;
      final atOnboarding = state.matchedLocation == '/onboarding';
      if (!loggedIn || appState.isLoadingOrg) {
        return null;
      }
      if (!appState.hasOrganization && !atOnboarding) {
        return '/onboarding';
      }
      if (appState.hasOrganization && atOnboarding) {
        return '/home-page';
      }
      return null;
    },
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
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/org-scan',
        builder: (context, state) => const QrScanScreen(),
      ),
    ],
  );
}

import 'package:shared_preferences/shared_preferences.dart';
import 'package:devops_incident_commander_dashboard/integrations/supabase_service.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:devops_incident_commander_dashboard/globals/app_state.dart';
import 'package:devops_incident_commander_dashboard/globals/router.dart';

@NowaGenerated()
late final SharedPreferences sharedPrefs;

@NowaGenerated()
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPrefs = await SharedPreferences.getInstance();
  try {
    await SupabaseService().initialize();
  } catch (e) {
    debugPrint('Supabase initialization failed: $e');
  }
  runApp(const MyApp());
}

@NowaGenerated({'visibleInNowa': false})
class MyApp extends StatelessWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (context) => AppState()),
      ],
      builder: (context, child) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppState.of(context).theme,
        routerConfig: appRouter,
      ),
    );
  }
}

import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
enum UserRole {
  viewer,
  responder,
  commander;

  String get displayName {
    switch (this) {
      case UserRole.viewer:
        return 'Viewer (Read-Only)';
      case UserRole.responder:
        return 'Responder';
      case UserRole.commander:
        return 'Incident Commander';
    }
  }
}

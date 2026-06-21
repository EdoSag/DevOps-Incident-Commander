import 'package:dio/dio.dart';
import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated({'editor': 'api'})
class DevOpsIntegrations {
  factory DevOpsIntegrations() {
    return _instance;
  }

  DevOpsIntegrations._();

  final Dio _dioClient = Dio();

  @NowaGenerated({'loader': 'api_client_getter'})
  Dio get dioClient {
    return _dioClient;
  }

  static final DevOpsIntegrations _instance = DevOpsIntegrations._();

  Future<Response<dynamic>> fetchGitHubActionsRuns() async {
    final Response res = await dioClient.get(
      'https://api.github.com/repos/octocat/hello-world/actions/runs?per_page=5',
      options: Options(headers: {'Accept': 'application/vnd.github+json'}),
    );
    return res;
  }
}

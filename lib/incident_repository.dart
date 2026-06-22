import 'package:dio/dio.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:devops_incident_commander_dashboard/models/dev_ops_incident.dart';
import 'package:devops_incident_commander_dashboard/incident_status.dart';
import 'package:devops_incident_commander_dashboard/incident_provider.dart';
import 'package:flutter/material.dart';

@NowaGenerated()
class IncidentRepository {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  String _getAmzDate(DateTime dt) {
    return dt
            .toUtc()
            .toIso8601String()
            .replaceAll('-', '')
            .replaceAll(':', '')
            .split('.')
            .first +
        'Z';
  }

  String _getDateStamp(DateTime dt) {
    return dt.toUtc().toIso8601String().replaceAll('-', '').split('T').first;
  }

  List<int> _hmacSha256(List<int> key, String data) {
    final hmac = Hmac(sha256, key);
    return hmac.convert(utf8.encode(data)).bytes;
  }

  String _hmacSha256Hex(List<int> key, String data) {
    final hmac = Hmac(sha256, key);
    return hmac.convert(utf8.encode(data)).toString();
  }

  String _sha256Hex(String data) {
    return sha256.convert(utf8.encode(data)).toString();
  }

  Map<String, String> _getAwsSigV4Headers({
    required String accessKey,
    required String secretKey,
    required String region,
    required String service,
    required String method,
    required String host,
    required String uri,
    required Map<String, String> queryParams,
    required String payload,
  }) {
    final now = DateTime.now();
    final amzDate = _getAmzDate(now);
    final dateStamp = _getDateStamp(now);
    final sortedKeys = queryParams.keys.toList()..sort();
    final canonicalQuery = sortedKeys
        .map((key) => '${key}=${Uri.encodeComponent(queryParams[key]!)}')
        .join('&');
    final canonicalHeaders = 'host:${host}\nx-amz-date:${amzDate}\n';
    final signedHeaders = 'host;x-amz-date';
    final payloadHash = _sha256Hex(payload);
    final canonicalRequest =
        '${method}\n${uri}\n${canonicalQuery}\n${canonicalHeaders}\n${signedHeaders}\n${payloadHash}';
    final credentialScope = '${dateStamp}/${region}/${service}/aws4_request';
    final stringToSign =
        'AWS4-HMAC-SHA256\n${amzDate}\n${credentialScope}\n${_sha256Hex(canonicalRequest)}';
    final kDate = _hmacSha256(utf8.encode('AWS4${secretKey}'), dateStamp);
    final kRegion = _hmacSha256(kDate, region);
    final kService = _hmacSha256(kRegion, service);
    final kSigning = _hmacSha256(kService, 'aws4_request');
    final signature = _hmacSha256Hex(kSigning, stringToSign);
    return {
      'Host': host,
      'X-Amz-Date': amzDate,
      'Authorization':
          'AWS4-HMAC-SHA256 Credential=${accessKey}/${credentialScope}, SignedHeaders=${signedHeaders}, Signature=${signature}',
    };
  }

  Future<Map<String, dynamic>> testGitHubConnection(
    String owner,
    String repo,
    String token,
  ) async {
    if (owner.isEmpty || repo.isEmpty) {
      return {
        'success': false,
        'message': 'Owner and Repository name are required',
      };
    }
    try {
      final headers = {
        'Accept': 'application/vnd.github+json',
        'User-Agent': 'DevOpsIncidentCommanderDashboard',
      };
      if (token.isNotEmpty) {
        headers['Authorization'] = 'Bearer ${token}';
      }
      final response = await _dio.get(
        'https://api.github.com/repos/${owner}/${repo}/actions/runs?per_page=1',
        options: Options(headers: headers),
      );
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Successfully connected to GitHub Actions!',
        };
      } else {
        return {
          'success': false,
          'message': 'GitHub returned status code: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        return {
          'success': false,
          'message': 'Unauthorized. Please check your Personal Access Token.',
        };
      } else if (e.response?.statusCode == 404) {
        return {
          'success': false,
          'message': 'Repository not found. Double check Owner & Repo Name.',
        };
      }
      return {
        'success': false,
        'message': e.message ?? 'Unknown connection error',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> testPagerDutyConnection(String token) async {
    if (token.isEmpty) {
      return {'success': false, 'message': 'PagerDuty API Token is required'};
    }
    try {
      final response = await _dio.get(
        'https://api.pagerduty.com/incidents?limit=1',
        options: Options(
          headers: {
            'Accept': 'application/vnd.pagerduty+json;version=2',
            'Authorization': 'Token token=${token}',
          },
        ),
      );
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Successfully connected to PagerDuty!',
        };
      } else {
        return {
          'success': false,
          'message': 'PagerDuty returned status code: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return {
          'success': false,
          'message': 'Unauthorized. Please check your PagerDuty API Token.',
        };
      }
      return {
        'success': false,
        'message': e.message ?? 'Unknown connection error',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> testAwsConnection({
    required String accessKey,
    required String secretKey,
    required String region,
  }) async {
    if (accessKey.isEmpty || secretKey.isEmpty || region.isEmpty) {
      return {
        'success': false,
        'message': 'Access Key, Secret Key, and Region are required.',
      };
    }
    try {
      final host = 'monitoring.${region}.amazonaws.com';
      final queryParams = {
        'Action': 'DescribeAlarms',
        'MaxRecords': '1',
        'Version': '2010-08-01',
      };
      final headers = _getAwsSigV4Headers(
        accessKey: accessKey,
        secretKey: secretKey,
        region: region,
        service: 'monitoring',
        method: 'GET',
        host: host,
        uri: '/',
        queryParams: queryParams,
        payload: '',
      );
      headers['Accept'] = 'application/json';
      final response = await _dio.get(
        'https://${host}/',
        queryParameters: queryParams,
        options: Options(headers: headers),
      );
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Successfully connected to AWS CloudWatch Alarms!',
        };
      } else {
        return {
          'success': false,
          'message': 'AWS returned status code: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        return {
          'success': false,
          'message':
              'Unauthorized. Please check your AWS credentials & permissions.',
        };
      }
      return {
        'success': false,
        'message': e.message ?? 'Unknown connection error',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> testAzureConnection({
    required String tenantId,
    required String clientId,
    required String clientSecret,
    required String subscriptionId,
  }) async {
    if (tenantId.isEmpty ||
        clientId.isEmpty ||
        clientSecret.isEmpty ||
        subscriptionId.isEmpty) {
      return {
        'success': false,
        'message':
            'Tenant ID, Client ID, Client Secret, and Subscription ID are required.',
      };
    }
    try {
      final authResponse = await _dio.post(
        'https://login.microsoftonline.com/${tenantId}/oauth2/v2.0/token',
        data: {
          'grant_type': 'client_credentials',
          'client_id': clientId,
          'client_secret': clientSecret,
          'scope': 'https://management.azure.com/.default',
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      final token = authResponse.data['access_token'] as String?;
      if (token == null) {
        return {
          'success': false,
          'message': 'Failed to retrieve Azure OAuth Access Token.',
        };
      }
      final alertsResponse = await _dio.get(
        'https://management.azure.com/subscriptions/${subscriptionId}/providers/Microsoft.AlertsManagement/alerts?api-version=2019-03-01&customTimeRange=1d',
        options: Options(headers: {'Authorization': 'Bearer ${token}'}),
      );
      if (alertsResponse.statusCode == 200) {
        return {
          'success': true,
          'message': 'Successfully connected to Azure Monitor Alerts!',
        };
      } else {
        return {
          'success': false,
          'message': 'Azure returned status code: ${alertsResponse.statusCode}',
        };
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        return {
          'success': false,
          'message':
              'Unauthorized. Please check Azure AD application permissions.',
        };
      } else if (e.response?.statusCode == 404) {
        return {'success': false, 'message': 'Subscription ID not found.'};
      }
      return {
        'success': false,
        'message': e.message ?? 'Unknown Azure connection error',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> testGcpConnection({
    required String projectId,
    required String tokenOrKey,
    required bool isApiKey,
  }) async {
    if (projectId.isEmpty || tokenOrKey.isEmpty) {
      return {
        'success': false,
        'message': 'GCP Project ID and Token/Key are required.',
      };
    }
    try {
      String url;
      Map<String, String> headers = {};
      if (isApiKey) {
        url =
            'https://monitoring.googleapis.com/v3/projects/${projectId}/alertPolicies?key=${tokenOrKey}';
      } else {
        url =
            'https://monitoring.googleapis.com/v3/projects/${projectId}/alertPolicies';
        headers['Authorization'] = 'Bearer ${tokenOrKey}';
      }
      final response = await _dio.get(url, options: Options(headers: headers));
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Successfully connected to GCP Cloud Monitoring!',
        };
      } else {
        return {
          'success': false,
          'message': 'GCP returned status code: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        return {
          'success': false,
          'message':
              'Unauthorized. Please verify your GCP Bearer Token or API Key.',
        };
      } else if (e.response?.statusCode == 404) {
        return {'success': false, 'message': 'Project ID not found.'};
      }
      return {
        'success': false,
        'message': e.message ?? 'Unknown GCP connection error',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<List<DevOpsIncident>> fetchRealIncidents({
    required String githubOwner,
    required String githubRepo,
    required String githubToken,
    required String pagerDutyToken,
    required String awsAccessKey,
    required String awsSecretKey,
    required String awsRegion,
    required String gcpProjectId,
    required String gcpTokenOrKey,
    required bool gcpIsApiKey,
    required String azureTenantId,
    required String azureClientId,
    required String azureClientSecret,
    required String azureSubscriptionId,
  }) async {
    final List<DevOpsIncident> list = [];
    if (githubOwner.isNotEmpty && githubRepo.isNotEmpty) {
      try {
        final headers = {
          'Accept': 'application/vnd.github+json',
          'User-Agent': 'DevOpsIncidentCommanderDashboard',
        };
        if (githubToken.isNotEmpty) {
          headers['Authorization'] = 'Bearer ${githubToken}';
        }
        final response = await _dio.get(
          'https://api.github.com/repos/${githubOwner}/${githubRepo}/actions/runs?per_page=10',
          options: Options(headers: headers),
        );
        if (response.statusCode == 200 && response.data != null) {
          final runs = response.data['workflow_runs'] as List<dynamic>? ?? [];
          for (var run in runs) {
            final conclusion = run['conclusion'] as String?;
            final status = run['status'] as String?;
            if (status == 'completed' && conclusion == 'failure') {
              final id = 'github-${run['id']}';
              final name = run['name'] as String? ?? 'Workflow Job';
              final branch = run['head_branch'] as String? ?? 'main';
              final createdAt = DateTime.parse(run['created_at'] as String);
              list.add(
                DevOpsIncident(
                  id: id,
                  title: 'GitHub Workflow Failed: ${name}',
                  description:
                      'Workflow run failed on branch "${branch}". View logs at GitHub Actions portal.',
                  status: IncidentStatus.triggered,
                  urgency: 'high',
                  serviceData: 'GitHub: ${githubOwner}/${githubRepo}',
                  createdAt: createdAt,
                  provider: IncidentProvider.githubActions,
                  rawProviderPayload: run as Map<String, dynamic>,
                ),
              );
            }
          }
        }
      } catch (e) {
        debugPrint('Error fetching GitHub: ${e}');
      }
    }
    if (pagerDutyToken.isNotEmpty) {
      try {
        final response = await _dio.get(
          'https://api.pagerduty.com/incidents?limit=10&statuses[]=triggered&statuses[]=acknowledged',
          options: Options(
            headers: {
              'Accept': 'application/vnd.pagerduty+json;version=2',
              'Authorization': 'Token token=${pagerDutyToken}',
            },
          ),
        );
        if (response.statusCode == 200 && response.data != null) {
          final incidents = response.data['incidents'] as List<dynamic>? ?? [];
          for (var inc in incidents) {
            final id = 'pd-${inc['id']}';
            final title = inc['title'] as String? ?? 'PagerDuty Alert';
            final desc =
                inc['description'] as String? ??
                inc['summary'] as String? ??
                'No details provided';
            final statusStr = inc['status'] as String? ?? 'triggered';
            final service = inc['service'] as Map<String, dynamic>? ?? {};
            final serviceName =
                service['summary'] as String? ?? 'pagerduty-service';
            final createdAt = DateTime.parse(inc['created_at'] as String);
            final urgency = inc['urgency'] as String? ?? 'high';
            IncidentStatus status = statusStr == 'acknowledged'
                ? IncidentStatus.acknowledged
                : IncidentStatus.triggered;
            list.add(
              DevOpsIncident(
                id: id,
                title: title,
                description: desc,
                status: status,
                urgency: urgency,
                serviceData: 'Service: ${serviceName}',
                createdAt: createdAt,
                provider: IncidentProvider.pagerDuty,
                rawProviderPayload: inc as Map<String, dynamic>,
              ),
            );
          }
        }
      } catch (e) {
        debugPrint('Error fetching PagerDuty: ${e}');
      }
    }
    if (awsAccessKey.isNotEmpty &&
        awsSecretKey.isNotEmpty &&
        awsRegion.isNotEmpty) {
      try {
        final host = 'monitoring.${awsRegion}.amazonaws.com';
        final queryParams = {
          'Action': 'DescribeAlarms',
          'Version': '2010-08-01',
        };
        final headers = _getAwsSigV4Headers(
          accessKey: awsAccessKey,
          secretKey: awsSecretKey,
          region: awsRegion,
          service: 'monitoring',
          method: 'GET',
          host: host,
          uri: '/',
          queryParams: queryParams,
          payload: '',
        );
        headers['Accept'] = 'application/json';
        final response = await _dio.get(
          'https://${host}/',
          queryParameters: queryParams,
          options: Options(headers: headers),
        );
        if (response.statusCode == 200 && response.data != null) {
          final alarms =
              response.data['DescribeAlarmsResponse']['DescribeAlarmsResult']['MetricAlarms']
                  as List<dynamic>? ??
              [];
          for (var alarm in alarms) {
            final stateValue = alarm['StateValue'] as String?;
            if (stateValue == 'ALARM') {
              final alarmName =
                  alarm['AlarmName'] as String? ?? 'CloudWatch Alarm';
              final reason =
                  alarm['StateReason'] as String? ?? 'AWS Alert Triggered';
              final namespace =
                  alarm['Namespace'] as String? ?? 'AWS/Resources';
              final timestampStr = alarm['StateUpdatedTimestamp'] as String?;
              final createdAt = timestampStr != null
                  ? DateTime.parse(timestampStr!)
                  : DateTime.now();
              list.add(
                DevOpsIncident(
                  id: 'aws-${alarmName.hashCode}',
                  title: alarmName,
                  description: reason,
                  status: IncidentStatus.triggered,
                  urgency: 'critical',
                  serviceData: 'AWS: ${namespace}',
                  createdAt: createdAt,
                  provider: IncidentProvider.aws,
                  rawProviderPayload: alarm as Map<String, dynamic>,
                ),
              );
            }
          }
        }
      } catch (e) {
        debugPrint('Error fetching AWS Alarms: ${e}');
      }
    }
    if (azureTenantId.isNotEmpty &&
        azureClientId.isNotEmpty &&
        azureClientSecret.isNotEmpty &&
        azureSubscriptionId.isNotEmpty) {
      try {
        final authResponse = await _dio.post(
          'https://login.microsoftonline.com/${azureTenantId}/oauth2/v2.0/token',
          data: {
            'grant_type': 'client_credentials',
            'client_id': azureClientId,
            'client_secret': azureClientSecret,
            'scope': 'https://management.azure.com/.default',
          },
          options: Options(contentType: Headers.formUrlEncodedContentType),
        );
        final token = authResponse.data['access_token'] as String?;
        if (token != null) {
          final alertsResponse = await _dio.get(
            'https://management.azure.com/subscriptions/${azureSubscriptionId}/providers/Microsoft.AlertsManagement/alerts?api-version=2019-03-01',
            options: Options(headers: {'Authorization': 'Bearer ${token}'}),
          );
          if (alertsResponse.statusCode == 200 && alertsResponse.data != null) {
            final alerts = alertsResponse.data['value'] as List<dynamic>? ?? [];
            for (var alert in alerts) {
              final props = alert['properties'] ?? {};
              final essentials = props['essentials'] ?? {};
              final monitorCondition =
                  essentials['monitorCondition'] as String?;
              if (monitorCondition == 'Fired') {
                final id = alert['id'] as String? ?? 'azure-${alert['name']}';
                final alertName =
                    essentials['alertRule'] as String? ?? 'Azure Alert';
                final targetResource =
                    essentials['targetResource'] as String? ??
                    'Azure/Resources';
                final severity = essentials['severity'] as String? ?? 'Sev1';
                final modifiedStr =
                    essentials['lastModifiedDateTime'] as String?;
                final createdAt = modifiedStr != null
                    ? DateTime.parse(modifiedStr!)
                    : DateTime.now();
                list.add(
                  DevOpsIncident(
                    id: id,
                    title: alertName,
                    description:
                        'Azure Monitor alert target: ${targetResource.split('/').last}. Severity: ${severity}',
                    status: IncidentStatus.triggered,
                    urgency: severity == 'Sev0' || severity == 'Sev1'
                        ? 'critical'
                        : 'high',
                    serviceData: 'Azure: ${targetResource.split('/').last}',
                    createdAt: createdAt,
                    provider: IncidentProvider.azure,
                    rawProviderPayload: alert as Map<String, dynamic>,
                  ),
                );
              }
            }
          }
        }
      } catch (e) {
        debugPrint('Error fetching Azure Alerts: ${e}');
      }
    }
    if (gcpProjectId.isNotEmpty && gcpTokenOrKey.isNotEmpty) {
      try {
        String url;
        Map<String, String> headers = {};
        if (gcpIsApiKey) {
          url =
              'https://monitoring.googleapis.com/v3/projects/${gcpProjectId}/alertPolicies?key=${gcpTokenOrKey}';
        } else {
          url =
              'https://monitoring.googleapis.com/v3/projects/${gcpProjectId}/alertPolicies';
          headers['Authorization'] = 'Bearer ${gcpTokenOrKey}';
        }
        final response = await _dio.get(
          url,
          options: Options(headers: headers),
        );
        if (response.statusCode == 200 && response.data != null) {
          final policies =
              response.data['alertPolicies'] as List<dynamic>? ?? [];
          for (var policy in policies) {
            final enabled = policy['enabled'] as bool? ?? false;
            final userLabels =
                policy['userLabels'] as Map<dynamic, dynamic>? ?? {};
            if (enabled &&
                userLabels.containsKey('triggered') &&
                userLabels['triggered'] == 'true') {
              final id = 'gcp-${policy['name'].toString().split('/').last}';
              final displayName =
                  policy['displayName'] as String? ?? 'GCP Policy Triggered';
              final resourceName =
                  policy['conditions'][0]['displayName'] as String? ??
                  'GCP/Resources';
              list.add(
                DevOpsIncident(
                  id: id,
                  title: displayName,
                  description:
                      'GCP Monitoring alert triggered. Condition: ${resourceName}',
                  status: IncidentStatus.triggered,
                  urgency: 'high',
                  serviceData: 'GCP: ${resourceName}',
                  createdAt: DateTime.now().subtract(
                    const Duration(minutes: 10),
                  ),
                  provider: IncidentProvider.gcp,
                  rawProviderPayload: policy as Map<String, dynamic>,
                ),
              );
            }
          }
        }
      } catch (e) {
        debugPrint('Error fetching GCP: ${e}');
      }
    }
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }
}

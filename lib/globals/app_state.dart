import 'package:flutter/material.dart';
import 'package:devops_incident_commander_dashboard/globals/themes.dart';
import 'package:devops_incident_commander_dashboard/models/dev_ops_incident.dart';
import 'dart:async';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:devops_incident_commander_dashboard/incident_status.dart';
import 'package:devops_incident_commander_dashboard/main.dart';
import 'package:devops_incident_commander_dashboard/incident_repository.dart';
import 'package:provider/provider.dart';

@NowaGenerated()
class AppState extends ChangeNotifier {
  AppState() {
    _theme = darkTheme;
    initSettings();
    startCleanupTimer();
    loadIncidents();
  }

  factory AppState.of(BuildContext context, {bool listen = true}) {
    return Provider.of<AppState>(context, listen: listen);
  }

  ThemeData _theme = darkTheme;

  List<DevOpsIncident> _incidents = [];

  bool _isLoading = false;

  Timer? _cleanupTimer;

  String _githubOwner = '';

  String _githubRepo = '';

  String _githubToken = '';

  String _pagerDutyToken = '';

  String _awsAccessKey = '';

  String _awsSecretKey = '';

  String _awsRegion = 'us-east-1';

  bool _awsSimulated = true;

  String _azureTenantId = '';

  String _azureClientId = '';

  String _azureClientSecret = '';

  String _azureSubscriptionId = '';

  bool _azureSimulated = true;

  String _gcpProjectId = '';

  String _gcpTokenOrKey = '';

  bool _gcpIsApiKey = true;

  bool _gcpSimulated = true;

  bool _isTestingGitHub = false;

  String? _githubTestMessage;

  bool? _githubTestSuccess;

  bool _isTestingPagerDuty = false;

  String? _pagerDutyTestMessage;

  bool? _pagerDutyTestSuccess;

  bool _isTestingAws = false;

  String? _awsTestMessage;

  bool? _awsTestSuccess;

  bool _isTestingAzure = false;

  String? _azureTestMessage;

  bool? _azureTestSuccess;

  bool _isTestingGcp = false;

  String? _gcpTestMessage;

  bool? _gcpTestSuccess;

  ThemeData get theme {
    return _theme;
  }

  List<DevOpsIncident> get incidents {
    return _incidents;
  }

  bool get isLoading {
    return _isLoading;
  }

  String get githubOwner {
    return _githubOwner;
  }

  String get githubRepo {
    return _githubRepo;
  }

  String get githubToken {
    return _githubToken;
  }

  String get pagerDutyToken {
    return _pagerDutyToken;
  }

  String get awsAccessKey {
    return _awsAccessKey;
  }

  String get awsSecretKey {
    return _awsSecretKey;
  }

  String get awsRegion {
    return _awsRegion;
  }

  bool get awsSimulated {
    return _awsSimulated;
  }

  String get azureTenantId {
    return _azureTenantId;
  }

  String get azureClientId {
    return _azureClientId;
  }

  String get azureClientSecret {
    return _azureClientSecret;
  }

  String get azureSubscriptionId {
    return _azureSubscriptionId;
  }

  bool get azureSimulated {
    return _azureSimulated;
  }

  String get gcpProjectId {
    return _gcpProjectId;
  }

  String get gcpTokenOrKey {
    return _gcpTokenOrKey;
  }

  bool get gcpIsApiKey {
    return _gcpIsApiKey;
  }

  bool get gcpSimulated {
    return _gcpSimulated;
  }

  bool get isTestingGitHub {
    return _isTestingGitHub;
  }

  String? get githubTestMessage {
    return _githubTestMessage;
  }

  bool? get githubTestSuccess {
    return _githubTestSuccess;
  }

  bool get isTestingPagerDuty {
    return _isTestingPagerDuty;
  }

  String? get pagerDutyTestMessage {
    return _pagerDutyTestMessage;
  }

  bool? get pagerDutyTestSuccess {
    return _pagerDutyTestSuccess;
  }

  bool get isTestingAws {
    return _isTestingAws;
  }

  String? get awsTestMessage {
    return _awsTestMessage;
  }

  bool? get awsTestSuccess {
    return _awsTestSuccess;
  }

  bool get isTestingAzure {
    return _isTestingAzure;
  }

  String? get azureTestMessage {
    return _azureTestMessage;
  }

  bool? get azureTestSuccess {
    return _azureTestSuccess;
  }

  bool get isTestingGcp {
    return _isTestingGcp;
  }

  String? get gcpTestMessage {
    return _gcpTestMessage;
  }

  bool? get gcpTestSuccess {
    return _gcpTestSuccess;
  }

  int get activeIncidentsCount {
    return _incidents.where((i) => i.status != IncidentStatus.resolved).length;
  }

  int get triggeredAlertsCount {
    return _incidents
        .where(
          (i) =>
              i.status == IncidentStatus.triggered ||
              i.status == IncidentStatus.escalated,
        )
        .length;
  }

  String get systemUptime {
    final activeCount = activeIncidentsCount;
    if (activeCount == 0) {
      return '99.99%';
    }
    final calculated = 99.99 - (activeCount * 0.04);
    return '${calculated.toStringAsFixed(2)}%';
  }

  void changeTheme(ThemeData theme) {
    _theme = theme;
    notifyListeners();
  }

  void startCleanupTimer() {
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _cleanupOldResolvedIncidents();
    });
  }

  @override
  void dispose() {
    _cleanupTimer?.cancel();
    super.dispose();
  }

  void _cleanupOldResolvedIncidents() {
    bool changed = false;
    final now = DateTime.now();
    _incidents = _incidents.where((incident) {
      if (incident.status == IncidentStatus.resolved &&
          incident.resolvedAt != null) {
        final difference = now.difference(incident.resolvedAt!);
        if (difference.inMinutes >= 5) {
          changed = true;
          return false;
        }
      }
      return true;
    }).toList();
    if (changed) {
      notifyListeners();
    }
  }

  void initSettings() {
    try {
      _githubOwner = sharedPrefs.getString('github_owner') ?? '';
      _githubRepo = sharedPrefs.getString('github_repo') ?? '';
      _githubToken = sharedPrefs.getString('github_token') ?? '';
      _pagerDutyToken = sharedPrefs.getString('pager_duty_token') ?? '';
      _awsAccessKey = sharedPrefs.getString('aws_access_key') ?? '';
      _awsSecretKey = sharedPrefs.getString('aws_secret_key') ?? '';
      _awsRegion = sharedPrefs.getString('aws_region') ?? 'us-east-1';
      _awsSimulated = sharedPrefs.getBool('aws_simulated') ?? true;
      _azureTenantId = sharedPrefs.getString('azure_tenant_id') ?? '';
      _azureClientId = sharedPrefs.getString('azure_client_id') ?? '';
      _azureClientSecret = sharedPrefs.getString('azure_client_secret') ?? '';
      _azureSubscriptionId =
          sharedPrefs.getString('azure_subscription_id') ?? '';
      _azureSimulated = sharedPrefs.getBool('azure_simulated') ?? true;
      _gcpProjectId = sharedPrefs.getString('gcp_project_id') ?? '';
      _gcpTokenOrKey = sharedPrefs.getString('gcp_token_or_key') ?? '';
      _gcpIsApiKey = sharedPrefs.getBool('gcp_is_api_key') ?? true;
      _gcpSimulated = sharedPrefs.getBool('gcp_simulated') ?? true;
    } catch (e) {
      debugPrint('Error reading settings from sharedPrefs: ${e}');
    }
  }

  Future<void> saveSettings({
    required String githubOwner,
    required String githubRepo,
    required String githubToken,
    required String pagerDutyToken,
    required String awsAccessKey,
    required String awsSecretKey,
    required String awsRegion,
    required bool awsSimulated,
    required String azureTenantId,
    required String azureClientId,
    required String azureClientSecret,
    required String azureSubscriptionId,
    required bool azureSimulated,
    required String gcpProjectId,
    required String gcpTokenOrKey,
    required bool gcpIsApiKey,
    required bool gcpSimulated,
  }) async {
    try {
      _githubOwner = githubOwner;
      _githubRepo = githubRepo;
      _githubToken = githubToken;
      _pagerDutyToken = pagerDutyToken;
      _awsAccessKey = awsAccessKey;
      _awsSecretKey = awsSecretKey;
      _awsRegion = awsRegion;
      _awsSimulated = awsSimulated;
      _azureTenantId = azureTenantId;
      _azureClientId = azureClientId;
      _azureClientSecret = azureClientSecret;
      _azureSubscriptionId = azureSubscriptionId;
      _azureSimulated = azureSimulated;
      _gcpProjectId = gcpProjectId;
      _gcpTokenOrKey = gcpTokenOrKey;
      _gcpIsApiKey = gcpIsApiKey;
      _gcpSimulated = gcpSimulated;
      await sharedPrefs.setString('github_owner', githubOwner);
      await sharedPrefs.setString('github_repo', githubRepo);
      await sharedPrefs.setString('github_token', githubToken);
      await sharedPrefs.setString('pager_duty_token', pagerDutyToken);
      await sharedPrefs.setString('aws_access_key', awsAccessKey);
      await sharedPrefs.setString('aws_secret_key', awsSecretKey);
      await sharedPrefs.setString('aws_region', awsRegion);
      await sharedPrefs.setBool('aws_simulated', awsSimulated);
      await sharedPrefs.setString('azure_tenant_id', azureTenantId);
      await sharedPrefs.setString('azure_client_id', azureClientId);
      await sharedPrefs.setString('azure_client_secret', azureClientSecret);
      await sharedPrefs.setString('azure_subscription_id', azureSubscriptionId);
      await sharedPrefs.setBool('azure_simulated', azureSimulated);
      await sharedPrefs.setString('gcp_project_id', gcpProjectId);
      await sharedPrefs.setString('gcp_token_or_key', gcpTokenOrKey);
      await sharedPrefs.setBool('gcp_is_api_key', gcpIsApiKey);
      await sharedPrefs.setBool('gcp_simulated', gcpSimulated);
      notifyListeners();
      await loadIncidents();
    } catch (e) {
      debugPrint('Error saving settings: ${e}');
    }
  }

  void resetTestResults() {
    _githubTestMessage = null;
    _githubTestSuccess = null;
    _isTestingGitHub = false;
    _pagerDutyTestMessage = null;
    _pagerDutyTestSuccess = null;
    _isTestingPagerDuty = false;
    _awsTestMessage = null;
    _awsTestSuccess = null;
    _isTestingAws = false;
    _azureTestMessage = null;
    _azureTestSuccess = null;
    _isTestingAzure = false;
    _gcpTestMessage = null;
    _gcpTestSuccess = null;
    _isTestingGcp = false;
    notifyListeners();
  }

  Future<void> testGitHub(String owner, String repo, String token) async {
    _isTestingGitHub = true;
    _githubTestMessage = 'Testing connection...';
    _githubTestSuccess = null;
    notifyListeners();
    try {
      final repoService = IncidentRepository();
      final result = await repoService.testGitHubConnection(owner, repo, token);
      _githubTestSuccess = result['success'] as bool;
      _githubTestMessage = result['message'] as String;
    } catch (e) {
      _githubTestSuccess = false;
      _githubTestMessage = e.toString();
    } finally {
      _isTestingGitHub = false;
      notifyListeners();
    }
  }

  Future<void> testPagerDuty(String token) async {
    _isTestingPagerDuty = true;
    _pagerDutyTestMessage = 'Testing connection...';
    _pagerDutyTestSuccess = null;
    notifyListeners();
    try {
      final repoService = IncidentRepository();
      final result = await repoService.testPagerDutyConnection(token);
      _pagerDutyTestSuccess = result['success'] as bool;
      _pagerDutyTestMessage = result['message'] as String;
    } catch (e) {
      _pagerDutyTestSuccess = false;
      _pagerDutyTestMessage = e.toString();
    } finally {
      _isTestingPagerDuty = false;
      notifyListeners();
    }
  }

  Future<void> testAws(
    String accessKey,
    String secretKey,
    String region,
  ) async {
    _isTestingAws = true;
    _awsTestMessage = 'Testing connection...';
    _awsTestSuccess = null;
    notifyListeners();
    try {
      final repoService = IncidentRepository();
      final result = await repoService.testAwsConnection(
        accessKey: accessKey,
        secretKey: secretKey,
        region: region,
      );
      _awsTestSuccess = result['success'] as bool;
      _awsTestMessage = result['message'] as String;
    } catch (e) {
      _awsTestSuccess = false;
      _awsTestMessage = e.toString();
    } finally {
      _isTestingAws = false;
      notifyListeners();
    }
  }

  Future<void> testAzure(
    String tenantId,
    String clientId,
    String secret,
    String subscriptionId,
  ) async {
    _isTestingAzure = true;
    _azureTestMessage = 'Testing connection...';
    _azureTestSuccess = null;
    notifyListeners();
    try {
      final repoService = IncidentRepository();
      final result = await repoService.testAzureConnection(
        tenantId: tenantId,
        clientId: clientId,
        clientSecret: secret,
        subscriptionId: subscriptionId,
      );
      _azureTestSuccess = result['success'] as bool;
      _azureTestMessage = result['message'] as String;
    } catch (e) {
      _azureTestSuccess = false;
      _azureTestMessage = e.toString();
    } finally {
      _isTestingAzure = false;
      notifyListeners();
    }
  }

  Future<void> testGcp(
    String projectId,
    String tokenOrKey,
    bool isApiKey,
  ) async {
    _isTestingGcp = true;
    _gcpTestMessage = 'Testing connection...';
    _gcpTestSuccess = null;
    notifyListeners();
    try {
      final repoService = IncidentRepository();
      final result = await repoService.testGcpConnection(
        projectId: projectId,
        tokenOrKey: tokenOrKey,
        isApiKey: isApiKey,
      );
      _gcpTestSuccess = result['success'] as bool;
      _gcpTestMessage = result['message'] as String;
    } catch (e) {
      _gcpTestSuccess = false;
      _gcpTestMessage = e.toString();
    } finally {
      _isTestingGcp = false;
      notifyListeners();
    }
  }

  Future<void> loadIncidents() async {
    _isLoading = true;
    notifyListeners();
    try {
      final repo = IncidentRepository();
      final loadedList = await repo.fetchRealAndSimulatedIncidents(
        githubOwner: _githubOwner,
        githubRepo: _githubRepo,
        githubToken: _githubToken,
        pagerDutyToken: _pagerDutyToken,
        awsAccessKey: _awsAccessKey,
        awsSecretKey: _awsSecretKey,
        awsRegion: _awsRegion,
        awsSimulated: _awsSimulated,
        gcpProjectId: _gcpProjectId,
        gcpTokenOrKey: _gcpTokenOrKey,
        gcpIsApiKey: _gcpIsApiKey,
        gcpSimulated: _gcpSimulated,
        azureTenantId: _azureTenantId,
        azureClientId: _azureClientId,
        azureClientSecret: _azureClientSecret,
        azureSubscriptionId: _azureSubscriptionId,
        azureSimulated: _azureSimulated,
      );
      final updatedList = <DevOpsIncident>[];
      final now = DateTime.now();
      for (var incident in loadedList) {
        final savedStatusStr = sharedPrefs.getString(
          'incident_status_${incident.id}',
        );
        final savedResolvedAtStr = sharedPrefs.getString(
          'incident_resolved_at_${incident.id}',
        );
        if (savedStatusStr != null) {
          final savedStatus = IncidentStatus.values.firstWhere(
            (e) => e.name == savedStatusStr,
            orElse: () => incident.status,
          );
          DateTime? resolvedAt;
          if (savedResolvedAtStr != null) {
            resolvedAt = DateTime.parse(savedResolvedAtStr);
          }
          final updatedIncident = incident.copyWith(
            status: savedStatus,
            resolvedAt: resolvedAt,
          );
          if (savedStatus == IncidentStatus.resolved && resolvedAt != null) {
            final diff = now.difference(resolvedAt!);
            if (diff.inMinutes >= 5) {
              continue;
            }
          }
          updatedList.add(updatedIncident);
        } else {
          updatedList.add(incident);
        }
      }
      _incidents = updatedList;
    } catch (e) {
      debugPrint('Error loading incidents: ${e}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> acknowledgeIncident(String id) async {
    try {
      final index = _incidents.indexWhere((i) => i.id == id);
      if (index != -1) {
        final updated = _incidents[index].copyWith(
          status: IncidentStatus.acknowledged,
        );
        _incidents[index] = updated;
        await sharedPrefs.setString(
          'incident_status_${id}',
          IncidentStatus.acknowledged.name,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error acknowledging incident: ${e}');
    }
  }

  Future<void> escalateIncident(String id) async {
    try {
      final index = _incidents.indexWhere((i) => i.id == id);
      if (index != -1) {
        final updated = _incidents[index].copyWith(
          status: IncidentStatus.escalated,
        );
        _incidents[index] = updated;
        await sharedPrefs.setString(
          'incident_status_${id}',
          IncidentStatus.escalated.name,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error escalating incident: ${e}');
    }
  }

  Future<void> resolveIncident(String id) async {
    try {
      final index = _incidents.indexWhere((i) => i.id == id);
      if (index != -1) {
        final resolvedTime = DateTime.now();
        final updated = _incidents[index].copyWith(
          status: IncidentStatus.resolved,
          resolvedAt: resolvedTime,
        );
        _incidents[index] = updated;
        await sharedPrefs.setString(
          'incident_status_${id}',
          IncidentStatus.resolved.name,
        );
        await sharedPrefs.setString(
          'incident_resolved_at_${id}',
          resolvedTime.toIso8601String(),
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error resolving incident: ${e}');
    }
  }
}

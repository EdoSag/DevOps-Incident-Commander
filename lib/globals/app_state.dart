import 'package:flutter/material.dart';
import 'package:devops_incident_commander_dashboard/globals/themes.dart';
import 'package:devops_incident_commander_dashboard/models/dev_ops_incident.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:devops_incident_commander_dashboard/user_role.dart';
import 'package:devops_incident_commander_dashboard/models/team_member.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:devops_incident_commander_dashboard/incident_status.dart';
import 'package:devops_incident_commander_dashboard/security_service.dart';
import 'package:devops_incident_commander_dashboard/main.dart';
import 'package:devops_incident_commander_dashboard/incident_repository.dart';
import 'package:devops_incident_commander_dashboard/models/incident_comment.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

@NowaGenerated()
class AppState extends ChangeNotifier {
  AppState() {
    _theme = darkTheme;
    initLocalSettings();
    startCleanupTimer();
    _setupSupabaseListener();
    loadIncidents();
  }

  factory AppState.of(BuildContext context, {bool listen = true}) {
    return Provider.of<AppState>(context, listen: listen);
  }

  ThemeData _theme = darkTheme;

  List<DevOpsIncident> _incidents = [];

  bool _isLoading = false;

  Timer? _cleanupTimer;

  User? _currentUser;

  UserRole _currentUserRole = UserRole.responder;

  int _currentTabIndex = 0;

  final List<TeamMember> _teamRoster = const [
    TeamMember(
      id: 'tm-01',
      name: 'Sarah Jenkins',
      title: 'Primary On-Call',
      avatarColor: 0xFFEF5350,
      isOnCall: true,
    ),
    TeamMember(
      id: 'tm-02',
      name: 'Alex Rivera',
      title: 'Secondary On-Call',
      avatarColor: 0xFFFFB74D,
      isOnCall: true,
    ),
    TeamMember(
      id: 'tm-03',
      name: 'Nikhil Sharma',
      title: 'Lead DevOps Architect',
      avatarColor: 0xFF42A5F5,
      isOnCall: false,
    ),
    TeamMember(
      id: 'tm-04',
      name: 'Elena Rostova',
      title: 'SecOps Commander',
      avatarColor: 0xFFAB47BC,
      isOnCall: false,
    ),
  ];

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

  int get currentTabIndex {
    return _currentTabIndex;
  }

  User? get currentUser {
    return _currentUser;
  }

  UserRole get currentUserRole {
    return _currentUserRole;
  }

  List<TeamMember> get teamRoster {
    return _teamRoster;
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

  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  void startCleanupTimer() {
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _cleanupOldResolvedIncidents();
    });
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

  void _setupSupabaseListener() {
    try {
      _currentUser = Supabase.instance.client.auth.currentUser;
      Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
        _currentUser = data.session?.user;
        if (_currentUser != null) {
          await _syncProfileAndSettings();
        } else {
          _currentUserRole = UserRole.responder;
          initLocalSettings();
        }
        await loadIncidents();
        notifyListeners();
      });
    } catch (e) {
      debugPrint('Supabase not fully connected yet: ${e}');
    }
  }

  Future<void> _syncProfileAndSettings() async {
    final uid = _currentUser?.id;
    if (uid == null) {
      return;
    }
    try {
      final profileRes = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', uid)
          .maybeSingle();
      if (profileRes != null) {
        final roleStr = profileRes['role'] as String? ?? 'responder';
        _currentUserRole = UserRole.values.firstWhere(
          (e) => e.name == roleStr,
          orElse: () => UserRole.responder,
        );
      } else {
        await Supabase.instance.client.from('profiles').insert({
          'id': uid,
          'role': UserRole.responder.name,
        });
        _currentUserRole = UserRole.responder;
      }
      final settingsRes = await Supabase.instance.client
          .from('integration_settings')
          .select()
          .eq('user_id', uid)
          .maybeSingle();
      if (settingsRes != null) {
        _githubOwner = settingsRes['github_owner'] as String? ?? '';
        _githubRepo = settingsRes['github_repo'] as String? ?? '';
        _awsAccessKey = settingsRes['aws_access_key'] as String? ?? '';
        _awsRegion = settingsRes['aws_region'] as String? ?? 'us-east-1';
        _azureTenantId = settingsRes['azure_tenant_id'] as String? ?? '';
        _azureClientId = settingsRes['azure_client_id'] as String? ?? '';
        _azureSubscriptionId =
            settingsRes['azure_subscription_id'] as String? ?? '';
        _gcpProjectId = settingsRes['gcp_project_id'] as String? ?? '';
        _gcpIsApiKey = settingsRes['gcp_is_api_key'] as bool? ?? true;
        _awsSimulated = settingsRes['aws_simulated'] as bool? ?? true;
        _gcpSimulated = settingsRes['gcp_simulated'] as bool? ?? true;
        _azureSimulated = settingsRes['azure_simulated'] as bool? ?? true;
        _githubToken = SecurityService.decrypt(
          settingsRes['encrypted_github_token'] as String? ?? '',
        );
        _pagerDutyToken = SecurityService.decrypt(
          settingsRes['encrypted_pager_duty_token'] as String? ?? '',
        );
        _awsSecretKey = SecurityService.decrypt(
          settingsRes['encrypted_aws_secret'] as String? ?? '',
        );
        _azureClientSecret = SecurityService.decrypt(
          settingsRes['encrypted_azure_secret'] as String? ?? '',
        );
        _gcpTokenOrKey = SecurityService.decrypt(
          settingsRes['encrypted_gcp_token'] as String? ?? '',
        );
      } else {
        await Supabase.instance.client.from('integration_settings').insert({
          'user_id': uid,
          'github_owner': '',
          'github_repo': '',
          'encrypted_github_token': '',
          'encrypted_pager_duty_token': '',
          'aws_access_key': '',
          'encrypted_aws_secret': '',
          'aws_region': 'us-east-1',
          'azure_tenant_id': '',
          'azure_client_id': '',
          'encrypted_azure_secret': '',
          'azure_subscription_id': '',
          'gcp_project_id': '',
          'encrypted_gcp_token': '',
          'gcp_is_api_key': true,
          'aws_simulated': true,
          'gcp_simulated': true,
          'azure_simulated': true,
        });
      }
    } catch (e) {
      debugPrint('Error syncing profile/settings: ${e}');
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String email, String password, UserRole role) async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );
      final uid = res.user?.id;
      if (uid != null) {
        await Supabase.instance.client.from('profiles').insert({
          'id': uid,
          'role': role.name,
        });
        _currentUserRole = role;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
    _currentUser = null;
    _currentUserRole = UserRole.responder;
    initLocalSettings();
    await loadIncidents();
    notifyListeners();
  }

  Future<void>? updateUserRole(UserRole role) async {
    _currentUserRole = role;
    notifyListeners();
    final uid = _currentUser?.id;
    if (uid != null) {
      try {
        await Supabase.instance.client
            .from('profiles')
            .update({'role': role.name})
            .eq('id', uid);
      } catch (e) {
        debugPrint('Error writing role to database: ${e}');
      }
    }
  }

  void initLocalSettings() {
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
      debugPrint('Error reading settings locally: ${e}');
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
    notifyListeners();
    try {
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
    } catch (e) {
      debugPrint('Error saving locally: ${e}');
    }
    final uid = _currentUser?.id;
    if (uid != null) {
      try {
        final encGitHub = SecurityService.encrypt(githubToken);
        final encPagerDuty = SecurityService.encrypt(pagerDutyToken);
        final encAWS = SecurityService.encrypt(awsSecretKey);
        final encAzure = SecurityService.encrypt(azureClientSecret);
        final encGCP = SecurityService.encrypt(gcpTokenOrKey);
        await Supabase.instance.client.from('integration_settings').upsert({
          'user_id': uid,
          'github_owner': githubOwner,
          'github_repo': githubRepo,
          'encrypted_github_token': encGitHub,
          'encrypted_pager_duty_token': encPagerDuty,
          'aws_access_key': awsAccessKey,
          'encrypted_aws_secret': encAWS,
          'aws_region': awsRegion,
          'azure_tenant_id': azureTenantId,
          'azure_client_id': azureClientId,
          'encrypted_azure_secret': encAzure,
          'azure_subscription_id': azureSubscriptionId,
          'gcp_project_id': gcpProjectId,
          'encrypted_gcp_token': encGCP,
          'gcp_is_api_key': gcpIsApiKey,
          'aws_simulated': awsSimulated,
          'gcp_simulated': gcpSimulated,
          'azure_simulated': azureSimulated,
        });
      } catch (e) {
        debugPrint('Error syncing to cloud: ${e}');
      }
    }
    await loadIncidents();
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
        final savedAssigneeId = sharedPrefs.getString(
          'incident_assignee_${incident.id}',
        );
        final savedCommentsJson = sharedPrefs.getString(
          'incident_comments_${incident.id}',
        );
        var currentStatus = incident.status;
        DateTime? resolvedAt;
        if (savedResolvedAtStr != null) {
          resolvedAt = DateTime.parse(savedResolvedAtStr);
        }
        if (savedStatusStr != null) {
          currentStatus = IncidentStatus.values.firstWhere(
            (e) => e.name == savedStatusStr,
            orElse: () => incident.status,
          );
        }
        TeamMember? assigned;
        if (savedAssigneeId != null) {
          assigned = _teamRoster.firstWhere(
            (m) => m.id == savedAssigneeId,
            orElse: () => _teamRoster.first,
          );
        }
        List<IncidentComment> comments = [];
        if (savedCommentsJson != null) {
          try {
            final List<dynamic> parsed =
                jsonDecode(savedCommentsJson) as List<dynamic>;
            comments = parsed
                .map((e) => IncidentComment.fromJson(e as Map<String, dynamic>))
                .toList();
          } catch (e) {
            debugPrint('Error parsing cached comments: ${e}');
          }
        }
        final updatedIncident = incident.copyWith(
          status: currentStatus,
          resolvedAt: resolvedAt,
          assignedTo: assigned,
          comments: comments,
        );
        if (currentStatus == IncidentStatus.resolved && resolvedAt != null) {
          final diff = now.difference(resolvedAt!);
          if (diff.inMinutes >= 5) {
            continue;
          }
        }
        updatedList.add(updatedIncident);
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

  Future<void> assignIncident(String incidentId, String teamMemberId) async {
    try {
      final index = _incidents.indexWhere((i) => i.id == incidentId);
      if (index != -1) {
        final member = _teamRoster.firstWhere((m) => m.id == teamMemberId);
        _incidents[index] = _incidents[index].copyWith(assignedTo: member);
        await sharedPrefs.setString(
          'incident_assignee_${incidentId}',
          teamMemberId,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error assigning incident: ${e}');
    }
  }

  Future<void> addIncidentComment(String incidentId, String text) async {
    if (text.trim().isEmpty) {
      return;
    }
    try {
      final index = _incidents.indexWhere((i) => i.id == incidentId);
      if (index != -1) {
        final username =
            _currentUser?.email?.split('@').first ?? 'On-Call Operator';
        final newComment = IncidentComment(
          id: 'cmt-${DateTime.now().millisecondsSinceEpoch}',
          userName: username,
          text: text.trim(),
          createdAt: DateTime.now(),
        );
        final updatedComments = List<IncidentComment>.from(
          _incidents[index].comments,
        )..add(newComment);
        _incidents[index] = _incidents[index].copyWith(
          comments: updatedComments,
        );
        final listJson = jsonEncode(
          updatedComments.map((e) => e.toJson()).toList(),
        );
        await sharedPrefs.setString(
          'incident_comments_${incidentId}',
          listJson,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error adding comment: ${e}');
    }
  }
}

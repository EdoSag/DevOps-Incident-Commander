import 'package:flutter/material.dart';
import 'package:devops_incident_commander_dashboard/globals/themes.dart';
import 'package:devops_incident_commander_dashboard/models/dev_ops_incident.dart';
import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:devops_incident_commander_dashboard/user_role.dart';
import 'package:devops_incident_commander_dashboard/models/organization.dart';
import 'package:devops_incident_commander_dashboard/models/organization_member.dart';
import 'package:devops_incident_commander_dashboard/models/org_invite.dart';
import 'package:devops_incident_commander_dashboard/models/join_request.dart';
import 'package:devops_incident_commander_dashboard/models/incident_analytics.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:devops_incident_commander_dashboard/incident_status.dart';
import 'package:devops_incident_commander_dashboard/incident_provider.dart';
import 'package:devops_incident_commander_dashboard/security_service.dart';
import 'package:devops_incident_commander_dashboard/main.dart';
import 'package:devops_incident_commander_dashboard/incident_repository.dart';
import 'package:devops_incident_commander_dashboard/models/incident_comment.dart';
import 'package:provider/provider.dart';

@NowaGenerated()
class AppState extends ChangeNotifier {
  AppState() {
    _theme = darkTheme;
    initLocalSettings();
    startCleanupTimer();
    _setupSupabaseListener();
  }

  factory AppState.of(BuildContext context, {bool listen = true}) {
    return Provider.of<AppState>(context, listen: listen);
  }

  ThemeData _theme = darkTheme;

  List<DevOpsIncident> _incidents = [];

  bool _isLoading = false;

  Timer? _cleanupTimer;

  User? _currentUser;

  int _currentTabIndex = 0;

  Organization? _currentOrganization;

  OrganizationMember? _currentMembership;

  List<OrganizationMember> _organizationMembers = [];

  List<OrgInvite> _invites = [];

  bool _isLoadingOrg = false;

  String? _pendingJoinRequestId;

  String? _pendingJoinRequestToken;

  JoinRequestStatus? _pendingJoinRequestStatus;

  JoinRequest? _scannedJoinRequest;

  IncidentAnalytics _analytics = const IncidentAnalytics.empty();

  String _githubOwner = '';

  String _githubRepo = '';

  String _githubToken = '';

  String _pagerDutyToken = '';

  String _awsAccessKey = '';

  String _awsSecretKey = '';

  String _awsRegion = 'us-east-1';

  String _azureTenantId = '';

  String _azureClientId = '';

  String _azureClientSecret = '';

  String _azureSubscriptionId = '';

  String _gcpProjectId = '';

  String _gcpTokenOrKey = '';

  bool _gcpIsApiKey = true;

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

  Organization? get currentOrganization {
    return _currentOrganization;
  }

  OrganizationMember? get currentMembership {
    return _currentMembership;
  }

  bool get hasOrganization {
    return _currentOrganization != null;
  }

  bool get isLoadingOrg {
    return _isLoadingOrg;
  }

  List<OrganizationMember> get organizationMembers {
    return _organizationMembers;
  }

  List<OrgInvite> get invites {
    return _invites;
  }

  String? get pendingJoinRequestToken {
    return _pendingJoinRequestToken;
  }

  JoinRequestStatus? get pendingJoinRequestStatus {
    return _pendingJoinRequestStatus;
  }

  JoinRequest? get scannedJoinRequest {
    return _scannedJoinRequest;
  }

  IncidentAnalytics get analytics {
    return _analytics;
  }

  UserRole get currentUserRole {
    return _currentMembership?.role ?? UserRole.viewer;
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

  String get gcpProjectId {
    return _gcpProjectId;
  }

  String get gcpTokenOrKey {
    return _gcpTokenOrKey;
  }

  bool get gcpIsApiKey {
    return _gcpIsApiKey;
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
      if (_currentUser != null) {
        _syncProfileAndOrganization();
      }
      Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
        _currentUser = data.session?.user;
        if (_currentUser != null) {
          await _syncProfileAndOrganization();
        } else {
          _clearOrganizationState();
          initLocalSettings();
          notifyListeners();
        }
      });
    } catch (e) {
      debugPrint('Supabase not fully connected yet: ${e}');
    }
  }

  void _clearOrganizationState() {
    _currentOrganization = null;
    _currentMembership = null;
    _organizationMembers = [];
    _invites = [];
    _incidents = [];
    _analytics = const IncidentAnalytics.empty();
  }

  Future<void> _syncProfileAndOrganization() async {
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
      if (profileRes == null) {
        final defaultName = _currentUser?.email?.split('@').first ?? 'New User';
        await Supabase.instance.client.from('profiles').insert({
          'id': uid,
          'display_name': defaultName,
        });
      }
    } catch (e) {
      debugPrint('Error syncing profile: ${e}');
    }
    await loadOrganization();
  }

  Future<void> loadOrganization() async {
    final uid = _currentUser?.id;
    if (uid == null) {
      return;
    }
    _isLoadingOrg = true;
    notifyListeners();
    try {
      final res = await Supabase.instance.client
          .from('organization_members')
          .select('*, organizations(*)')
          .eq('user_id', uid)
          .limit(1)
          .maybeSingle();
      if (res == null) {
        _clearOrganizationState();
      } else {
        final orgJson = res['organizations'] as Map<String, dynamic>;
        _currentOrganization = Organization.fromJson(orgJson);
        _currentMembership = OrganizationMember.fromJson(res);
        await loadOrganizationMembers();
        await loadIntegrationSettings();
        await loadIncidents();
      }
    } catch (e) {
      debugPrint('Error loading organization: ${e}');
    } finally {
      _isLoadingOrg = false;
      notifyListeners();
    }
  }

  Future<void> loadOrganizationMembers() async {
    final orgId = _currentOrganization?.id;
    if (orgId == null) {
      return;
    }
    try {
      final res = await Supabase.instance.client
          .from('organization_members')
          .select('*, profiles(display_name)')
          .eq('organization_id', orgId)
          .order('joined_at');
      _organizationMembers = (res as List<dynamic>).map((row) {
        final map = Map<String, dynamic>.from(row as Map<String, dynamic>);
        final profile = map['profiles'] as Map<String, dynamic>?;
        map['display_name'] = profile?['display_name'];
        return OrganizationMember.fromJson(map);
      }).toList();
      final uid = _currentUser?.id;
      if (uid != null) {
        _currentMembership = _organizationMembers.firstWhere(
          (m) => m.userId == uid,
          orElse: () => _currentMembership!,
        );
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading organization members: ${e}');
    }
  }

  Future<void> createOrganization(String name) async {
    final uid = _currentUser?.id;
    if (uid == null || name.trim().isEmpty) {
      return;
    }
    _isLoadingOrg = true;
    notifyListeners();
    try {
      await Supabase.instance.client.from('organizations').insert({
        'name': name.trim(),
        'created_by': uid,
      });
      await loadOrganization();
    } finally {
      _isLoadingOrg = false;
      notifyListeners();
    }
  }

  Future<void> redeemInviteCode(String code) async {
    if (code.trim().isEmpty) {
      throw Exception('Invite code is required');
    }
    await Supabase.instance.client.rpc(
      'redeem_org_invite',
      params: {'p_code': code.trim()},
    );
    await loadOrganization();
  }

  String _generateSecureToken() {
    final rand = Random.secure();
    final bytes = List<int>.generate(32, (_) => rand.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  Future<String> createJoinRequest({
    UserRole requestedRole = UserRole.responder,
  }) async {
    final uid = _currentUser?.id;
    if (uid == null) {
      throw Exception('Must be signed in to request to join an organization');
    }
    final token = _generateSecureToken();
    final res = await Supabase.instance.client
        .from('join_requests')
        .insert({
          'requester_user_id': uid,
          'token': token,
          'requested_role': requestedRole.name,
        })
        .select()
        .single();
    _pendingJoinRequestId = res['id'] as String;
    _pendingJoinRequestToken = token;
    _pendingJoinRequestStatus = JoinRequestStatus.pending;
    notifyListeners();
    return token;
  }

  Future<void> refreshJoinRequestStatus() async {
    final id = _pendingJoinRequestId;
    if (id == null) {
      return;
    }
    try {
      final res = await Supabase.instance.client
          .from('join_requests')
          .select()
          .eq('id', id)
          .maybeSingle();
      if (res == null) {
        return;
      }
      final request = JoinRequest.fromJson(res);
      _pendingJoinRequestStatus = request.status;
      notifyListeners();
      if (request.status == JoinRequestStatus.approved) {
        _pendingJoinRequestId = null;
        _pendingJoinRequestToken = null;
        await loadOrganization();
      }
    } catch (e) {
      debugPrint('Error refreshing join request status: ${e}');
    }
  }

  Future<void> cancelJoinRequest() async {
    final id = _pendingJoinRequestId;
    if (id == null) {
      return;
    }
    try {
      await Supabase.instance.client
          .from('join_requests')
          .update({'status': 'expired'})
          .eq('id', id);
    } catch (e) {
      debugPrint('Error cancelling join request: ${e}');
    } finally {
      _pendingJoinRequestId = null;
      _pendingJoinRequestToken = null;
      _pendingJoinRequestStatus = null;
      notifyListeners();
    }
  }

  Future<void> lookupJoinRequest(String token) async {
    final res = await Supabase.instance.client.rpc(
      'lookup_join_request',
      params: {'p_token': token},
    );
    final rows = res as List<dynamic>;
    if (rows.isEmpty) {
      _scannedJoinRequest = null;
      notifyListeners();
      throw Exception(
        'This code is no longer valid. Ask them to generate a new one.',
      );
    }
    final row = rows.first as Map<String, dynamic>;
    _scannedJoinRequest = JoinRequest(
      id: row['request_id'] as String,
      requesterUserId: row['requester_user_id'] as String,
      token: token,
      status: JoinRequestStatus.values.firstWhere(
        (e) => e.name == (row['status'] as String),
        orElse: () => JoinRequestStatus.pending,
      ),
      requestedRole: UserRole.values.firstWhere(
        (e) => e.name == (row['requested_role'] as String),
        orElse: () => UserRole.responder,
      ),
      expiresAt: DateTime.parse(row['expires_at'] as String),
      createdAt: DateTime.now(),
      requesterDisplayName: row['requester_display_name'] as String?,
    );
    notifyListeners();
  }

  Future<void> approveScannedJoinRequest() async {
    final request = _scannedJoinRequest;
    final orgId = _currentOrganization?.id;
    if (request == null || orgId == null) {
      return;
    }
    await Supabase.instance.client.rpc(
      'approve_join_request',
      params: {'p_request_id': request.id, 'p_organization_id': orgId},
    );
    _scannedJoinRequest = null;
    notifyListeners();
    await loadOrganizationMembers();
  }

  Future<void> denyScannedJoinRequest() async {
    final request = _scannedJoinRequest;
    final orgId = _currentOrganization?.id;
    if (request == null || orgId == null) {
      return;
    }
    await Supabase.instance.client.rpc(
      'deny_join_request',
      params: {'p_request_id': request.id, 'p_organization_id': orgId},
    );
    _scannedJoinRequest = null;
    notifyListeners();
  }

  Future<void> loadInvites() async {
    final orgId = _currentOrganization?.id;
    if (orgId == null) {
      return;
    }
    try {
      final res = await Supabase.instance.client
          .from('org_invites')
          .select()
          .eq('organization_id', orgId)
          .order('created_at', ascending: false);
      _invites = (res as List<dynamic>)
          .map((e) => OrgInvite.fromJson(e as Map<String, dynamic>))
          .toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading invites: ${e}');
    }
  }

  Future<void> createInvite({
    UserRole roleToGrant = UserRole.responder,
    int? maxUses,
    DateTime? expiresAt,
  }) async {
    final orgId = _currentOrganization?.id;
    final uid = _currentUser?.id;
    if (orgId == null || uid == null) {
      return;
    }
    await Supabase.instance.client.from('org_invites').insert({
      'organization_id': orgId,
      'created_by': uid,
      'role_to_grant': roleToGrant.name,
      'max_uses': maxUses,
      'expires_at': expiresAt?.toIso8601String(),
    });
    await loadInvites();
  }

  Future<void> revokeInvite(String inviteId) async {
    await Supabase.instance.client
        .from('org_invites')
        .update({'revoked': true})
        .eq('id', inviteId);
    await loadInvites();
  }

  Future<void> updateMemberRole(String memberId, UserRole role) async {
    try {
      await Supabase.instance.client
          .from('organization_members')
          .update({'role': role.name})
          .eq('id', memberId);
      await loadOrganizationMembers();
    } catch (e) {
      debugPrint('Error updating member role: ${e}');
    }
  }

  Future<void> removeMember(String memberId) async {
    try {
      await Supabase.instance.client
          .from('organization_members')
          .delete()
          .eq('id', memberId);
      await loadOrganizationMembers();
    } catch (e) {
      debugPrint('Error removing member: ${e}');
    }
  }

  Future<void> leaveOrganization() async {
    final uid = _currentUser?.id;
    final orgId = _currentOrganization?.id;
    if (uid == null || orgId == null) {
      return;
    }
    try {
      await Supabase.instance.client
          .from('organization_members')
          .delete()
          .eq('organization_id', orgId)
          .eq('user_id', uid);
      _clearOrganizationState();
      notifyListeners();
    } catch (e) {
      debugPrint('Error leaving organization: ${e}');
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

  Future<void> register(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await Supabase.instance.client.auth.signUp(email: email, password: password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
    _currentUser = null;
    _clearOrganizationState();
    initLocalSettings();
    notifyListeners();
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
      _azureTenantId = sharedPrefs.getString('azure_tenant_id') ?? '';
      _azureClientId = sharedPrefs.getString('azure_client_id') ?? '';
      _azureClientSecret = sharedPrefs.getString('azure_client_secret') ?? '';
      _azureSubscriptionId =
          sharedPrefs.getString('azure_subscription_id') ?? '';
      _gcpProjectId = sharedPrefs.getString('gcp_project_id') ?? '';
      _gcpTokenOrKey = sharedPrefs.getString('gcp_token_or_key') ?? '';
      _gcpIsApiKey = sharedPrefs.getBool('gcp_is_api_key') ?? true;
    } catch (e) {
      debugPrint('Error reading settings locally: ${e}');
    }
  }

  Future<void> loadIntegrationSettings() async {
    final orgId = _currentOrganization?.id;
    if (orgId == null) {
      return;
    }
    try {
      final settingsRes = await Supabase.instance.client
          .from('integration_settings')
          .select()
          .eq('organization_id', orgId)
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
      } else if (currentUserRole == UserRole.commander) {
        await Supabase.instance.client.from('integration_settings').insert({
          'organization_id': orgId,
        });
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading integration settings: ${e}');
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
    required String azureTenantId,
    required String azureClientId,
    required String azureClientSecret,
    required String azureSubscriptionId,
    required String gcpProjectId,
    required String gcpTokenOrKey,
    required bool gcpIsApiKey,
  }) async {
    final orgId = _currentOrganization?.id;
    final uid = _currentUser?.id;
    if (orgId == null || uid == null) {
      return;
    }
    _githubOwner = githubOwner;
    _githubRepo = githubRepo;
    _githubToken = githubToken;
    _pagerDutyToken = pagerDutyToken;
    _awsAccessKey = awsAccessKey;
    _awsSecretKey = awsSecretKey;
    _awsRegion = awsRegion;
    _azureTenantId = azureTenantId;
    _azureClientId = azureClientId;
    _azureClientSecret = azureClientSecret;
    _azureSubscriptionId = azureSubscriptionId;
    _gcpProjectId = gcpProjectId;
    _gcpTokenOrKey = gcpTokenOrKey;
    _gcpIsApiKey = gcpIsApiKey;
    notifyListeners();
    try {
      final encGitHub = SecurityService.encrypt(githubToken);
      final encPagerDuty = SecurityService.encrypt(pagerDutyToken);
      final encAWS = SecurityService.encrypt(awsSecretKey);
      final encAzure = SecurityService.encrypt(azureClientSecret);
      final encGCP = SecurityService.encrypt(gcpTokenOrKey);
      await Supabase.instance.client.from('integration_settings').upsert({
        'organization_id': orgId,
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
        'updated_by': uid,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('Error syncing integration settings: ${e}');
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
    final orgId = _currentOrganization?.id;
    if (orgId == null) {
      _incidents = [];
      notifyListeners();
      return;
    }
    _isLoading = true;
    notifyListeners();
    try {
      final repo = IncidentRepository();
      final fetchedList = await repo.fetchRealIncidents(
        githubOwner: _githubOwner,
        githubRepo: _githubRepo,
        githubToken: _githubToken,
        pagerDutyToken: _pagerDutyToken,
        awsAccessKey: _awsAccessKey,
        awsSecretKey: _awsSecretKey,
        awsRegion: _awsRegion,
        gcpProjectId: _gcpProjectId,
        gcpTokenOrKey: _gcpTokenOrKey,
        gcpIsApiKey: _gcpIsApiKey,
        azureTenantId: _azureTenantId,
        azureClientId: _azureClientId,
        azureClientSecret: _azureClientSecret,
        azureSubscriptionId: _azureSubscriptionId,
      );
      final existingRows = await Supabase.instance.client
          .from('incidents')
          .select('id')
          .eq('organization_id', orgId);
      final existingIds = (existingRows as List<dynamic>)
          .map((r) => r['id'] as String)
          .toSet();
      final newRows = fetchedList
          .where((incident) => !existingIds.contains(incident.id))
          .map(
            (incident) => {
              'id': incident.id,
              'organization_id': orgId,
              'title': incident.title,
              'description': incident.description,
              'status': incident.status.name,
              'urgency': incident.urgency,
              'service_data': incident.serviceData,
              'provider': incident.provider.name,
              'created_at': incident.createdAt.toIso8601String(),
              'raw_provider_payload': incident.rawProviderPayload,
            },
          )
          .toList();
      if (newRows.isNotEmpty) {
        await Supabase.instance.client.from('incidents').insert(newRows);
      }
      await _refreshIncidentsFromDb();
      await _refreshAnalytics();
    } catch (e) {
      debugPrint('Error loading incidents: ${e}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _refreshIncidentsFromDb() async {
    final orgId = _currentOrganization?.id;
    if (orgId == null) {
      return;
    }
    final rows = await Supabase.instance.client
        .from('incidents')
        .select()
        .eq('organization_id', orgId)
        .order('created_at', ascending: false);
    final incidentRows = rows as List<dynamic>;
    final incidentIds = incidentRows.map((r) => r['id'] as String).toList();
    Map<String, List<IncidentComment>> commentsByIncident = {};
    if (incidentIds.isNotEmpty) {
      final commentRows = await Supabase.instance.client
          .from('incident_comments')
          .select()
          .eq('organization_id', orgId)
          .order('created_at');
      for (final row in commentRows as List<dynamic>) {
        final map = row as Map<String, dynamic>;
        final incidentId = map['incident_id'] as String;
        commentsByIncident.putIfAbsent(incidentId, () => []).add(
          IncidentComment(
            id: map['id'] as String,
            userName: map['user_name'] as String? ?? 'Anonymous',
            text: map['text'] as String? ?? '',
            createdAt: DateTime.parse(map['created_at'] as String),
          ),
        );
      }
    }
    final now = DateTime.now();
    final updatedList = <DevOpsIncident>[];
    for (final row in incidentRows) {
      final map = row as Map<String, dynamic>;
      final incident = DevOpsIncident.fromJson(map);
      if (incident.status == IncidentStatus.resolved &&
          incident.resolvedAt != null) {
        final diff = now.difference(incident.resolvedAt!);
        if (diff.inMinutes >= 5) {
          continue;
        }
      }
      final assignedMemberId = incident.assignedToMemberId;
      final assignedMember = assignedMemberId != null
          ? _organizationMembers.firstWhere(
              (m) => m.id == assignedMemberId,
              orElse: () => _organizationMembers.first,
            )
          : null;
      updatedList.add(
        incident.copyWith(
          assignedToMember: assignedMember,
          comments: commentsByIncident[incident.id] ?? [],
        ),
      );
    }
    _incidents = updatedList;
  }

  Future<void> _refreshAnalytics() async {
    final orgId = _currentOrganization?.id;
    if (orgId == null) {
      _analytics = const IncidentAnalytics.empty();
      return;
    }
    try {
      final rows = await Supabase.instance.client
          .from('incidents')
          .select(
            'provider, created_at, acknowledged_at, assigned_at, resolved_at',
          )
          .eq('organization_id', orgId);
      final list = rows as List<dynamic>;
      final providerCounts = <IncidentProvider, int>{};
      final ackDurations = <Duration>[];
      final resolveDurations = <Duration>[];
      final assignDurations = <Duration>[];
      for (final row in list) {
        final map = row as Map<String, dynamic>;
        final provider = IncidentProvider.values.firstWhere(
          (e) => e.name == (map['provider'] as String),
          orElse: () => IncidentProvider.pagerDuty,
        );
        providerCounts[provider] = (providerCounts[provider] ?? 0) + 1;
        final createdAt = DateTime.parse(map['created_at'] as String);
        final ackAt = map['acknowledged_at'] != null
            ? DateTime.parse(map['acknowledged_at'] as String)
            : null;
        final resolvedAt = map['resolved_at'] != null
            ? DateTime.parse(map['resolved_at'] as String)
            : null;
        final assignedAt = map['assigned_at'] != null
            ? DateTime.parse(map['assigned_at'] as String)
            : null;
        if (ackAt != null) {
          ackDurations.add(ackAt.difference(createdAt));
        }
        if (resolvedAt != null) {
          resolveDurations.add(resolvedAt.difference(createdAt));
        }
        if (assignedAt != null) {
          assignDurations.add(assignedAt.difference(createdAt));
        }
      }
      Duration? average(List<Duration> values) {
        if (values.isEmpty) {
          return null;
        }
        final totalMs = values.fold<int>(0, (sum, d) => sum + d.inMilliseconds);
        return Duration(milliseconds: totalMs ~/ values.length);
      }

      _analytics = IncidentAnalytics(
        totalIncidents: list.length,
        providerCounts: providerCounts,
        meanTimeToAcknowledge: average(ackDurations),
        meanTimeToResolve: average(resolveDurations),
        meanTimeToAssignment: average(assignDurations),
      );
    } catch (e) {
      debugPrint('Error computing analytics: ${e}');
      _analytics = const IncidentAnalytics.empty();
    }
  }

  Future<void> acknowledgeIncident(String id) async {
    try {
      final index = _incidents.indexWhere((i) => i.id == id);
      if (index == -1) {
        return;
      }
      if (_incidents[index].acknowledgedAt == null) {
        await Supabase.instance.client
            .from('incidents')
            .update({
              'status': IncidentStatus.acknowledged.name,
              'acknowledged_at': DateTime.now().toIso8601String(),
            })
            .eq('id', id);
      } else {
        await Supabase.instance.client
            .from('incidents')
            .update({'status': IncidentStatus.acknowledged.name})
            .eq('id', id);
      }
      await _refreshIncidentsFromDb();
      await _refreshAnalytics();
      notifyListeners();
    } catch (e) {
      debugPrint('Error acknowledging incident: ${e}');
    }
  }

  Future<void> escalateIncident(String id) async {
    try {
      await Supabase.instance.client
          .from('incidents')
          .update({'status': IncidentStatus.escalated.name})
          .eq('id', id);
      await _refreshIncidentsFromDb();
      notifyListeners();
    } catch (e) {
      debugPrint('Error escalating incident: ${e}');
    }
  }

  Future<void> resolveIncident(String id) async {
    try {
      await Supabase.instance.client
          .from('incidents')
          .update({
            'status': IncidentStatus.resolved.name,
            'resolved_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id);
      await _refreshIncidentsFromDb();
      await _refreshAnalytics();
      notifyListeners();
    } catch (e) {
      debugPrint('Error resolving incident: ${e}');
    }
  }

  Future<void> assignIncident(String incidentId, String memberId) async {
    try {
      await Supabase.instance.client
          .from('incidents')
          .update({
            'assigned_to': memberId,
            'assigned_at': DateTime.now().toIso8601String(),
          })
          .eq('id', incidentId);
      await _refreshIncidentsFromDb();
      await _refreshAnalytics();
      notifyListeners();
    } catch (e) {
      debugPrint('Error assigning incident: ${e}');
    }
  }

  Future<void> addIncidentComment(String incidentId, String text) async {
    if (text.trim().isEmpty) {
      return;
    }
    final uid = _currentUser?.id;
    final orgId = _currentOrganization?.id;
    if (uid == null || orgId == null) {
      return;
    }
    try {
      final username =
          _currentMembership?.displayName ??
          _currentUser?.email?.split('@').first ??
          'On-Call Operator';
      await Supabase.instance.client.from('incident_comments').insert({
        'incident_id': incidentId,
        'organization_id': orgId,
        'user_id': uid,
        'user_name': username,
        'text': text.trim(),
      });
      await _refreshIncidentsFromDb();
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding comment: ${e}');
    }
  }
}

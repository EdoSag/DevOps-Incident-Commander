import 'package:flutter/material.dart';
import 'package:devops_incident_commander_dashboard/user_role.dart';
import 'package:devops_incident_commander_dashboard/globals/app_state.dart';
import 'package:devops_incident_commander_dashboard/models/org_invite.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _emailController;

  late final TextEditingController _passwordController;

  bool _isSignUpMode = false;

  late final TextEditingController _ghOwnerController;

  late final TextEditingController _ghRepoController;

  late final TextEditingController _ghTokenController;

  late final TextEditingController _pdTokenController;

  late final TextEditingController _awsAccessKeyController;

  late final TextEditingController _awsSecretKeyController;

  late final TextEditingController _awsRegionController;

  late final TextEditingController _azureTenantIdController;

  late final TextEditingController _azureClientIdController;

  late final TextEditingController _azureClientSecretController;

  late final TextEditingController _azureSubscriptionIdController;

  late final TextEditingController _gcpProjectIdController;

  late final TextEditingController _gcpTokenOrKeyController;

  bool _gcpIsApiKey = true;

  @override
  void initState() {
    super.initState();
    final appState = AppState.of(context, listen: false);
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _ghOwnerController = TextEditingController(text: appState.githubOwner);
    _ghRepoController = TextEditingController(text: appState.githubRepo);
    _ghTokenController = TextEditingController(text: appState.githubToken);
    _pdTokenController = TextEditingController(text: appState.pagerDutyToken);
    _awsAccessKeyController = TextEditingController(
      text: appState.awsAccessKey,
    );
    _awsSecretKeyController = TextEditingController(
      text: appState.awsSecretKey,
    );
    _awsRegionController = TextEditingController(text: appState.awsRegion);
    _azureTenantIdController = TextEditingController(
      text: appState.azureTenantId,
    );
    _azureClientIdController = TextEditingController(
      text: appState.azureClientId,
    );
    _azureClientSecretController = TextEditingController(
      text: appState.azureClientSecret,
    );
    _azureSubscriptionIdController = TextEditingController(
      text: appState.azureSubscriptionId,
    );
    _gcpProjectIdController = TextEditingController(
      text: appState.gcpProjectId,
    );
    _gcpTokenOrKeyController = TextEditingController(
      text: appState.gcpTokenOrKey,
    );
    _gcpIsApiKey = appState.gcpIsApiKey;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      appState.resetTestResults();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _ghOwnerController.dispose();
    _ghRepoController.dispose();
    _ghTokenController.dispose();
    _pdTokenController.dispose();
    _awsAccessKeyController.dispose();
    _awsSecretKeyController.dispose();
    _awsRegionController.dispose();
    _azureTenantIdController.dispose();
    _azureClientIdController.dispose();
    _azureClientSecretController.dispose();
    _azureSubscriptionIdController.dispose();
    _gcpProjectIdController.dispose();
    _gcpTokenOrKeyController.dispose();
    super.dispose();
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.blueGrey,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    bool enabled = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        enabled: enabled,
        style: const TextStyle(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          prefixIcon: Icon(icon, color: Colors.blueGrey, size: 18),
          filled: true,
          fillColor: const Color(0xFF141724),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF1E2235)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.blueAccent),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildTestResultBox({
    required bool isLoading,
    bool? success,
    String? message,
  }) {
    if (!isLoading && success == null && (message == null || message.isEmpty)) {
      return const SizedBox.shrink();
    }
    Color bgColor = const Color(0xFF141724);
    Color borderColor = const Color(0xFF1E2235);
    Color textColor = Colors.white;
    IconData icon = Icons.info_outline;
    if (isLoading) {
      bgColor = Colors.blue.withOpacity(0.05);
      borderColor = Colors.blue.withOpacity(0.3);
      textColor = Colors.blue.shade300;
      icon = Icons.sync;
    } else if (success == true) {
      bgColor = Colors.green.withOpacity(0.05);
      borderColor = Colors.green.withOpacity(0.3);
      textColor = Colors.green.shade400;
      icon = Icons.check_circle_outline;
    } else if (success == false) {
      bgColor = Colors.red.withOpacity(0.05);
      borderColor = Colors.red.withOpacity(0.3);
      textColor = Colors.red.shade400;
      icon = Icons.error_outline;
    }
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          if (isLoading)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            )
          else
            Icon(icon, size: 18, color: textColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message ?? '',
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthPortal(AppState appState) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF111420),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF1E2235)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.shield_outlined,
                size: 48,
                color: Colors.blueAccent.shade400,
              ),
              const SizedBox(height: 12),
              Text(
                _isSignUpMode
                    ? 'CREATE COMMANDER ACCOUNT'
                    : 'SECURE COMMANDER LOG IN',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Access your DevOps configurations and delicate API tokens securely via hardware-backed encryption.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 11),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _emailController,
                label: 'Operational Email Address',
                hint: 'engineer@organization.com',
                icon: Icons.alternate_email_rounded,
              ),
              _buildTextField(
                controller: _passwordController,
                label: 'Password',
                hint: '••••••••',
                icon: Icons.lock_outline_rounded,
                obscureText: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: appState.isLoading
                    ? null
                    : () async {
                        try {
                          if (_isSignUpMode) {
                            await appState.register(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('Registration successful!'),
                              ),
                            );
                          } else {
                            await appState.login(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('Logged in successfully!'),
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(e.toString().split(':').last),
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: appState.isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        _isSignUpMode ? 'SIGN UP & GET KEYS' : 'SECURE SIGN IN',
                      ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => setState(() => _isSignUpMode = !_isSignUpMode),
                child: Text(
                  _isSignUpMode
                      ? 'Already have an account? Log In'
                      : 'Don\'t have a secure account? Sign Up',
                  style: const TextStyle(color: Colors.blueGrey, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrganizationSection(AppState appState) {
    final isCommander = appState.currentUserRole == UserRole.commander;
    final org = appState.currentOrganization;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111420),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E2235)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.apartment_rounded, color: Colors.blueAccent),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      org?.name ?? 'No Available Data',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${appState.organizationMembers.length} member${appState.organizationMembers.length == 1 ? '' : 's'} · Your role: ${appState.currentUserRole.displayName}',
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => _showMembersSheet(context, appState),
                icon: const Icon(Icons.groups_outlined, size: 16),
                label: const Text('Members', style: TextStyle(fontSize: 11)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFF333852)),
                ),
              ),
              if (isCommander)
                OutlinedButton.icon(
                  onPressed: () => _showInvitesSheet(context, appState),
                  icon: const Icon(Icons.link_rounded, size: 16),
                  label: const Text('Invites', style: TextStyle(fontSize: 11)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF333852)),
                  ),
                ),
              if (isCommander)
                OutlinedButton.icon(
                  onPressed: () => context.push('/org-scan'),
                  icon: const Icon(Icons.qr_code_scanner_rounded, size: 16),
                  label: const Text(
                    'Scan QR to Add',
                    style: TextStyle(fontSize: 11),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF333852)),
                  ),
                ),
              OutlinedButton.icon(
                onPressed: () async {
                  await appState.leaveOrganization();
                },
                icon: const Icon(Icons.logout_rounded, size: 16),
                label: const Text(
                  'Leave Organization',
                  style: TextStyle(fontSize: 11),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade400,
                  side: BorderSide(color: Colors.red.withOpacity(0.4)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showMembersSheet(BuildContext context, AppState appState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111420),
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            final isCommander = appState.currentUserRole == UserRole.commander;
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ORGANIZATION MEMBERS',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 400),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: appState.organizationMembers.length,
                      itemBuilder: (context, index) {
                        final member = appState.organizationMembers[index];
                        return ListTile(
                          title: Text(
                            member.resolvedDisplayName,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            member.role.displayName,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: isCommander
                              ? PopupMenuButton<String>(
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.grey,
                                  ),
                                  onSelected: (value) async {
                                    if (value == 'remove') {
                                      await appState.removeMember(member.id);
                                    } else {
                                      final newRole = UserRole.values.firstWhere(
                                        (r) => r.name == value,
                                      );
                                      await appState.updateMemberRole(
                                        member.id,
                                        newRole,
                                      );
                                    }
                                    setSheetState(() {});
                                  },
                                  itemBuilder: (context) => [
                                    for (final role in UserRole.values)
                                      PopupMenuItem(
                                        value: role.name,
                                        child: Text(
                                          'Set as ${role.displayName}',
                                        ),
                                      ),
                                    const PopupMenuItem(
                                      value: 'remove',
                                      child: Text('Remove from team'),
                                    ),
                                  ],
                                )
                              : null,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showInvitesSheet(BuildContext context, AppState appState) {
    appState.loadInvites();
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111420),
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'INVITE LINKS',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          await appState.createInvite();
                          setSheetState(() {});
                        },
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text(
                          'New Invite',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 400),
                    child: appState.invites.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Text(
                              'No Available Data',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: appState.invites.length,
                            itemBuilder: (context, index) {
                              final OrgInvite invite = appState.invites[index];
                              return ListTile(
                                title: Text(
                                  invite.code,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Courier',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  invite.isActive
                                      ? 'Active · Grants ${invite.roleToGrant.displayName} · Used ${invite.useCount} time(s)'
                                      : 'Inactive',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                trailing: invite.isActive
                                    ? IconButton(
                                        icon: const Icon(
                                          Icons.block,
                                          color: Colors.redAccent,
                                        ),
                                        onPressed: () async {
                                          await appState.revokeInvite(invite.id);
                                          setSheetState(() {});
                                        },
                                      )
                                    : null,
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final user = appState.currentUser;
    final isCommander = appState.currentUserRole == UserRole.commander;
    return Scaffold(
      backgroundColor: const Color(0xFF0F111A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141724),
        elevation: 0,
        title: Text(
          user != null ? 'Secure Cloud Connection' : 'Authentication Required',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/home-page');
            }
          },
        ),
      ),
      body: SafeArea(
        child: user == null
            ? _buildAuthPortal(appState)
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF141724),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF1E2235),
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.blueAccent
                                      .withOpacity(0.15),
                                  child: const Icon(
                                    Icons.lock_open,
                                    color: Colors.blueAccent,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.email ?? 'Active Session',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Authorized: ${appState.currentUserRole.displayName}',
                                        style: const TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                OutlinedButton.icon(
                                  onPressed: () => appState.logout(),
                                  icon: const Icon(Icons.logout, size: 12),
                                  label: const Text(
                                    'Sign Out',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red.shade400,
                                    side: BorderSide(
                                      color: Colors.red.withOpacity(0.4),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildSectionHeader('Organization'),
                          _buildOrganizationSection(appState),
                          if (!isCommander)
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.amber.withOpacity(0.3),
                                ),
                              ),
                              child: const Text(
                                'Only a Commander can edit integration credentials. Ask your commander to update these below.',
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          _buildSectionHeader('GitHub Actions'),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF111420),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF1E2235),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildTextField(
                                  controller: _ghOwnerController,
                                  label: 'Repository Owner / Organization',
                                  hint: 'e.g., flutter',
                                  icon: Icons.business,
                                  enabled: isCommander,
                                ),
                                _buildTextField(
                                  controller: _ghRepoController,
                                  label: 'Repository Name',
                                  hint: 'e.g., flutter',
                                  icon: Icons.code,
                                  enabled: isCommander,
                                ),
                                _buildTextField(
                                  controller: _ghTokenController,
                                  label: 'Personal Access Token (PAT)',
                                  hint: 'ghp_xxxxxxxxxxxxxxxxxxxxxxxx',
                                  icon: Icons.vpn_key_outlined,
                                  obscureText: true,
                                  enabled: isCommander,
                                ),
                                const SizedBox(height: 4),
                                ElevatedButton.icon(
                                  onPressed: appState.isTestingGitHub
                                      ? null
                                      : () {
                                          appState.testGitHub(
                                            _ghOwnerController.text.trim(),
                                            _ghRepoController.text.trim(),
                                            _ghTokenController.text.trim(),
                                          );
                                        },
                                  icon: const Icon(Icons.bolt, size: 16),
                                  label: const Text('Test GitHub Connection'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1E2235),
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor: const Color(
                                      0xFF141724,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: const BorderSide(
                                        color: Color(0xFF333852),
                                      ),
                                    ),
                                  ),
                                ),
                                _buildTestResultBox(
                                  isLoading: appState.isTestingGitHub,
                                  success: appState.githubTestSuccess,
                                  message: appState.githubTestMessage,
                                ),
                              ],
                            ),
                          ),
                          _buildSectionHeader('PagerDuty'),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF111420),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF1E2235),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildTextField(
                                  controller: _pdTokenController,
                                  label: 'PagerDuty API Token',
                                  hint: 'y_xxxxxxxxxxxxxxxxxxxxxx',
                                  icon: Icons.security_rounded,
                                  obscureText: true,
                                  enabled: isCommander,
                                ),
                                const SizedBox(height: 4),
                                ElevatedButton.icon(
                                  onPressed: appState.isTestingPagerDuty
                                      ? null
                                      : () {
                                          appState.testPagerDuty(
                                            _pdTokenController.text.trim(),
                                          );
                                        },
                                  icon: const Icon(Icons.bolt, size: 16),
                                  label: const Text(
                                    'Test PagerDuty Connection',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1E2235),
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor: const Color(
                                      0xFF141724,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: const BorderSide(
                                        color: Color(0xFF333852),
                                      ),
                                    ),
                                  ),
                                ),
                                _buildTestResultBox(
                                  isLoading: appState.isTestingPagerDuty,
                                  success: appState.pagerDutyTestSuccess,
                                  message: appState.pagerDutyTestMessage,
                                ),
                              ],
                            ),
                          ),
                          _buildSectionHeader('AWS CloudWatch'),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF111420),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF1E2235),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildTextField(
                                  controller: _awsAccessKeyController,
                                  label: 'AWS Access Key ID',
                                  hint: 'AKIAxxxxxxxxxxxxxxxx',
                                  icon: Icons.key_rounded,
                                  enabled: isCommander,
                                ),
                                _buildTextField(
                                  controller: _awsSecretKeyController,
                                  label: 'AWS Secret Access Key',
                                  hint:
                                      'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
                                  icon: Icons.vpn_key_rounded,
                                  obscureText: true,
                                  enabled: isCommander,
                                ),
                                _buildTextField(
                                  controller: _awsRegionController,
                                  label: 'AWS Region',
                                  hint: 'us-east-1',
                                  icon: Icons.public,
                                  enabled: isCommander,
                                ),
                                const SizedBox(height: 4),
                                ElevatedButton.icon(
                                  onPressed: appState.isTestingAws
                                      ? null
                                      : () {
                                          appState.testAws(
                                            _awsAccessKeyController.text.trim(),
                                            _awsSecretKeyController.text.trim(),
                                            _awsRegionController.text.trim(),
                                          );
                                        },
                                  icon: const Icon(Icons.bolt, size: 16),
                                  label: const Text('Test AWS Connection'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1E2235),
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor: const Color(
                                      0xFF141724,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: const BorderSide(
                                        color: Color(0xFF333852),
                                      ),
                                    ),
                                  ),
                                ),
                                _buildTestResultBox(
                                  isLoading: appState.isTestingAws,
                                  success: appState.awsTestSuccess,
                                  message: appState.awsTestMessage,
                                ),
                              ],
                            ),
                          ),
                          _buildSectionHeader('Azure Monitor'),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF111420),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF1E2235),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildTextField(
                                  controller: _azureTenantIdController,
                                  label: 'Azure Tenant ID',
                                  hint: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
                                  icon: Icons.corporate_fare_rounded,
                                  enabled: isCommander,
                                ),
                                _buildTextField(
                                  controller: _azureClientIdController,
                                  label: 'Azure Client / Application ID',
                                  hint: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
                                  icon: Icons.account_box_rounded,
                                  enabled: isCommander,
                                ),
                                _buildTextField(
                                  controller: _azureClientSecretController,
                                  label: 'Azure Client Secret',
                                  hint: 'secret_key_string',
                                  icon: Icons.vpn_key_rounded,
                                  obscureText: true,
                                  enabled: isCommander,
                                ),
                                _buildTextField(
                                  controller: _azureSubscriptionIdController,
                                  label: 'Azure Subscription ID',
                                  hint: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
                                  icon: Icons.assignment_rounded,
                                  enabled: isCommander,
                                ),
                                const SizedBox(height: 4),
                                ElevatedButton.icon(
                                  onPressed: appState.isTestingAzure
                                      ? null
                                      : () {
                                          appState.testAzure(
                                            _azureTenantIdController.text
                                                .trim(),
                                            _azureClientIdController.text
                                                .trim(),
                                            _azureClientSecretController.text
                                                .trim(),
                                            _azureSubscriptionIdController.text
                                                .trim(),
                                          );
                                        },
                                  icon: const Icon(Icons.bolt, size: 16),
                                  label: const Text('Test Azure Connection'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1E2235),
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor: const Color(
                                      0xFF141724,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: const BorderSide(
                                        color: Color(0xFF333852),
                                      ),
                                    ),
                                  ),
                                ),
                                _buildTestResultBox(
                                  isLoading: appState.isTestingAzure,
                                  success: appState.azureTestSuccess,
                                  message: appState.azureTestMessage,
                                ),
                              ],
                            ),
                          ),
                          _buildSectionHeader('GCP Cloud Monitoring'),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF111420),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF1E2235),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildTextField(
                                  controller: _gcpProjectIdController,
                                  label: 'GCP Project ID',
                                  hint: 'e.g., project-prod-102',
                                  icon: Icons.api_rounded,
                                  enabled: isCommander,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Auth Mode: ',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      ChoiceChip(
                                        label: const Text(
                                          'API Key',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        selected: _gcpIsApiKey,
                                        onSelected: !isCommander
                                            ? null
                                            : (selected) {
                                                if (selected) {
                                                  setState(
                                                    () => _gcpIsApiKey = true,
                                                  );
                                                }
                                              },
                                      ),
                                      const SizedBox(width: 8),
                                      ChoiceChip(
                                        label: const Text(
                                          'Bearer Token',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        selected: !_gcpIsApiKey,
                                        onSelected: !isCommander
                                            ? null
                                            : (selected) {
                                                if (selected) {
                                                  setState(
                                                    () => _gcpIsApiKey = false,
                                                  );
                                                }
                                              },
                                      ),
                                    ],
                                  ),
                                ),
                                _buildTextField(
                                  controller: _gcpTokenOrKeyController,
                                  label: _gcpIsApiKey
                                      ? 'GCP API Key'
                                      : 'OAuth Access Token',
                                  hint: _gcpIsApiKey
                                      ? 'AIzaSyxxxxxxxxxxxxxxxxxxxxx'
                                      : 'ya29.A0ARxxxxxxxxxxxxxxxxxxxxxx',
                                  icon: Icons.vpn_key_rounded,
                                  obscureText: true,
                                  enabled: isCommander,
                                ),
                                const SizedBox(height: 4),
                                ElevatedButton.icon(
                                  onPressed: appState.isTestingGcp
                                      ? null
                                      : () {
                                          appState.testGcp(
                                            _gcpProjectIdController.text.trim(),
                                            _gcpTokenOrKeyController.text
                                                .trim(),
                                            _gcpIsApiKey,
                                          );
                                        },
                                  icon: const Icon(Icons.bolt, size: 16),
                                  label: const Text('Test GCP Connection'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1E2235),
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor: const Color(
                                      0xFF141724,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: const BorderSide(
                                        color: Color(0xFF333852),
                                      ),
                                    ),
                                  ),
                                ),
                                _buildTestResultBox(
                                  isLoading: appState.isTestingGcp,
                                  success: appState.gcpTestSuccess,
                                  message: appState.gcpTestMessage,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  if (isCommander)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFF141724),
                        border: Border(
                          top: BorderSide(color: Color(0xFF1E2235), width: 1),
                        ),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await appState.saveSettings(
                              githubOwner: _ghOwnerController.text.trim(),
                              githubRepo: _ghRepoController.text.trim(),
                              githubToken: _ghTokenController.text.trim(),
                              pagerDutyToken: _pdTokenController.text.trim(),
                              awsAccessKey: _awsAccessKeyController.text.trim(),
                              awsSecretKey: _awsSecretKeyController.text.trim(),
                              awsRegion: _awsRegionController.text.trim(),
                              azureTenantId: _azureTenantIdController.text
                                  .trim(),
                              azureClientId: _azureClientIdController.text
                                  .trim(),
                              azureClientSecret: _azureClientSecretController
                                  .text
                                  .trim(),
                              azureSubscriptionId:
                                  _azureSubscriptionIdController.text.trim(),
                              gcpProjectId: _gcpProjectIdController.text.trim(),
                              gcpTokenOrKey: _gcpTokenOrKeyController.text
                                  .trim(),
                              gcpIsApiKey: _gcpIsApiKey,
                            );
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Color(0xFF66BB6A),
                                  content: Text(
                                    'Configuration saved and encrypted successfully!',
                                  ),
                                ),
                              );
                              if (Navigator.of(context).canPop()) {
                                Navigator.of(context).pop();
                              } else {
                                context.go('/home-page');
                              }
                            }
                          },
                          icon: const Icon(Icons.save, size: 18),
                          label: const Text('SAVE & REFRESH DASHBOARD'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

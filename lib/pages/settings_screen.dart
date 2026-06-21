import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart'
    hide Border, BoxDecoration, SwitchListTile, Switch, ChoiceChip;
import 'package:devops_incident_commander_dashboard/globals/app_state.dart';
import 'package:go_router/go_router.dart';

@NowaGenerated()
class SettingsScreen extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() {
    return _SettingsScreenState();
  }
}

@NowaGenerated()
class _SettingsScreenState extends State<SettingsScreen> {
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

  bool _awsSimulated = true;

  bool _gcpSimulated = true;

  bool _azureSimulated = true;

  @override
  void initState() {
    super.initState();
    final appState = AppState.of(context, listen: false);
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
    _awsSimulated = appState.awsSimulated;
    _gcpSimulated = appState.gcpSimulated;
    _azureSimulated = appState.azureSimulated;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      appState.resetTestResults();
    });
  }

  @override
  void dispose() {
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
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
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
    if (!isLoading &&
        success == null &&
        (message == null || message!.isEmpty)) {
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

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF0F111A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141724),
        elevation: 0,
        title: Text(
          'Platform Connections',
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Configure live DevOps platform connections to ingest direct cloud metrics, actions and incident data.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSectionHeader('GitHub Actions'),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111420),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF1E2235)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildTextField(
                            controller: _ghOwnerController,
                            label: 'Repository Owner / Organization',
                            hint: 'e.g., flutter',
                            icon: Icons.business,
                          ),
                          _buildTextField(
                            controller: _ghRepoController,
                            label: 'Repository Name',
                            hint: 'e.g., flutter',
                            icon: Icons.code,
                          ),
                          _buildTextField(
                            controller: _ghTokenController,
                            label: 'Personal Access Token (PAT)',
                            hint: 'ghp_xxxxxxxxxxxxxxxxxxxxxxxx',
                            icon: Icons.vpn_key_outlined,
                            obscureText: true,
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
                              disabledBackgroundColor: const Color(0xFF141724),
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
                        border: Border.all(color: const Color(0xFF1E2235)),
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
                            label: const Text('Test PagerDuty Connection'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E2235),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: const Color(0xFF141724),
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
                        border: Border.all(color: const Color(0xFF1E2235)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildTextField(
                            controller: _awsAccessKeyController,
                            label: 'AWS Access Key ID',
                            hint: 'AKIAxxxxxxxxxxxxxxxx',
                            icon: Icons.key_rounded,
                          ),
                          _buildTextField(
                            controller: _awsSecretKeyController,
                            label: 'AWS Secret Access Key',
                            hint: 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
                            icon: Icons.vpn_key_rounded,
                            obscureText: true,
                          ),
                          _buildTextField(
                            controller: _awsRegionController,
                            label: 'AWS Region',
                            hint: 'us-east-1',
                            icon: Icons.public,
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
                              disabledBackgroundColor: const Color(0xFF141724),
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
                        border: Border.all(color: const Color(0xFF1E2235)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildTextField(
                            controller: _azureTenantIdController,
                            label: 'Azure Tenant ID',
                            hint: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
                            icon: Icons.corporate_fare_rounded,
                          ),
                          _buildTextField(
                            controller: _azureClientIdController,
                            label: 'Azure Client / Application ID',
                            hint: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
                            icon: Icons.account_box_rounded,
                          ),
                          _buildTextField(
                            controller: _azureClientSecretController,
                            label: 'Azure Client Secret',
                            hint: 'secret_key_string',
                            icon: Icons.vpn_key_rounded,
                            obscureText: true,
                          ),
                          _buildTextField(
                            controller: _azureSubscriptionIdController,
                            label: 'Azure Subscription ID',
                            hint: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
                            icon: Icons.assignment_rounded,
                          ),
                          const SizedBox(height: 4),
                          ElevatedButton.icon(
                            onPressed: appState.isTestingAzure
                                ? null
                                : () {
                                    appState.testAzure(
                                      _azureTenantIdController.text.trim(),
                                      _azureClientIdController.text.trim(),
                                      _azureClientSecretController.text.trim(),
                                      _azureSubscriptionIdController.text
                                          .trim(),
                                    );
                                  },
                            icon: const Icon(Icons.bolt, size: 16),
                            label: const Text('Test Azure Connection'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E2235),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: const Color(0xFF141724),
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
                        border: Border.all(color: const Color(0xFF1E2235)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildTextField(
                            controller: _gcpProjectIdController,
                            label: 'GCP Project ID',
                            hint: 'e.g., project-prod-102',
                            icon: Icons.api_rounded,
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
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _gcpIsApiKey = true;
                                      });
                                    }
                                  },
                                  backgroundColor: const Color(0xFF1E2235),
                                  selectedColor: Colors.blueAccent.shade400,
                                  labelStyle: TextStyle(
                                    color: _gcpIsApiKey
                                        ? Colors.white
                                        : Colors.blueGrey,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ChoiceChip(
                                  label: const Text(
                                    'Bearer Token',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  selected: !_gcpIsApiKey,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _gcpIsApiKey = false;
                                      });
                                    }
                                  },
                                  backgroundColor: const Color(0xFF1E2235),
                                  selectedColor: Colors.blueAccent.shade400,
                                  labelStyle: TextStyle(
                                    color: !_gcpIsApiKey
                                        ? Colors.white
                                        : Colors.blueGrey,
                                  ),
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
                          ),
                          const SizedBox(height: 4),
                          ElevatedButton.icon(
                            onPressed: appState.isTestingGcp
                                ? null
                                : () {
                                    appState.testGcp(
                                      _gcpProjectIdController.text.trim(),
                                      _gcpTokenOrKeyController.text.trim(),
                                      _gcpIsApiKey,
                                    );
                                  },
                            icon: const Icon(Icons.bolt, size: 16),
                            label: const Text('Test GCP Connection'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E2235),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: const Color(0xFF141724),
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
                    _buildSectionHeader('Cloud Monitoring Simulators'),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111420),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF1E2235)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Simulate AWS CloudWatch',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Generates mock alarms from AWS EC2/RDS metrics.',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: _awsSimulated,
                                onChanged: (value) {
                                  setState(() {
                                    _awsSimulated = value;
                                  });
                                },
                                activeThumbColor: Colors.orange.shade700,
                              ),
                            ],
                          ),
                          const Divider(color: Color(0xFF1E2235), height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Simulate GCP Cloud Monitoring',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Generates mock resource container memory OOM failures.',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: _gcpSimulated,
                                onChanged: (value) {
                                  setState(() {
                                    _gcpSimulated = value;
                                  });
                                },
                                activeThumbColor: Colors.green.shade600,
                              ),
                            ],
                          ),
                          const Divider(color: Color(0xFF1E2235), height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Simulate Azure Monitor',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Generates mock PostgreSQL replica sync timeouts.',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: _azureSimulated,
                                onChanged: (value) {
                                  setState(() {
                                    _azureSimulated = value;
                                  });
                                },
                                activeThumbColor: Colors.blue.shade600,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
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
                      awsSimulated: _awsSimulated,
                      azureTenantId: _azureTenantIdController.text.trim(),
                      azureClientId: _azureClientIdController.text.trim(),
                      azureClientSecret: _azureClientSecretController.text
                          .trim(),
                      azureSubscriptionId: _azureSubscriptionIdController.text
                          .trim(),
                      azureSimulated: _azureSimulated,
                      gcpProjectId: _gcpProjectIdController.text.trim(),
                      gcpTokenOrKey: _gcpTokenOrKeyController.text.trim(),
                      gcpIsApiKey: _gcpIsApiKey,
                      gcpSimulated: _gcpSimulated,
                    );
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Color(0xFF66BB6A),
                          content: Text(
                            'Configuration saved successfully! Refreshing feeds...',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
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

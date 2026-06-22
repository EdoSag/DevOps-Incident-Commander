import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:devops_incident_commander_dashboard/globals/app_state.dart';
import 'package:devops_incident_commander_dashboard/user_role.dart';
import 'package:devops_incident_commander_dashboard/models/join_request.dart';

@NowaGenerated()
class OnboardingScreen extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() {
    return _OnboardingScreenState();
  }
}

@NowaGenerated()
class _OnboardingScreenState extends State<OnboardingScreen> {
  int _selectedTab = 0;

  late final TextEditingController _orgNameController;

  late final TextEditingController _inviteCodeController;

  bool _isSubmitting = false;

  String? _errorMessage;

  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _orgNameController = TextEditingController();
    _inviteCodeController = TextEditingController();
  }

  @override
  void dispose() {
    _orgNameController.dispose();
    _inviteCodeController.dispose();
    _pollTimer?.cancel();
    super.dispose();
  }

  void _startPolling(AppState appState) {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      appState.refreshJoinRequestStatus();
    });
  }

  Widget _buildTabButton(String label, int index) {
    final selected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _selectedTab = index;
          _errorMessage = null;
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.blueAccent : const Color(0xFF141724),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.grey.shade400,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateOrgView(AppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Start a new organization. You will become its Commander, able to manage members, invites, and integrations.',
          style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.4),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _orgNameController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Organization Name',
            labelStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: const Color(0xFF141724),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF1E2235)),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _isSubmitting
              ? null
              : () async {
                  if (_orgNameController.text.trim().isEmpty) {
                    setState(() => _errorMessage = 'Enter an organization name');
                    return;
                  }
                  setState(() {
                    _isSubmitting = true;
                    _errorMessage = null;
                  });
                  try {
                    await appState.createOrganization(
                      _orgNameController.text.trim(),
                    );
                  } catch (e) {
                    setState(() => _errorMessage = e.toString());
                  } finally {
                    if (mounted) {
                      setState(() => _isSubmitting = false);
                    }
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
          child: _isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('CREATE ORGANIZATION'),
        ),
      ],
    );
  }

  Widget _buildJoinCodeView(AppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Enter an invite code shared by your organization\'s commander.',
          style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.4),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _inviteCodeController,
          style: const TextStyle(
            color: Colors.white,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            labelText: 'Invite Code',
            labelStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: const Color(0xFF141724),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF1E2235)),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _isSubmitting
              ? null
              : () async {
                  if (_inviteCodeController.text.trim().isEmpty) {
                    setState(() => _errorMessage = 'Enter an invite code');
                    return;
                  }
                  setState(() {
                    _isSubmitting = true;
                    _errorMessage = null;
                  });
                  try {
                    await appState.redeemInviteCode(
                      _inviteCodeController.text.trim(),
                    );
                  } catch (e) {
                    setState(
                      () => _errorMessage = e.toString().split(':').last.trim(),
                    );
                  } finally {
                    if (mounted) {
                      setState(() => _isSubmitting = false);
                    }
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
          child: _isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('JOIN ORGANIZATION'),
        ),
      ],
    );
  }

  Widget _buildJoinQrView(AppState appState) {
    final token = appState.pendingJoinRequestToken;
    final status = appState.pendingJoinRequestStatus;
    if (token == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Generate a personal QR code and have an existing commander scan it in person to verify your identity and add you to the team.',
            style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isSubmitting
                ? null
                : () async {
                    setState(() {
                      _isSubmitting = true;
                      _errorMessage = null;
                    });
                    try {
                      await appState.createJoinRequest(
                        requestedRole: UserRole.responder,
                      );
                      _startPolling(appState);
                    } catch (e) {
                      setState(() => _errorMessage = e.toString());
                    } finally {
                      if (mounted) {
                        setState(() => _isSubmitting = false);
                      }
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
            child: const Text('GENERATE MY QR CODE'),
          ),
        ],
      );
    }
    final isDenied = status == JoinRequestStatus.denied;
    final isExpired = status == JoinRequestStatus.expired;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: QrImageView(
            data: 'devopsic://join?token=$token',
            size: 200,
          ),
        ),
        const SizedBox(height: 16),
        if (isDenied)
          const Text(
            'Your request was denied. Generate a new code or try an invite code instead.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.redAccent, fontSize: 12),
          )
        else if (isExpired)
          const Text(
            'This code expired. Generate a new one.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.orangeAccent, fontSize: 12),
          )
        else
          const Text(
            'Show this code to your commander. Waiting for approval...',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        const SizedBox(height: 16),
        if (!isDenied && !isExpired)
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () async {
            _pollTimer?.cancel();
            await appState.cancelJoinRequest();
          },
          child: Text(
            isDenied || isExpired ? 'Generate New Code' : 'Cancel',
            style: const TextStyle(color: Colors.blueGrey, fontSize: 12),
          ),
        ),
      ],
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
        automaticallyImplyLeading: false,
        title: const Text(
          'Join or Create a Team',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () => appState.logout(),
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  _buildTabButton('Create', 0),
                  const SizedBox(width: 8),
                  _buildTabButton('Join via Code', 1),
                  const SizedBox(width: 8),
                  _buildTabButton('Join via QR', 2),
                ],
              ),
              const SizedBox(height: 20),
              if (_errorMessage != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                  ),
                ),
              if (_selectedTab == 0) _buildCreateOrgView(appState),
              if (_selectedTab == 1) _buildJoinCodeView(appState),
              if (_selectedTab == 2) _buildJoinQrView(appState),
            ],
          ),
        ),
      ),
    );
  }
}

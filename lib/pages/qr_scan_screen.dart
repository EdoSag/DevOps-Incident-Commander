import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:devops_incident_commander_dashboard/globals/app_state.dart';

@NowaGenerated()
class QrScanScreen extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() {
    return _QrScanScreenState();
  }
}

@NowaGenerated()
class _QrScanScreenState extends State<QrScanScreen> {
  bool _isProcessing = false;

  String? _statusMessage;

  String? _extractToken(String raw) {
    final uri = Uri.tryParse(raw);
    if (uri == null) {
      return null;
    }
    return uri.queryParameters['token'];
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) {
      return;
    }
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) {
      return;
    }
    final raw = barcodes.first.rawValue;
    if (raw == null) {
      return;
    }
    final token = _extractToken(raw);
    if (token == null) {
      setState(() => _statusMessage = 'Unrecognized code. Try again.');
      return;
    }
    setState(() {
      _isProcessing = true;
      _statusMessage = null;
    });
    final appState = AppState.of(context, listen: false);
    try {
      await appState.lookupJoinRequest(token);
      if (!mounted) {
        return;
      }
      final request = appState.scannedJoinRequest;
      if (request == null) {
        return;
      }
      final approved = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF141724),
          title: const Text(
            'Confirm New Member',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Add ${request.requesterDisplayName ?? 'this person'} to the team as ${request.requestedRole.displayName}?',
            style: const TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Deny'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Approve'),
            ),
          ],
        ),
      );
      if (approved == true) {
        await appState.approveScannedJoinRequest();
        setState(() => _statusMessage = 'Member added successfully.');
      } else {
        await appState.denyScannedJoinRequest();
        setState(() => _statusMessage = 'Request denied.');
      }
    } catch (e) {
      setState(() => _statusMessage = e.toString().split(':').last.trim());
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F111A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141724),
        elevation: 0,
        title: const Text(
          'Scan Member QR Code',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: MobileScanner(onDetect: _onDetect)),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF141724),
            child: Text(
              _statusMessage ??
                  'Point the camera at the new member\'s join QR code.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

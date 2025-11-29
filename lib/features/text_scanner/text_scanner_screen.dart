import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class TextScannerScreen extends StatefulWidget {
  const TextScannerScreen({super.key});

  @override
  State<TextScannerScreen> createState() => _TextScannerScreenState();
}

class _TextScannerScreenState extends State<TextScannerScreen> {
  final MobileScannerController _cameraController = MobileScannerController();
  final TextRecognizer _textRecognizer = TextRecognizer();
  String _scannedText = '';
  bool _isProcessing = false;

  @override
  void dispose() {
    _cameraController.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  Future<void> _processImage() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    try {
      // Note: This is a simplified implementation
      // In a real app, you'd capture the camera frame and process it
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _scannedText =
            'Text recognition requires camera frame processing.\n\nThis is a placeholder implementation.';
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _scannedText = 'Error: $e';
        _isProcessing = false;
      });
    }
  }

  void _copyToClipboard() {
    if (_scannedText.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _scannedText));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Text copied to clipboard')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Scanner'),
        actions: [
          if (_scannedText.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: _copyToClipboard,
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                MobileScanner(
                  controller: _cameraController,
                  onDetect: (capture) {
                    // Camera preview
                  },
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: _isProcessing ? null : _processImage,
                      icon: _isProcessing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.camera),
                      label: Text(
                        _isProcessing ? 'Processing...' : 'Scan Text',
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              color: Colors.grey[100],
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Scanned Text:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_scannedText.isNotEmpty)
                        TextButton.icon(
                          onPressed: () {
                            setState(() => _scannedText = '');
                          },
                          icon: const Icon(Icons.clear),
                          label: const Text('Clear'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        _scannedText.isEmpty
                            ? 'Point camera at text and tap "Scan Text"'
                            : _scannedText,
                        style: TextStyle(
                          fontSize: 16,
                          color: _scannedText.isEmpty
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

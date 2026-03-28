import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import '../services/rrb_video_service.dart';
import 'rrb_results_screen.dart';

/// RRB Video Recording Screen
class RrbVideoRecordingScreen extends StatefulWidget {
  const RrbVideoRecordingScreen({super.key});

  @override
  State<RrbVideoRecordingScreen> createState() =>
      _RrbVideoRecordingScreenState();
}

class _RrbVideoRecordingScreenState extends State<RrbVideoRecordingScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isRecording = false;
  bool _isProcessing = false;
  String? _videoPath;
  XFile? _videoFile;
  final RrbVideoService _videoService = RrbVideoService();

  void _showMessage(String message, {Color color = Colors.blue}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    final cameraStatus = await Permission.camera.request();
    final micStatus = await Permission.microphone.request();

    if (cameraStatus.isDenied || micStatus.isDenied) {
      _showMessage(
        'Camera and microphone permissions are required',
        color: Colors.red,
      );
      if (mounted) Navigator.of(context).pop();
      return;
    }

    _cameras = await availableCameras();
    if (_cameras == null || _cameras!.isEmpty) {
      _showMessage('No camera found', color: Colors.red);
      if (mounted) Navigator.of(context).pop();
      return;
    }

    _cameraController = CameraController(
      _cameras![0],
      ResolutionPreset.high,
      enableAudio: true,
    );

    try {
      await _cameraController!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      _showMessage('Failed to initialize camera: $e', color: Colors.red);
    }
  }

  Future<void> _pickVideoWeb() async {
    try {
      final picker = ImagePicker();
      final XFile? video = await picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(minutes: 5),
      );

      if (video != null) {
        setState(() {
          _videoFile = video;
          _videoPath = video.name.isNotEmpty ? video.name : 'video.mp4';
          if (!_videoPath!.toLowerCase().endsWith('.mp4') &&
              !_videoPath!.toLowerCase().endsWith('.avi') &&
              !_videoPath!.toLowerCase().endsWith('.mov') &&
              !_videoPath!.toLowerCase().endsWith('.mkv')) {
            _videoPath = '$_videoPath.mp4';
          }
        });
        _showMessage('Video selected', color: Colors.green);
        _showProcessDialog();
      }
    } catch (e) {
      _showMessage('Failed to pick video: $e', color: Colors.red);
    }
  }

  Future<void> _startRecording() async {
    if (kIsWeb) {
      await _pickVideoWeb();
      return;
    }

    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      await _cameraController!.startVideoRecording();
      setState(() => _isRecording = true);
      _showMessage('Recording started', color: Colors.green);
    } catch (e) {
      _showMessage('Failed to start recording: $e', color: Colors.red);
    }
  }

  Future<void> _stopRecording() async {
    if (_cameraController == null ||
        !_cameraController!.value.isRecordingVideo) {
      return;
    }

    try {
      final video = await _cameraController!.stopVideoRecording();
      setState(() {
        _isRecording = false;
        _videoPath = video.path;
      });
      _showMessage('Recording stopped', color: Colors.blue);
      _showProcessDialog();
    } catch (e) {
      _showMessage('Failed to stop recording: $e', color: Colors.red);
    }
  }

  void _showProcessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Video Ready'),
        content: const Text(
          'Would you like to process this video for RRB detection?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() => _videoPath = null);
            },
            child: const Text('Discard'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _processVideo();
            },
            child: const Text('Process'),
          ),
        ],
      ),
    );
  }

  Future<void> _processVideo() async {
    if (_videoPath == null) return;

    setState(() => _isProcessing = true);

    try {
      final videoBytes = kIsWeb
          ? await _videoFile!.readAsBytes()
          : await File(_videoPath!).readAsBytes();

      final result = await _videoService.detectRRB(_videoPath!, videoBytes);

      if (!mounted) return;

      if (result['success'] == true) {
        _showMessage('Detection completed!', color: Colors.green);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => RrbResultsScreen(
              detectionResult: result['result'],
            ),
          ),
        );
      } else {
        _showMessage(result['error'] ?? 'Detection failed', color: Colors.red);
        setState(() => _isProcessing = false);
      }
    } catch (e) {
      _showMessage('Error: $e', color: Colors.red);
      setState(() => _isProcessing = false);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isProcessing) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Processing Video'),
          backgroundColor: const Color(0xFF0284C7),
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Analyzing video for RRB detection...'),
              SizedBox(height: 10),
              Text(
                'This may take a few moments',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Record Video'),
          backgroundColor: const Color(0xFF0284C7),
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.videocam, size: 100, color: Colors.blue),
              const SizedBox(height: 30),
              const Text(
                'Click the button below to record or upload a video',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Your browser will ask for camera permission',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _pickVideoWeb,
                icon: const Icon(Icons.videocam, size: 30),
                label: const Text(
                  'Record Video',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Mobile/Desktop: camera preview
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Record Video'),
          backgroundColor: const Color(0xFF0284C7),
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Video'),
        backgroundColor: const Color(0xFF0284C7),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(child: CameraPreview(_cameraController!)),
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.black87,
            child: Column(
              children: [
                if (_isRecording)
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.fiber_manual_record, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        'Recording...',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                FloatingActionButton(
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                  backgroundColor: _isRecording ? Colors.red : Colors.blue,
                  child: Icon(_isRecording ? Icons.stop : Icons.videocam),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


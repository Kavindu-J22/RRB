import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/video_service.dart';
import 'results_screen.dart';

/// Video Recording Screen
class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isRecording = false;
  bool _isProcessing = false;
  String? _videoPath;
  XFile? _videoFile; // Store XFile for web
  final VideoService _videoService = VideoService();

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    // Request permissions
    final cameraStatus = await Permission.camera.request();
    final microphoneStatus = await Permission.microphone.request();

    if (cameraStatus.isDenied || microphoneStatus.isDenied) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Camera and microphone permissions are required',
          backgroundColor: Colors.red,
        );
        Navigator.of(context).pop();
      }
      return;
    }

    // Get available cameras
    _cameras = await availableCameras();

    if (_cameras == null || _cameras!.isEmpty) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'No camera found',
          backgroundColor: Colors.red,
        );
        Navigator.of(context).pop();
      }
      return;
    }

    // Initialize camera controller
    _cameraController = CameraController(
      _cameras![0],
      ResolutionPreset.high,
      enableAudio: true,
    );

    try {
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Failed to initialize camera: $e',
          backgroundColor: Colors.red,
        );
      }
    }
  }

  // Upload video from gallery/files
  Future<void> _uploadVideo() async {
    try {
      final ImagePicker picker = ImagePicker();

      // Pick video from gallery using image_picker (same as record flow)
      final XFile? video = await picker.pickVideo(source: ImageSource.gallery);

      if (video != null) {
        // Check file size (max 100MB)
        final fileSize = await video.length();
        if (fileSize > 100 * 1024 * 1024) {
          Fluttertoast.showToast(
            msg: 'Video file is too large. Maximum size is 100MB',
            backgroundColor: Colors.red,
          );
          return;
        }

        setState(() {
          _videoFile = video;
          // On web, video.path might be empty, so use video.name instead
          if (kIsWeb) {
            _videoPath = video.name.isNotEmpty ? video.name : 'video.mp4';
            // Ensure it has .mp4 extension
            if (!_videoPath!.toLowerCase().endsWith('.mp4') &&
                !_videoPath!.toLowerCase().endsWith('.avi') &&
                !_videoPath!.toLowerCase().endsWith('.mov') &&
                !_videoPath!.toLowerCase().endsWith('.mkv')) {
              _videoPath = '$_videoPath.mp4';
            }
          } else {
            _videoPath = video.path;
          }
        });

        Fluttertoast.showToast(
          msg: 'Video selected: ${video.name}',
          backgroundColor: Colors.green,
        );

        // Show process dialog
        _showProcessDialog();
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to select video: $e',
        backgroundColor: Colors.red,
      );
    }
  }

  // Web: Pick video using image_picker
  Future<void> _pickVideoWeb() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(minutes: 5),
      );

      if (video != null) {
        setState(() {
          _videoFile = video;
          // Use video.name if available, otherwise create a default name
          _videoPath = video.name.isNotEmpty ? video.name : 'video.mp4';
          // Ensure it has .mp4 extension
          if (!_videoPath!.toLowerCase().endsWith('.mp4') &&
              !_videoPath!.toLowerCase().endsWith('.avi') &&
              !_videoPath!.toLowerCase().endsWith('.mov') &&
              !_videoPath!.toLowerCase().endsWith('.mkv')) {
            _videoPath = '$_videoPath.mp4';
          }
        });

        Fluttertoast.showToast(
          msg: 'Video selected',
          backgroundColor: Colors.green,
        );

        // Show process dialog
        _showProcessDialog();
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to pick video: $e',
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _startRecording() async {
    // On web, use image picker instead
    if (kIsWeb) {
      await _pickVideoWeb();
      return;
    }

    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      await _cameraController!.startVideoRecording();
      setState(() {
        _isRecording = true;
      });

      Fluttertoast.showToast(
        msg: 'Recording started',
        backgroundColor: Colors.green,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to start recording: $e',
        backgroundColor: Colors.red,
      );
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
        _videoFile = video;
        _videoPath = video.path;
      });

      Fluttertoast.showToast(
        msg: 'Recording stopped',
        backgroundColor: Colors.blue,
      );

      // Show process dialog
      _showProcessDialog();
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to stop recording: $e',
        backgroundColor: Colors.red,
      );
    }
  }

  void _showProcessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Video Recorded'),
        content: const Text(
          'Would you like to process this video for RRB detection?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _videoPath = null;
              });
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

    setState(() {
      _isProcessing = true;
    });

    try {
      // Read video bytes (works on both web and mobile)
      late final Uint8List videoBytes;

      // Check if we have XFile (from camera recording on web or mobile)
      if (_videoFile != null) {
        // Use XFile for web camera recording or image_picker
        videoBytes = await _videoFile!.readAsBytes();
      } else if (_videoPath != null) {
        // Use file path for mobile file picker or camera recording
        final bytes = await File(_videoPath!).readAsBytes();
        videoBytes = Uint8List.fromList(bytes);
      } else {
        throw Exception('No video file available');
      }

      final result = await _videoService.detectRRB(_videoPath!, videoBytes);

      if (!mounted) return;

      if (result['success'] == true) {
        Fluttertoast.showToast(
          msg: 'Detection completed!',
          backgroundColor: Colors.green,
        );

        // Navigate to results screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                ResultsScreen(detectionResult: result['result']),
          ),
        );
      } else {
        Fluttertoast.showToast(
          msg: result['error'] ?? 'Detection failed',
          backgroundColor: Colors.red,
        );
        setState(() {
          _isProcessing = false;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e', backgroundColor: Colors.red);
      setState(() {
        _isProcessing = false;
      });
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
        appBar: AppBar(title: const Text('Processing Video')),
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

    // Web: Show simple buttons to pick or upload video
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(title: const Text('RRB Detection')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.videocam, size: 100, color: Colors.blue),
              const SizedBox(height: 30),
              const Text(
                'Choose an option to get started',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Record a new video or upload an existing one',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Upload Video Button
                  ElevatedButton.icon(
                    onPressed: _uploadVideo,
                    icon: const Icon(Icons.upload_file, size: 30),
                    label: const Text(
                      'Upload Video',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Record Video Button
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
            ],
          ),
        ),
      );
    }

    // Mobile/Desktop: Show camera preview
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(title: const Text('Record Video')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Record Video')),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Upload Video Button
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FloatingActionButton(
                          onPressed: _uploadVideo,
                          backgroundColor: Colors.green,
                          heroTag: 'upload',
                          child: const Icon(Icons.upload_file),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Upload',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                    // Record Video Button
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FloatingActionButton(
                          onPressed: _isRecording
                              ? _stopRecording
                              : _startRecording,
                          backgroundColor: _isRecording
                              ? Colors.red
                              : Colors.blue,
                          heroTag: 'record',
                          child: Icon(
                            _isRecording ? Icons.stop : Icons.videocam,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isRecording ? 'Stop' : 'Record',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

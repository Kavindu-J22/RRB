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
    // ── Processing State ──────────────────────────────────────────────────────
    if (_isProcessing) {
      return Scaffold(
        backgroundColor: const Color(0xFFF4F6FB),
        appBar: AppBar(
          title: const Text(
            'Analyzing Video',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF1A237E),
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A237E), Color(0xFF1976D2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1976D2).withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'AI Analysis in Progress',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Our deep learning model is analyzing every frame of your video to identify behavioral patterns. This may take a few moments.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF546E7A),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF90CAF9)),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Color(0xFF1976D2),
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Please do not close the app during analysis.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // ── Web View ──────────────────────────────────────────────────────────────
    if (kIsWeb) {
      return Scaffold(
        backgroundColor: const Color(0xFFF4F6FB),
        appBar: AppBar(
          title: const Text(
            'Video Capture',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF1A237E),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1A237E), Color(0xFF1976D2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.video_library_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Provide a Clinical Video',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Upload an existing recording or capture a new one using your camera.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Instructions Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFFE082)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.checklist_rounded,
                          color: Color(0xFFF9A825),
                          size: 22,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Video Requirements & Guidelines',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.5,
                            color: Color(0xFF6D4C0E),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ..._buildRequirementRows(),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Options Label
              const Text(
                'Choose Your Option',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A237E),
                ),
              ),
              const SizedBox(height: 14),

              // Upload Video Card
              _VideoOptionCard(
                icon: Icons.upload_file_rounded,
                title: 'Upload Existing Video',
                subtitle:
                    'Select a pre-recorded clinical observation video from your device storage.',
                badgeText: 'RECOMMENDED',
                badgeColor: const Color(0xFF2E7D32),
                gradientColors: const [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                features: const [
                  'MP4, AVI, MOV, MKV formats accepted',
                  'Maximum file size: 100 MB',
                  'Ensure clear visibility of the subject',
                ],
                onTap: _uploadVideo,
              ),
              const SizedBox(height: 16),

              // Record Video Card
              _VideoOptionCard(
                icon: Icons.videocam_rounded,
                title: 'Record New Video',
                subtitle:
                    'Use your device camera to record a live clinical observation session.',
                badgeText: 'LIVE',
                badgeColor: const Color(0xFF1565C0),
                gradientColors: const [Color(0xFF1565C0), Color(0xFF42A5F5)],
                features: const [
                  'Maximum recording duration: 5 minutes',
                  'Hold device steady for best results',
                  'Ensure good lighting conditions',
                ],
                onTap: _pickVideoWeb,
              ),
              const SizedBox(height: 24),

              // Best Practices
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFA5D6A7)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.tips_and_updates_rounded,
                          color: Color(0xFF2E7D32),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Best Practices for Accurate Detection',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                            color: Color(0xFF1B5E20),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ..._buildTipRows([
                      'Ensure the child\'s full body is visible in the frame',
                      'Use a stable camera position or tripod',
                      'Record in a well-lit, distraction-free environment',
                      'Avoid sudden camera movements during recording',
                      'The child should be the primary subject in the video',
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      );
    }

    // ── Mobile: Camera Initializing ───────────────────────────────────────────
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Scaffold(
        backgroundColor: const Color(0xFFF4F6FB),
        appBar: AppBar(
          title: const Text(
            'Record Video',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF1A237E),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF1976D2)),
              SizedBox(height: 16),
              Text(
                'Initializing Camera...',
                style: TextStyle(color: Color(0xFF546E7A)),
              ),
            ],
          ),
        ),
      );
    }

    // ── Mobile: Camera Preview ────────────────────────────────────────────────
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Record Video',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Camera Preview
          Positioned.fill(child: CameraPreview(_cameraController!)),

          // Recording Indicator
          if (_isRecording)
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.fiber_manual_record,
                        color: Colors.red,
                        size: 14,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'REC  ·  Max 5:00 min',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Bottom Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.9),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  // Instruction line
                  if (!_isRecording)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text(
                        'Min: 10 sec  ·  Max: 5 min  ·  Keep camera steady',
                        style: TextStyle(color: Colors.white60, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Upload Button
                      _CameraButton(
                        icon: Icons.upload_file_rounded,
                        label: 'Upload',
                        color: const Color(0xFF2E7D32),
                        onTap: _uploadVideo,
                        heroTag: 'upload',
                      ),
                      // Record Button (large center)
                      GestureDetector(
                        onTap: _isRecording ? _stopRecording : _startRecording,
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isRecording
                                ? Colors.red
                                : const Color(0xFF1976D2),
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    (_isRecording
                                            ? Colors.red
                                            : const Color(0xFF1976D2))
                                        .withValues(alpha: 0.5),
                                blurRadius: 14,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            _isRecording
                                ? Icons.stop_rounded
                                : Icons.videocam_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                      // Placeholder for symmetry
                      const SizedBox(width: 60),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRequirementRows() {
    final items = [
      ('timer', 'Minimum Duration', '10 seconds'),
      ('hourglass_top', 'Maximum Duration', '5 minutes'),
      ('folder', 'Accepted Formats', 'MP4, AVI, MOV, MKV'),
      ('storage', 'Maximum File Size', '100 MB'),
      ('hd', 'Recommended Quality', '720p or higher at 30 FPS'),
    ];
    return items.map((item) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Color(0xFFF9A825),
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4E342E),
                  ),
                  children: [
                    TextSpan(
                      text: '${item.$2}: ',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(text: item.$3),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildTipRows(List<String> tips) {
    return tips
        .map(
          (tip) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '•  ',
                  style: TextStyle(color: Color(0xFF2E7D32), fontSize: 14),
                ),
                Expanded(
                  child: Text(
                    tip,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF2E4A2E),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }
}

// ── Helper Widgets ────────────────────────────────────────────────────────────

class _VideoOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String badgeText;
  final Color badgeColor;
  final List<Color> gradientColors;
  final List<String> features;
  final VoidCallback onTap;

  const _VideoOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.badgeColor,
    required this.gradientColors,
    required this.features,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
      elevation: 2,
      shadowColor: gradientColors.first.withValues(alpha: 0.2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A237E),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: badgeColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                badgeText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF78909C),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 12),
              ...features.map(
                (f) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: gradientColors.first,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          f,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF455A64),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title.contains('Upload')
                            ? 'Choose File'
                            : 'Open Camera',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CameraButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final String heroTag;

  const _CameraButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

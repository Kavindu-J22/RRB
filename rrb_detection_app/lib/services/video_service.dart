import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'dart:convert';
import '../config/app_config.dart';
import '../models/detection_result_model.dart';
import 'auth_service.dart';

/// Video Service for uploading and processing videos
class VideoService {
  final AuthService _authService = AuthService();

  /// Upload video to backend
  Future<Map<String, dynamic>> uploadVideo(File videoFile) async {
    try {
      final token = await _authService.getToken();
      
      if (token == null) {
        return {
          'success': false,
          'error': 'Not authenticated',
        };
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConfig.apiBaseUrl}${AppConfig.uploadVideoEndpoint}'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      
      // Add video file
      request.files.add(
        await http.MultipartFile.fromPath(
          'video',
          videoFile.path,
          filename: path.basename(videoFile.path),
        ),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'videoId': data['videoId'] ?? data['id'],
          'message': 'Video uploaded successfully',
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'error': error['message'] ?? 'Upload failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Upload error: ${e.toString()}',
      };
    }
  }

  /// Detect RRB in video
  Future<Map<String, dynamic>> detectRRB(File videoFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConfig.mlServiceUrl}${AppConfig.detectRRBEndpoint}'),
      );

      // Add video file
      request.files.add(
        await http.MultipartFile.fromPath(
          'video',
          videoFile.path,
          filename: path.basename(videoFile.path),
        ),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true) {
          return {
            'success': true,
            'result': DetectionResult.fromJson(data),
          };
        } else {
          return {
            'success': false,
            'error': data['error'] ?? 'Detection failed',
          };
        }
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'error': error['error'] ?? 'Detection failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Detection error: ${e.toString()}',
      };
    }
  }

  /// Get detection results
  Future<Map<String, dynamic>> getResults(String videoId) async {
    try {
      final headers = await _authService.getAuthHeaders();
      
      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}${AppConfig.getResultsEndpoint}/$videoId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'result': DetectionResult.fromJson(data),
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'error': error['message'] ?? 'Failed to get results',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error: ${e.toString()}',
      };
    }
  }
}


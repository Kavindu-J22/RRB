/// RRB Module Configuration
class RrbConfig {
  // ML Service URL (Flask server on port 5000)
  static const String mlServiceUrl = 'http://localhost:5000/api/v1';

  // API Endpoints
  static const String detectRRBEndpoint = '/detect';

  // Video Configuration
  static const int maxVideoDurationSeconds = 300; // 5 minutes
  static const int minVideoDurationSeconds = 10; // 10 seconds

  // Detection Configuration
  static const double confidenceThreshold = 0.70;
  static const double minDetectionDuration = 3.0; // seconds

  // RRB Categories
  static const List<String> rrbCategories = [
    'Hand Flapping',
    'Head Banging',
    'Head Nodding',
    'Spinning',
    'Atypical Hand Movements',
    'Normal',
  ];

  // Colors for each category
  static const Map<String, int> categoryColors = {
    'Hand Flapping': 0xFFE74C3C,
    'Head Banging': 0xFFE67E22,
    'Head Nodding': 0xFFF39C12,
    'Spinning': 0xFF9B59B6,
    'Atypical Hand Movements': 0xFF3498DB,
    'Normal': 0xFF2ECC71,
  };
}


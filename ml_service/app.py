import os
os.environ['TF_USE_LEGACY_KERAS'] = '1'  # Use tf-keras instead of keras 3.x

from flask import Flask, request, jsonify
from flask_cors import CORS
from werkzeug.utils import secure_filename
import uuid
from datetime import datetime
import traceback

from config import Config
from utils.inference import RRBInference

# Initialize Flask app
app = Flask(__name__)
CORS(app)

# Load configuration
app.config.from_object(Config)
Config.init_app(app)

# Initialize inference engine (lazy loading)
inference_engine = None

def get_inference_engine():
    """Get or initialize inference engine"""
    global inference_engine
    
    if inference_engine is None:
        model_path = Config.MODEL_PATH
        label_encoder_path = Config.LABEL_ENCODER_PATH
        
        if not os.path.exists(model_path):
            raise FileNotFoundError(f"Model not found at {model_path}")
        
        if not os.path.exists(label_encoder_path):
            raise FileNotFoundError(f"Label encoder not found at {label_encoder_path}")
        
        inference_engine = RRBInference(
            model_path=model_path,
            label_encoder_path=label_encoder_path,
            sequence_length=Config.SEQUENCE_LENGTH,
            img_size=Config.IMG_SIZE,
            confidence_threshold=Config.CONFIDENCE_THRESHOLD,
            min_duration=Config.MIN_DETECTION_DURATION
        )
    
    return inference_engine

def allowed_file(filename):
    """Check if file extension is allowed"""
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in Config.ALLOWED_EXTENSIONS

@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    return jsonify({
        'status': 'healthy',
        'service': 'RRB Detection ML Service',
        'timestamp': datetime.now().isoformat()
    })

@app.route('/api/v1/detect', methods=['POST'])
def detect_rrb():
    """
    Main RRB detection endpoint
    
    Expected: multipart/form-data with 'video' file
    Returns: JSON with detection results
    """
    try:
        # Check if video file is present
        if 'video' not in request.files:
            return jsonify({
                'success': False,
                'error': 'No video file provided'
            }), 400
        
        file = request.files['video']
        
        # Check if file is selected
        if file.filename == '':
            return jsonify({
                'success': False,
                'error': 'No file selected'
            }), 400
        
        # Check file extension
        if not allowed_file(file.filename):
            return jsonify({
                'success': False,
                'error': f'Invalid file type. Allowed types: {Config.ALLOWED_EXTENSIONS}'
            }), 400
        
        # Save uploaded file
        filename = secure_filename(file.filename)
        unique_filename = f"{uuid.uuid4()}_{filename}"
        upload_path = os.path.join(Config.UPLOAD_FOLDER, unique_filename)
        file.save(upload_path)
        
        # Get inference engine
        engine = get_inference_engine()
        
        # Perform detection
        result = engine.detect_rrb(upload_path)
        
        # Clean up uploaded file
        if os.path.exists(upload_path):
            os.remove(upload_path)
        
        # Format response
        response = {
            'success': True,
            'timestamp': datetime.now().isoformat(),
            'filename': filename,
            'detection': {
                'detected': result['detected'],
                'primary_behavior': result['primary_behavior'],
                'confidence': result['confidence'],
                'behaviors': result['behaviors']
            },
            'metadata': {
                'video_duration': result['video_info'].get('duration', 0),
                'video_fps': result['video_info'].get('fps', 0),
                'sequences_analyzed': result.get('total_sequences_analyzed', 0),
                'sequences_with_detections': result.get('sequences_with_detections', 0)
            }
        }
        
        return jsonify(response), 200
        
    except Exception as e:
        # Clean up file if exists
        if 'upload_path' in locals() and os.path.exists(upload_path):
            os.remove(upload_path)
        
        return jsonify({
            'success': False,
            'error': str(e),
            'traceback': traceback.format_exc()
        }), 500

@app.route('/api/v1/detect/enhanced', methods=['POST'])
def detect_rrb_enhanced():
    """
    Enhanced RRB detection with pose analysis
    
    Expected: multipart/form-data with 'video' file
    Returns: JSON with detection results including pose features
    """
    try:
        # Check if video file is present
        if 'video' not in request.files:
            return jsonify({
                'success': False,
                'error': 'No video file provided'
            }), 400
        
        file = request.files['video']
        
        if file.filename == '' or not allowed_file(file.filename):
            return jsonify({
                'success': False,
                'error': 'Invalid file'
            }), 400
        
        # Save uploaded file
        filename = secure_filename(file.filename)
        unique_filename = f"{uuid.uuid4()}_{filename}"
        upload_path = os.path.join(Config.UPLOAD_FOLDER, unique_filename)
        file.save(upload_path)
        
        # Get inference engine
        engine = get_inference_engine()
        
        # Perform enhanced detection
        result = engine.detect_with_pose_analysis(upload_path)
        
        # Clean up
        if os.path.exists(upload_path):
            os.remove(upload_path)
        
        # Format response
        response = {
            'success': True,
            'timestamp': datetime.now().isoformat(),
            'filename': filename,
            'detection': {
                'detected': result['detected'],
                'primary_behavior': result['primary_behavior'],
                'confidence': result['confidence'],
                'behaviors': result['behaviors']
            },
            'pose_analysis': result.get('pose_analysis', {}),
            'metadata': {
                'video_duration': result.get('video_info', {}).get('duration', 0),
                'video_fps': result.get('video_info', {}).get('fps', 0),
                'sequences_analyzed': result.get('total_sequences_analyzed', 0)
            }
        }
        
        return jsonify(response), 200
        
    except Exception as e:
        if 'upload_path' in locals() and os.path.exists(upload_path):
            os.remove(upload_path)
        
        return jsonify({
            'success': False,
            'error': str(e),
            'traceback': traceback.format_exc()
        }), 500

@app.route('/api/v1/model/info', methods=['GET'])
def model_info():
    """Get model information"""
    try:
        engine = get_inference_engine()
        
        return jsonify({
            'success': True,
            'model_info': {
                'classes': engine.label_encoder.classes_.tolist(),
                'num_classes': len(engine.label_encoder.classes_),
                'sequence_length': engine.sequence_length,
                'image_size': engine.img_size,
                'confidence_threshold': engine.confidence_threshold,
                'min_duration': engine.min_duration
            }
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@app.route('/api/v1/categories', methods=['GET'])
def get_categories():
    """Get list of RRB categories"""
    return jsonify({
        'success': True,
        'categories': Config.RRB_CATEGORIES,
        'descriptions': {
            'hand_flapping': 'Repetitive hand or arm movements',
            'head_banging': 'Repetitive head hitting or banging movements',
            'head_nodding': 'Repetitive head nodding movements',
            'spinning': 'Repetitive spinning or rotating movements',
            'atypical_hand_movements': 'Other atypical hand movements',
            'normal': 'No restricted or repetitive behaviors detected'
        }
    }), 200

@app.errorhandler(413)
def request_entity_too_large(error):
    """Handle file too large error"""
    return jsonify({
        'success': False,
        'error': 'File too large. Maximum size is 100MB'
    }), 413

@app.errorhandler(404)
def not_found(error):
    """Handle 404 errors"""
    return jsonify({
        'success': False,
        'error': 'Endpoint not found'
    }), 404

@app.errorhandler(500)
def internal_error(error):
    """Handle 500 errors"""
    return jsonify({
        'success': False,
        'error': 'Internal server error'
    }), 500

if __name__ == '__main__':
    print("=" * 80)
    print("RRB Detection ML Service")
    print("=" * 80)
    print(f"Starting server on port {Config.PORT}...")
    print(f"Debug mode: {Config.DEBUG}")
    print(f"Model path: {Config.MODEL_PATH}")
    print(f"Confidence threshold: {Config.CONFIDENCE_THRESHOLD}")
    print(f"Min detection duration: {Config.MIN_DETECTION_DURATION}s")
    print("=" * 80)
    
    app.run(
        host='0.0.0.0',
        port=Config.PORT,
        debug=Config.DEBUG
    )


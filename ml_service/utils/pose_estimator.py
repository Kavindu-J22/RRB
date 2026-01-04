import cv2
import mediapipe as mp
import numpy as np
from typing import List, Dict, Tuple, Optional
import logging
import traceback

logger = logging.getLogger(__name__)

class PoseEstimator:
    """Pose estimation using MediaPipe for RRB detection"""
    
    def __init__(self, min_detection_confidence=0.5, min_tracking_confidence=0.5):
        """
        Initialize MediaPipe Pose estimator
        
        Args:
            min_detection_confidence: Minimum confidence for pose detection
            min_tracking_confidence: Minimum confidence for pose tracking
        """
        self.mp_pose = mp.solutions.pose
        self.mp_drawing = mp.solutions.drawing_utils
        self.pose = self.mp_pose.Pose(
            min_detection_confidence=min_detection_confidence,
            min_tracking_confidence=min_tracking_confidence,
            model_complexity=2,
            enable_segmentation=False,
            smooth_landmarks=True
        )
        
        # Key landmarks for RRB detection
        self.key_landmarks = {
            'nose': 0,
            'left_eye': 2,
            'right_eye': 5,
            'left_ear': 7,
            'right_ear': 8,
            'left_shoulder': 11,
            'right_shoulder': 12,
            'left_elbow': 13,
            'right_elbow': 14,
            'left_wrist': 15,
            'right_wrist': 16,
            'left_hip': 23,
            'right_hip': 24,
            'left_knee': 25,
            'right_knee': 26,
            'left_ankle': 27,
            'right_ankle': 28
        }
    
    def extract_landmarks(self, frame: np.ndarray) -> Optional[np.ndarray]:
        """
        Extract pose landmarks from a single frame

        Args:
            frame: Input video frame (BGR format)

        Returns:
            Array of normalized landmarks [x, y, z, visibility] or None if no pose detected
        """
        try:
            # Validate frame
            if frame is None or frame.size == 0:
                return None

            # Convert BGR to RGB
            frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

            # Process the frame
            results = self.pose.process(frame_rgb)

            if results.pose_landmarks:
                # Extract landmarks as numpy array
                landmarks = []
                for landmark in results.pose_landmarks.landmark:
                    landmarks.extend([landmark.x, landmark.y, landmark.z, landmark.visibility])
                return np.array(landmarks)

            return None

        except Exception as e:
            logger.warning(f"Error extracting landmarks: {str(e)}")
            return None
    
    def extract_key_landmarks(self, frame: np.ndarray) -> Optional[Dict[str, np.ndarray]]:
        """
        Extract only key landmarks relevant for RRB detection
        
        Args:
            frame: Input video frame
            
        Returns:
            Dictionary of key landmarks with their coordinates
        """
        frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        results = self.pose.process(frame_rgb)
        
        if results.pose_landmarks:
            key_points = {}
            for name, idx in self.key_landmarks.items():
                landmark = results.pose_landmarks.landmark[idx]
                key_points[name] = np.array([landmark.x, landmark.y, landmark.z, landmark.visibility])
            return key_points
        
        return None
    
    def process_video(self, video_path: str, max_frames: Optional[int] = None) -> Tuple[List[np.ndarray], int]:
        """
        Process entire video and extract landmarks from all frames

        Args:
            video_path: Path to video file
            max_frames: Maximum number of frames to process (None for all)

        Returns:
            Tuple of (list of landmark arrays, fps of video)
        """
        cap = None
        try:
            cap = cv2.VideoCapture(video_path)

            if not cap.isOpened():
                logger.error(f"Cannot open video for pose estimation: {video_path}")
                return [], 30  # Return empty with default FPS

            fps = int(cap.get(cv2.CAP_PROP_FPS))
            if fps <= 0:
                logger.warning(f"Invalid FPS ({fps}), using default 30")
                fps = 30

            landmarks_sequence = []
            frame_count = 0
            consecutive_failures = 0
            max_consecutive_failures = 10

            while cap.isOpened():
                ret, frame = cap.read()

                if not ret:
                    consecutive_failures += 1
                    if consecutive_failures >= max_consecutive_failures:
                        break
                    continue

                consecutive_failures = 0

                if frame is None or frame.size == 0:
                    logger.warning(f"Empty frame at index {frame_count}")
                    landmarks_sequence.append(np.zeros(132))
                    frame_count += 1
                    continue

                try:
                    landmarks = self.extract_landmarks(frame)
                    if landmarks is not None:
                        landmarks_sequence.append(landmarks)
                    else:
                        # If no pose detected, use zeros (will be handled in preprocessing)
                        landmarks_sequence.append(np.zeros(132))  # 33 landmarks * 4 values
                except Exception as e:
                    logger.warning(f"Error extracting landmarks from frame {frame_count}: {str(e)}")
                    landmarks_sequence.append(np.zeros(132))

                frame_count += 1
                if max_frames and frame_count >= max_frames:
                    break

            if len(landmarks_sequence) == 0:
                logger.warning("No landmarks extracted from video")

            return landmarks_sequence, fps

        except Exception as e:
            logger.error(f"Error processing video for pose estimation: {str(e)}")
            logger.error(traceback.format_exc())
            return [], 30  # Return empty with default FPS

        finally:
            # Always release video capture
            if cap is not None:
                cap.release()
    
    def draw_landmarks(self, frame: np.ndarray, landmarks) -> np.ndarray:
        """
        Draw pose landmarks on frame for visualization
        
        Args:
            frame: Input frame
            landmarks: MediaPipe landmarks
            
        Returns:
            Frame with drawn landmarks
        """
        annotated_frame = frame.copy()
        self.mp_drawing.draw_landmarks(
            annotated_frame,
            landmarks,
            self.mp_pose.POSE_CONNECTIONS,
            self.mp_drawing.DrawingSpec(color=(245, 117, 66), thickness=2, circle_radius=2),
            self.mp_drawing.DrawingSpec(color=(245, 66, 230), thickness=2, circle_radius=2)
        )
        return annotated_frame
    
    def __del__(self):
        """Cleanup resources"""
        if hasattr(self, 'pose'):
            self.pose.close()


module.exports = {
  subdomain: 'system',
  accessTokenCookieKey: 'access_token.robotics',
  vision: {
    streamingPort: 3001,
    camera: {
      cameraCalibrator: {
        program: ['python3', '/app/object-tracker-python/object_tracker/objtracking_entry.py', 'CAMERACALIB']
      },
      handEyeCalibrator: {
        program: ['python3', '/app/object-tracker-python/object_tracker/objtracking_entry.py', 'HANDEYECALIB']
      },
      ROIDetector: {
        program: ['python3', '/app/object-tracker-python/object_tracker/roi_engine.py']
      }
    },
    robotArm: {
      markerOffsetCalibrator: {
        program: ['python3', '/app/object-tracker-python/object_tracker/objecttracking_engine.py']
      }
    },
    objectTracker: {
      program: ['python3', '/app/object-tracker-python/object_tracker/objtracking_entry.py', 'OBJTRACKING']
    }
  }
}

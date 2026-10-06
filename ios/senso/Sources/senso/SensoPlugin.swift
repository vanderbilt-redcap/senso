import Flutter
import UIKit
import CoreMotion

public class SensoPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "senso", binaryMessenger: registrar.messenger())
    let instance = SensoPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    let gravityChannel = FlutterEventChannel(name: "np.com.satkardhakal/senso/gravity", binaryMessenger: registrar.messenger())                                                                            
    let deviceRotChannel = FlutterEventChannel(name: "np.com.satkardhakal/senso/rotation", binaryMessenger: registrar.messenger())                                                                            
    gravityChannel.setStreamHandler(GravityStreamHandler())   
    deviceRotChannel.setStreamHandler(DeviceRotStreamHandler())   
  }
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}

class GravityStreamHandler: NSObject, FlutterStreamHandler {                                                                                                                                  
  let GRAVITY = 9.81;
  let motionManager = CMMotionManager()

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {                                                                     
      if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: OperationQueue()) { (data, error) in
              if let gravityData = data?.gravity {
                // Send gravity data to a callback function
                self.gravityCallback(gravityData,events)
              }
            }
          }
        return nil                                                                                                                                                                           
    }                                                                                                                                                                                        
  func onCancel(withArguments arguments: Any?) -> FlutterError? {
        motionManager.stopDeviceMotionUpdates()
        return nil
    }
  func gravityCallback(_ data: CMAcceleration, _ sink:FlutterEventSink) {
    // making the data consistent with android
    sink([-data.x * GRAVITY , -data.y * GRAVITY, -data.z * GRAVITY])
  }
}    
class DeviceRotStreamHandler: NSObject, FlutterStreamHandler {                                                                                                                                  
  let motionManager = CMMotionManager()

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {                                                                     
      if motionManager.isDeviceMotionAvailable {
            // Simulating SENSOR_DELAY_NORMAL iterval of the android which approximates to 250ms.
            motionManager.deviceMotionUpdateInterval = 0.25
            motionManager.startDeviceMotionUpdates(using : CMAttitudeReferenceFrame.xMagneticNorthZVertical, to: OperationQueue()) { (data, error) in
              if let attData = data?.attitude {
                // Send gravity data to a callback function
                self.callback(attData,events)
              }
            }
          }
        return nil                                                                                                                                                                           
    }                                                                                                                                                                                        
  func onCancel(withArguments arguments: Any?) -> FlutterError? {
        motionManager.stopDeviceMotionUpdates()
        return nil
    }
  func callback(_ data: CMAttitude, _ sink:FlutterEventSink) {
    sink([data.roll,data.pitch,data.yaw,data.quaternion.x,data.quaternion.y,data.quaternion.z,data.quaternion.w] as [Double] )
  }
}    


import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Plugins are registered in `SceneDelegate` once `FlutterViewController` exists.
    // With UIScene, `register(with: self)` here can crash (nil registrar / engine not ready).
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

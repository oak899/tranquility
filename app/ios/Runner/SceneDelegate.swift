import Flutter
import UIKit

/// UIScene-based window setup (Apple requires scene lifecycle for current SDKs).
/// Loads the same `Main` storyboard used by the Flutter template.
///
/// Do not set `UIMainStoryboardFile` when using this delegate: two storyboard paths
/// can race and break the engine. Register plugins after the root VC exists, on the
/// next run loop tick, once (scene can reconnect).
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  private static var didRegisterPlugins = false

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = scene as? UIWindowScene else { return }
    let window = UIWindow(windowScene: windowScene)
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    window.rootViewController = storyboard.instantiateInitialViewController()
    window.makeKeyAndVisible()
    self.window = window

    DispatchQueue.main.async { [weak self] in
      guard let self = self, !Self.didRegisterPlugins else { return }
      guard let controller = self.window?.rootViewController as? FlutterViewController else { return }
      GeneratedPluginRegistrant.register(with: controller)
      Self.didRegisterPlugins = true
    }
  }
}

import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {

  override func applicationDidFinishLaunching(_ notification: Notification) {

    // Get FlutterViewController
    let controller =
      mainFlutterWindow?.contentViewController as! FlutterViewController

    // MethodChannel for splash control
    let splashChannel = FlutterMethodChannel(
      name: "app/splash",
      binaryMessenger: controller.engine.binaryMessenger
    )

    splashChannel.setMethodCallHandler { call, result in
      if call.method == "closeSplash" {
        // SplashWindow.close()
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    super.applicationDidFinishLaunching(notification)
  }

  override func applicationShouldTerminateAfterLastWindowClosed(
    _ sender: NSApplication
  ) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(
    _ app: NSApplication
  ) -> Bool {
    return true
  }
}
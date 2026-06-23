import Flutter
import UIKit
import Firebase


@UIApplicationMain

@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
//     if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") {
//     print("FOUND: \(path)")
// } else {
//     print("PLIST NOT FOUND")
// }
 if let filePath = Bundle.main.path(
      forResource: "GoogleService-Info",
      ofType: "plist"
    ) {

      print("FOUND: \(filePath)")

      if let options = FirebaseOptions(contentsOfFile: filePath) {
        FirebaseApp.configure(options: options)
      }

    } else {

      print("PLIST NOT FOUND")
    }


    //  FirebaseApp.configure()

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

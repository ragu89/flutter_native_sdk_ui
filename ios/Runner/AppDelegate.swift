import UIKit
import Flutter
import PhotoEditorSDK

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            if let licenseURL = Bundle.main.url(forResource: "license", withExtension: "dms") {
               PESDK.unlockWithLicense(at: licenseURL)
            }
        return true
    }
    
    override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        NSLog("### AppDelegate")
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let photoEditorChannel = FlutterMethodChannel(name: "ch.ragu.flutter_native_sdk/photoEditorChannel",
                                                    binaryMessenger: controller.binaryMessenger)

        photoEditorChannel.setMethodCallHandler({
             [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
             switch call.method {
            case "openPhotoEditor":
                result("Result from openPhotoEditor")
                self?.presentPhotoEditorScreen(viewController: controller, result: result)
            case "openCamera":
                self?.presentCameraScreen(viewController: controller, result: result)
            default:
                result(FlutterMethodNotImplemented)
             }
        })

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func presentPhotoEditorScreen(viewController: UIViewController, result: @escaping FlutterResult) {
        // guard let url = Bundle.main.url(forResource: "LA", withExtension: "jpg") else {
        //   return
        // }
        // let photo = Photo(url: url)
        // viewController.present(createPhotoEditViewController(with: nil), animated: true, completion: nil)
    }
    
    func presentCameraScreen(viewController: UIViewController, result: @escaping FlutterResult) {
        viewController.present(createCameraViewController(), animated: true, completion: nil)
    }
    
    private func createCameraViewController() -> CameraViewController {
        let configuration = buildConfiguration()
        let cameraViewController = CameraViewController(configuration: configuration)
        cameraViewController.modalPresentationStyle = .fullScreen
        cameraViewController.locationAccessRequestClosure = { locationManager in
          locationManager.requestWhenInUseAuthorization()
        }
        return cameraViewController
    }
    
    private func createPhotoEditViewController(with photo: Photo, and photoEditModel: PhotoEditModel = PhotoEditModel()) -> PhotoEditViewController {
      let configuration = buildConfiguration()
      let photoEditViewController = PhotoEditViewController(photoAsset: photo, configuration: configuration, photoEditModel: photoEditModel)
      photoEditViewController.modalPresentationStyle = .fullScreen
//      photoEditViewController.delegate = self

      return photoEditViewController
    }
    
    private func buildConfiguration() -> Configuration {
      let configuration = Configuration { builder in
        // Configure camera
        builder.configureCameraViewController { options in
          // Just enable photos
          options.allowedRecordingModes = [.photo]
          // Show cancel button
          options.showCancelButton = true
        }

        // Configure editor
        builder.configurePhotoEditViewController { options in
          var menuItems = PhotoEditMenuItem.defaultItems
          menuItems.removeLast() // Remove last menu item ('Magic')

          options.menuItems = menuItems
        }
      }

      return configuration
    }
}

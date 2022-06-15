import Flutter
import UIKit

public class SwiftShareWhatsappPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "share_whatsapp", binaryMessenger: registrar.messenger())
        let instance = SwiftShareWhatsappPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "installed" {
            if let whatsappURL = URL(string: "whatsapp://send?text=installed") {
                result(UIApplication.shared.canOpenURL(whatsappURL) ? 1 : 0)
                return
            }
            result(FlutterError(code: "ERROR_INSTALLED", message: "Failed to generate whatsappURL", details: nil))
            return
        }
      
        if call.method == "share" {
            self.share(call.arguments, result: result)
            return
        }
        
        result(FlutterMethodNotImplemented)
    }
}

extension SwiftShareWhatsappPlugin {
    fileprivate func share(_ arguments: Any?, result: @escaping FlutterResult) {
        if let dict = arguments as? [String: String?] {
            var activityItems = [Any]()
            if let text = dict["text"] as? String {
                activityItems.append(OptionalTextActivityItemSource(text: text))
            }
            if let filePath = dict["file"] as? String {
                let file = URL(fileURLWithPath: filePath)
                activityItems.append(file)
            }
            let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                activityViewController.popoverPresentationController?.sourceView = UIApplication.topViewController()?.view
                if let view = UIApplication.topViewController()?.view {
                    activityViewController.popoverPresentationController?.permittedArrowDirections = []
                    activityViewController.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
                }
            }
            
            activityViewController.excludedActivityTypes = [
                UIActivity.ActivityType.postToFacebook,
                UIActivity.ActivityType.postToTwitter,
                UIActivity.ActivityType.postToWeibo,
                UIActivity.ActivityType.message,
                UIActivity.ActivityType.print,
                UIActivity.ActivityType.copyToPasteboard,
                UIActivity.ActivityType.assignToContact,
                UIActivity.ActivityType.saveToCameraRoll,
                UIActivity.ActivityType.addToReadingList,
                UIActivity.ActivityType.postToFlickr,
                UIActivity.ActivityType.postToVimeo,
                UIActivity.ActivityType.postToTencentWeibo,
                UIActivity.ActivityType.airDrop,
                UIActivity.ActivityType.mail,
            ]
            
            DispatchQueue.main.async {
                self.presentActivityView(activityViewController: activityViewController)
            }
            
            result(1)
            return
        }
        
        result(FlutterError(code: "ERROR_SHARE", message: "Arguments is not a dictionary [String:String]", details: arguments.debugDescription))
    }
    
    fileprivate func presentActivityView(activityViewController: UIActivityViewController) {
        // using this fake view controller to prevent this iOS 13+ dismissing the top view when sharing with "Save Image" option
        let fakeViewController = TransparentViewController()
        fakeViewController.modalPresentationStyle = .overFullScreen

        activityViewController.completionWithItemsHandler = { [weak fakeViewController] _, _, _, _ in
            if let presentingViewController = fakeViewController?.presentingViewController {
                presentingViewController.dismiss(animated: false, completion: nil)
            } else {
                fakeViewController?.dismiss(animated: false, completion: nil)
            }
        }

        UIApplication.topViewController()?.present(fakeViewController, animated: true) { [weak fakeViewController] in
            fakeViewController?.present(activityViewController, animated: true, completion: nil)
        }
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

class TransparentViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
    }
}

class OptionalTextActivityItemSource: NSObject, UIActivityItemSource {
    let text: String
    
    init(text: String) {
        self.text = text
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return text
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        if activityType?.rawValue == "net.whatsapp.WhatsApp.ShareExtension" {
            // WhatsApp doesn't support both image and text, so return nil and thus only sharing an image.
            return nil
        }
        return text
    }
}

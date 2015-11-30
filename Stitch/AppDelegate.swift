

import UIKit
import Photos

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
    
    window!.tintColor = UIColor.blueThemeColor()
    
    UINavigationBar.appearance().barTintColor = UIColor.blueThemeColor()
    UINavigationBar.appearance().tintColor = UIColor.whiteColor()
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    
    return true
  }
	
//	func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
//		handleShortcutItem(shortcutItem)
//		completionHandler(true)
//	}
	
//	func handleShortcutItem(
//		shortcutItem: UIApplicationShortcutItem) {
//			switch shortcutItem.type {
//				case "com.entrepreneurgt.Stitch.new":
//					presentNewStitchViewController()
//				default:
//					break
//			}
//	}
	
//	func presentNewStitchViewController() {
//		let identifier = "AssetCollectionsViewController"
//		let stitchViewController = UIStoryboard.mainStoryboard.instantiateViewControllerWithIdentifier(identifier)
//		
//		window?.rootViewController?.presentViewController(stitchViewController, animated: true, completion: nil)
//		
//	}
	
}

//extension UIStoryboard {
//	class var mainStoryboard: UIStoryboard {
//		return UIStoryboard(name: "main", bundle: nil)
//	}
//}



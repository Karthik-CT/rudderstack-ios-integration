//
//  AppDelegate.swift
//  push
//
//  Created by Karthik Iyer on 13/12/22.
//

import UIKit
import CleverTapSDK
import Rudder
import Rudder_CleverTap

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, CleverTapPushNotificationDelegate, CleverTapURLDelegate {
    
    let center  = UNUserNotificationCenter.current()
    var window: UIWindow?
    var lastHandledURL: URL?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        CleverTap.autoIntegrate()
        CleverTap.setDebugLevel(CleverTapLogLevel.debug.rawValue)
        registerForPush()
        
        // rudderstack initialization
        let builder = RSConfigBuilder()
            .withDataPlaneUrl("https://clevertapuerok.dataplane.rudderstack.com")
            .withFactory(RudderCleverTapFactory.instance())
            .withTrackLifecycleEvens(true)
        RSClient.getInstance("31GxJsA14aHEDoKVkY7XReCNGNH", config: builder.build())
        
        UNUserNotificationCenter.current().delegate = self
        
        CleverTap.sharedInstance()?.setUrlDelegate(self)
        CleverTap.sharedInstance()?.setPushNotificationDelegate(self)
        // Create your root view controller (e.g., ViewController)
        let rootViewController = ViewController() // Replace with your actual root view controller
        
        // Wrap the root view controller in a UINavigationController
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        // Set the root view controller as the UINavigationController
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let ctID = CleverTap.sharedInstance()?.profileGetID() ?? ""
        
        
        return true
    }
    
    func registerForPush() {
        // register category with actions
        let action1 = UNNotificationAction(identifier: "action_1", title: "Back", options: [])
        let action2 = UNNotificationAction(identifier: "action_2", title: "Next", options: [])
        let action3 = UNNotificationAction(identifier: "action_3", title: "View In App", options: [])
        let category = UNNotificationCategory(identifier: "CTNotification", actions: [action1, action2, action3], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        // Register for Push notifications
        UNUserNotificationCenter.current().delegate = self
        // request Permissions
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge, .alert], completionHandler: {granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        })
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NSLog("%@: failed to register for remote notifications: %@", self.description, error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        NSLog("%@: registered for remote notifications: %@", self.description, deviceToken.debugDescription)
        //  Manual Implementation of Push
//        CleverTap.sharedInstance()?.setPushToken(deviceToken as Data)
    }
    
    //Background
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        CleverTap.sharedInstance()!.handleNotification(withData: response.notification.request.content.userInfo)
        completionHandler()
    }
    
    // Foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        
        //CleverTap.sharedInstance()?.handleNotification(withData: notification.request.content.userInfo, openDeepLinksInForeground: true)
        completionHandler([.badge, .sound, .alert])
    }
    
    //Push Notification Callback
    func pushNotificationTapped(withCustomExtras customExtras: [AnyHashable : Any]!) {
        print("Push Notification Tapped with Custom Extras: \(customExtras)");
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        NSLog("%@: did receive remote notification completionhandler: %@", self.description, userInfo)
        completionHandler(UIBackgroundFetchResult.noData)
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    public func shouldHandleCleverTap(_ url: URL?, for channel: CleverTapChannel) -> Bool {
        print("Handling URL: \(url!) for channel: \(channel)")
        guard let url = url else {
            print("URL is nil")
            return false
        }
        lastHandledURL = url
        if url.absoluteString == "https://ct-web-integration.netlify.app/page2" || url.absoluteString == "karthikdl://page2" {
            DispatchQueue.main.async {
                self.redirectToTarget()
            }
            return false
        }
        return false
    }
    
    private func redirectToTarget2() {
        print("Redirecting to target...")

        guard let topVC = getTopMostViewController() else {
            print("Top-most view controller not found")
            return
        }

        if let navigationController = topVC.navigationController {
            print("Navigation Controller found")
            if !(navigationController.topViewController is HomeScreenViewController) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let targetVC = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as? HomeScreenViewController {
                    navigationController.pushViewController(targetVC, animated: true)
                    print("Navigated to HomeScreenViewController")
                }
            }
        } else {
            print("No UINavigationController found. Presenting modally.")

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let targetVC = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as? HomeScreenViewController {
                targetVC.modalPresentationStyle = .fullScreen // Ensures it appears properly

                DispatchQueue.main.async {
                    // Dismiss any existing modal before presenting
                    topVC.dismiss(animated: false) {
                        topVC.present(targetVC, animated: true) {
                            print("Presented HomeScreenViewController modally")
                        }
                    }
                }
            } else {
                print("Failed to instantiate HomeScreenViewController")
            }
        }
    }


    // Function to get the top-most view controller
    private func getTopMostViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }),
              let rootVC = window.rootViewController else {
            return nil
        }

        var topVC: UIViewController? = rootVC
        while let presentedVC = topVC?.presentedViewController {
            topVC = presentedVC
        }
        return topVC
    }
    
    private func redirectToTarget() {
        guard let navigationController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController as? UINavigationController else {
            print("Navigation controller not found")
            return
        }
        
        // Avoid pushing the same view controller multiple times
        if !(navigationController.topViewController is HomeScreenViewController) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let targetVC = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as? HomeScreenViewController {
                navigationController.pushViewController(targetVC, animated: true)
            }
        }
    }
    
    
}


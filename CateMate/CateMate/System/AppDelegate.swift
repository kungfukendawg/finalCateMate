

import UIKit

extension UINavigationController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let taskManager = TaskManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override to customize after launching app

        let taskController = window?.rootViewController?.children.first as? TasksController
        taskController?.taskManager = taskManager
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. Ex: When user recieves a call.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate to save data
        
        // Save tasks
        TasksUtility.save(self.taskManager.tasks)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use the method to store info to restore the app to its current state in case it's terminated.
        
        // Save tasks
        TasksUtility.save(self.taskManager.tasks)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

}


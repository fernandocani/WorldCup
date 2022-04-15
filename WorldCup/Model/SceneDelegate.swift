//
//  SceneDelegate.swift
//  WorldCup
//
//  Created by Fernando Cani on 02/04/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        //https://www.youtube.com/watch?v=Nx22LOSK614
        //https://www.youtube.com/watch?v=Gc1NSQS5lX0
        switch window.traitCollection.userInterfaceIdiom {
        case .pad, .mac:
            window.rootViewController = self.createSplitViewController()
            window.makeKeyAndVisible()
            self.window = window
        case .phone:
            window.rootViewController = self.createMainViewController()
            (window.rootViewController as? UISplitViewController)?.delegate = self
            window.makeKeyAndVisible()
            self.window = window
        default:
            fatalError("falta implementar")
        }

        #if targetEnvironment(macCatalyst)
        windowScene.sizeRestrictions?.minimumSize = CGSize(width: 440, height: 600)
        //windowScene.sizeRestrictions?.maximumSize = CGSize(width: 1200, height: 1200)
        #endif
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

}

extension SceneDelegate {
    
    func createSplitViewController() -> UISplitViewController {
        let splitVC = UISplitViewController(style: .doubleColumn)
        splitVC.preferredDisplayMode = .twoBesideSecondary
        splitVC.setViewController(SidebarViewController(), for: .primary)
        splitVC.setViewController(self.createMainViewController(), for: .secondary)
        return splitVC
    }
    
    func createMainViewController() -> UINavigationController {
        let navBar = MainNavigationController(rootViewController: MainViewController())
        navBar.navigationBar.prefersLargeTitles = false
        return navBar
    }
    
}

extension SceneDelegate: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, showDetail vc: UIViewController, sender: Any?) -> Bool {
        guard let tabController = splitViewController.viewControllers.first as? UITabBarController else { return false}
        var vcToShow = vc
        if let nav = vc as? UINavigationController, let topViewController = nav.topViewController {
            vcToShow = topViewController
        }
        tabController.selectedViewController?.show(vcToShow, sender: self)
        return true
    }
    
}

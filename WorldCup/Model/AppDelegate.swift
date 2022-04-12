//
//  AppDelegate.swift
//  WorldCup
//
//  Created by Fernando Cani on 02/04/22.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "WorldCup")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate {
    
    ///https://blog.worldline.tech/2020/05/06/menus-in-catalyst-apps.html
    override func buildMenu(with builder: UIMenuBuilder) {
        if builder.system == UIMenuSystem.context {
            return
        }
        super.buildMenu(with: builder)
        builder.remove(menu: .format)
        builder.remove(menu: .newScene)
        
        let item1 = UIKeyCommand(title: "Options DB",
                                 action: #selector(MainViewController.btnOptions),
                                 input: ",",
                                 modifierFlags: [.command])
        let item2 = UIKeyCommand(title: "Create DB",
                                 action: #selector(MainViewController.createDB),
                                 input: "n",
                                 modifierFlags: [.command])
        let item3 = UIKeyCommand(title: "Clear DB",
                                 action: #selector(MainViewController.clearDB),
                                 input: "d",
                                 modifierFlags: [.command])
        let menu1 = UIMenu(title: "Core Data",
                           //identifier: UIMenu.Identifier("Open Doc"),
                           children: [item1, item2, item3])

        builder.insertSibling(menu1, afterMenu: .edit)
    }
    
}

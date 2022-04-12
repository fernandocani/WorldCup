//
//  MainViewController+NSToolbar.swift
//  WorldCup
//
//  Created by Fernando Cani on 04/04/22.
//

import UIKit

#if targetEnvironment(macCatalyst)
extension MainViewController: NSToolbarDelegate {
    
    enum Toolbar {
        static let itemTeams = NSToolbarItem.Identifier(rawValue: "teams")
        static let itemGroups = NSToolbarItem.Identifier(rawValue: "groups")
        static let itemStadium = NSToolbarItem.Identifier(rawValue: "stadium")
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        switch itemIdentifier {
        case Toolbar.itemTeams:
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            item.image = UIImage(systemName: "photo")//?.forNSToolbar()
            item.target = self
            item.action = #selector(btnGoToTeams)
            item.label = "Teams"
            return item
        case Toolbar.itemGroups:
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            item.image = UIImage(systemName: "photo")//?.forNSToolbar()
            item.target = self
            item.action = #selector(btnGoToGroups)
            item.label = "Groups"
            return item
        case Toolbar.itemStadium:
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            item.image = UIImage(systemName: "square.and.arrow.up")//?.forNSToolbar()
            item.target = self
            item.action = #selector(btnGoToStadiums)
            item.label = "Stadiums"
            return item
        default:
            break
        }
        return nil
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [Toolbar.itemTeams, Toolbar.itemGroups, .flexibleSpace, Toolbar.itemStadium]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return self.toolbarDefaultItemIdentifiers(toolbar)
    }
    
}
#endif

extension MainViewController {
    func buildMacToolbar() {
        #if targetEnvironment(macCatalyst)
        guard let windowScene = view.window?.windowScene else {
            return
        }
        if let titlebar = windowScene.titlebar {
            let toolbar = NSToolbar(identifier: "toolbar")
            toolbar.delegate = self
            toolbar.allowsUserCustomization = true
            titlebar.toolbar = toolbar
        }
        #endif
    }
}


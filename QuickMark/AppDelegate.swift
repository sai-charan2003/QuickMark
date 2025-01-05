//
//  AppDelegate.swift
//  QuickMark
//
//  Created by Sai Charan on 02/01/25.
//

import Foundation
import SwiftUI
import AppKit

class AppDelegate : NSObject, NSApplicationDelegate {
    var statusItem : NSStatusItem?
    var homeViewModel: HomeViewModel?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupMenu()
        
    }
    
    private func setupMenu() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "bookmark", accessibilityDescription: "Bookmark Icon")
        }
        let menu = NSMenu()
        let textFieldView = MenuBarView().environmentObject(homeViewModel!)
        let hostingController = NSHostingController(rootView: textFieldView)
        hostingController.view.frame.size = CGSize(width: 200, height: 100) 
        let customMenuItem = NSMenuItem()
        customMenuItem.view = hostingController.view
        menu.addItem(customMenuItem)

        statusItem?.menu = menu
        
    }
    
}

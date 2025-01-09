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
    private var popover: NSPopover?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupMenu()
        
    }
    
    private func setupMenu() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "bookmark", accessibilityDescription: "Bookmark Icon")
            button.action = #selector(showPopover)
        }
        popover = NSPopover()
//        popover?.contentSize = NSSize(width: 300, height: 300)
        popover?.behavior = .transient
        let textFieldView = MenuBarView().environmentObject(homeViewModel!)
        let hostingController = NSHostingController(rootView: textFieldView)
        popover?.contentViewController = hostingController

        
    }
    @objc func showPopover() {
        guard let button = statusItem?.button, let popover = popover else { return }
        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
                    
        
    }
}

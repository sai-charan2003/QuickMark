//
//  QuickMarkApp.swift
//  QuickMark
//
//  Created by Sai Charan on 25/12/24.
//

import SwiftUI

@main
struct QuickMarkApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            HomeView(context: dataController.container.viewContext)
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}

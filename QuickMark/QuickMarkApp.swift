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

    @StateObject private var homeViewModel: HomeViewModel

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {

        let context = DataController().container.viewContext
        _homeViewModel = StateObject(wrappedValue: HomeViewModel(context: context))

        appDelegate.homeViewModel = HomeViewModel(context: context)
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(homeViewModel)
        }
    }
}

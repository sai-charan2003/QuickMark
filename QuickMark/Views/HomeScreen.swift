//
//  HomeScreen.swift
//  QuickMark
//
//  Created by Sai Charan on 25/12/24.
//
import SwiftUI
struct HomeView: View {
    @Environment(\.managedObjectContext) private var context
    @State private var showAddURL: Bool = false
    @State private var url: String = ""
    @State private var sideBarItem: SideBarItems = .All
    @State private var bookmarks: [QuickMark] = []
    @EnvironmentObject private var viewModel: HomeViewModel


    var body: some View {
        NavigationSplitView {
            List(selection: $sideBarItem) {
                ForEach(SideBarItems.allCases) { item in
                    NavigationLink(value: item) {
                        
                        HStack {
                            Image(systemName: "bookmark.circle")
                            Text(item.title)
                        }
                    }
                }
            }
            .navigationSplitViewColumnWidth(min: 200, ideal: 200)
        } detail: {
            switch sideBarItem {
            case .All:
                BookmarksView()
            }
        }
    }
}


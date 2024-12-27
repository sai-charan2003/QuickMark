//
//  HomeScreen.swift
//  QuickMark
//
//  Created by Sai Charan on 25/12/24.
//
import SwiftUI
struct HomeView: View {
    @Environment(\.managedObjectContext) var context
    @StateObject private var viewModel: HomeViewModel
    @State var showAddURL: Bool = false
    @State var url: String = ""
    @State var sideBarItem: SideBarItems = .All
    @State var bookmarks: [QuickMark] = []
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(context: context))
    }

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
                BookmarksView(context: context)
            }
        }
    }
}


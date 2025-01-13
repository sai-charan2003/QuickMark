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
    @State private var addFolder : Bool = false
    @State private var folderItems : [FolderData] = []
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var isHovered = false


    var body: some View {
        NavigationSplitView {
            SidebarListView()
        } detail: {
            detailView(for: sideBarItem)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                addButton
            }
        }
    }


    private func SidebarListView() -> some View {
        List {
            sidebarItemsSection
            foldersSection
        }
        .navigationSplitViewColumnWidth(min: 200, ideal: 200)
    }


    private var sidebarItemsSection: some View {
        Section {
            ForEach(SideBarItems.allCases) { item in
                NavigationLink(value: item) {
                    HStack {
                        Image(systemName: "bookmark.circle")
                        Text(item.title)
                    }
                }
            }
        }
    }


    private var foldersSection: some View {
        Section("Folders") {
            createFolderButton
            folderList
        }
    }


    private var createFolderButton: some View {

            HStack {
                Image(systemName: "plus")
                Text("Create folder")
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                addFolder.toggle()
            }


        
        .sheet(isPresented: $addFolder){
            AddFolderView(
                onFolderBookmark: { folder in
                    viewModel.addFolder(folderName: folder)
                    addFolder.toggle()
                },
                onCancel: {
                    addFolder.toggle()
                    
                }
            )
            
            
        }
    }


    private var folderList: some View {
        ForEach(viewModel.folders, id: \.uuid) { folder in
            NavigationLink {
                
                FolderView(folderUUID : folder.uuid)
                    .id(folder.uuid)
                
            } label: {
                HStack {
                    Image(systemName: "folder")
                    Text(folder.folderName!)
                }
                .contextMenu{
                    Button("Delete"){
                        viewModel.deleteFolder(folder: folder)
                    }
                }
                
            }
        }
    }


    private func detailView(for item: SideBarItems) -> some View {
        switch item {
        case .All:
            return AnyView(BookmarksView())
        }
    }


    private var addButton: some View {
        Button(action: { showAddURL.toggle() }) {
            Label("Add Item", systemImage: "plus")
        }
        .keyboardShortcut("n", modifiers: .command)
        .sheet(isPresented: $showAddURL) {
            AddBookmarkView(
                loadingState: $viewModel.loadingState,
                folderList : viewModel.folders,
                onBookmark: { url, uuid in
                    withAnimation {
                        viewModel.addBookmark(url: url,folderUUID: uuid)
                    }
                },
                
                onCancel: {
                    showAddURL = false
                    viewModel.resetLoadingState()
                }
                
                
            )
        }
    }
}





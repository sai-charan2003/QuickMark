//
//  FolderView.swift
//  QuickMark
//
//  Created by Sai Charan on 12/01/25.
//

import SwiftUI

struct FolderView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var showAddURL: Bool = false
    @State private var searchString : String = ""
    @FocusState private var isSearchFieldFocused: Bool
    @State  var folderUUID : UUID?
    
    @State var folderData : FolderData?

    var body: some View {
        ScrollView {
            BookmarksInFolder()

            .onAppear(){
                viewModel.fetchBookmarks()
                folderData = viewModel.folderData(folderUUID: folderUUID!)
                
            }

        }
        .navigationTitle(folderData?.folderName ?? "")
        .searchable(text: $searchString)
        .searchFocused($isSearchFieldFocused)
        .background(Button("", action: { isSearchFieldFocused = true }).keyboardShortcut("f",modifiers: .command).hidden())
        
        
        .onChange(of: searchString){
            if(searchString.isEmpty){
                viewModel.fetchBookmarks()
            } else {
                viewModel.searchBookmarks(query: searchString)
            }
        }
        
        
    }
    private func BookmarksInFolder() -> some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 300), spacing: 10)], spacing: 10) {
            ForEach(viewModel.bookmarks.filter{
                $0.folderUUID == folderUUID!
            }, id: \.uuid) { bookmark in
                BookmarkCard(bookmark: bookmark,
                             onDelete: { bookmark in
                            withAnimation{
                                viewModel.deleteBookmark(bookmark: bookmark)
                            }
                        },
                             folderList: Binding(
                                     get: { viewModel.folders },
                                     set: { viewModel.folders = $0 }
                                 ),
                             onAddToFolder: { bookmarkUUID, folderUUID in
                    viewModel.addBookmarkToFolder(folderUUID: folderUUID, bookmark: bookmarkUUID)
                    
                }
                             ,
                             onRemoveFromFolder: { uuid in 
                    viewModel.removeBookmarkFromFolder(bookmark: bookmark)
                }
                             
                             
                )
                    .frame(width: 300, height: 250)
                
            }
        }
        
    }
}

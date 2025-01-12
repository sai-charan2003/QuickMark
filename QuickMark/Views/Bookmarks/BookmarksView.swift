//
//  BookmarksView.swift
//  QuickMark
//
//  Created by Sai Charan on 25/12/24.
//
import SwiftUI

struct BookmarksView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var showAddURL: Bool = false
    @State private var searchString : String = ""
    @FocusState private var isSearchFieldFocused: Bool
    @State  var folderUUID : UUID?

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 300), spacing: 10)], spacing: 10) {
                ForEach(viewModel.bookmarks.filter { bookmark in
                    folderUUID == nil || bookmark.folderUUID == folderUUID
                }, id: \.uuid) { bookmark in
                    BookmarkCard(bookmark: bookmark, onDelete: { bookmark in
                        withAnimation{
                            viewModel.deleteBookmark(bookmark: bookmark)
                        }
                    },
                                 folderList : viewModel.folders,
                                 onAddToFolder: { bookmarkUUID, folderUUID in
                        viewModel.addBookmarkToFolder(folderUUID: folderUUID, bookmark: bookmarkUUID)
                        
                    }
                                 
                                 
                    )
                        .frame(width: 300, height: 250)
                    
                }
            }
        }
        .navigationTitle("All Bookmarks")
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
}





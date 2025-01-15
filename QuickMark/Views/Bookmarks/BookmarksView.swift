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
                ForEach(viewModel.bookmarks, id: \.uuid) { bookmark in
                    BookmarkCard(bookmark: bookmark, onDelete: { bookmark in
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
                        
                    },
                                 onRemoveFromFolder: { bookmarkUUID in
                        viewModel.removeBookmarkFromFolder(bookmark: bookmark)
                        
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
        .onAppear(){
            viewModel.fetchBookmarks()
        }
        
        
        .onChange(of: searchString){
                viewModel.searchBookmarks(query: searchString)
            
        }
        
        
    }
}





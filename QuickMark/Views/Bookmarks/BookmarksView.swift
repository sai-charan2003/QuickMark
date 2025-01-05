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

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 300), spacing: 10)], spacing: 10) {
                ForEach(viewModel.bookmarks, id: \.uuid) { bookmark in
                    BookmarkCard(bookmark: bookmark, onDelete: { bookmark in
                        withAnimation{
                            viewModel.deleteBookmark(bookmark: bookmark)
                        }
                    })
                        .frame(width: 300, height: 250)
                }
            }
        }
        .navigationTitle("All Bookmarks")
        .searchable(text: $searchString)
        .searchFocused($isSearchFieldFocused)
        
        
        .onChange(of: searchString){
            if(searchString.isEmpty){
                viewModel.fetchBookmarks()
            } else {
                viewModel.searchBookmarks(query: searchString)
            }
        }
        
        
    }
}





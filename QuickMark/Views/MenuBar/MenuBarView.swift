//
//  StatusBarController.swift
//  QuickMark
//
//  Created by Sai Charan on 03/01/25.
//

import SwiftUI

struct MenuBarView: View {
    @State private var bookmarkURL: String = ""
    @EnvironmentObject private var viewModel : HomeViewModel
    @Environment(\.openURL) var openURL

    var body: some View {
        VStack {
            TextField("Enter bookmark URL", text: $bookmarkURL)
                .bookmarkTextFieldStyle()
                .onSubmit {
                    viewModel.addBookmark(url: bookmarkURL)
                }
            Button{
                viewModel.addBookmark(url: bookmarkURL)
            } label: {
                HStack {
                    if(viewModel.loadingState == .loading){
                        ProgressView()
                            .controlSize(.mini)
                            .scaleEffect(1.2)
                    }
                    Text("Add Bookmark")
                }
            }
            .padding(.bottom, 5)
            Text("Recent")
                .font(.headline)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.horizontal,8)
            
            List(viewModel.fetchLastThreeBookmarks(), id: \.uuid) { bookmark in
                Text(bookmark.title ?? "Untitled")
                    .padding(.vertical,8)
                    .lineLimit(2)
                    
                    .onTapGesture {
                        if let url = URL(string : bookmark.websiteURL!){
                            openURL(url)
                        }
                        
                    }
                    .onHover { isHovering in
                        if isHovering {
                            NSCursor.pointingHand.push()
                        } else {
                            NSCursor.pop()
                        }
                    }
                    .onDrag{
                        return NSItemProvider(object: bookmark.websiteURL! as NSString)
                    } preview: {
                        CompactCard(bookmark: bookmark)
                    }
                    
                
                
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
            .listSectionSeparator(.visible, edges: .all)
            .listSectionSeparatorTint(.secondary)
            .environment(\.defaultMinListRowHeight, 2)
            
            
            
        }
        
    }
}

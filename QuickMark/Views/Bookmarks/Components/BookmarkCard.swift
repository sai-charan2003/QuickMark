//
//  BookmarkCard.swift
//  QuickMark
//
//  Created by Sai Charan on 04/01/25.
//

import SwiftUI
struct BookmarkCard: View {
    let bookmark: QuickMark
    @Environment(\.openURL) var openURL
    var onDelete: ((QuickMark) -> Void)
    let clipBoard = NSPasteboard.general

    var body: some View {
        VStack {
            
            AsyncImage(url: URL(string: bookmark.imageURL ?? "https://icon.horse/icon/\(String(describing: bookmark.hostURL))")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 300, height: 168)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 300, height: 168)
                        .clipped()
                        .cornerRadius(8)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 168)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }

            
            VStack(alignment: .leading, spacing: 4) {
                Text(bookmark.title ?? "Untitled")
                    .websiteTitleStyle()

                

                Text(bookmark.hostURL ?? "Host")
                    .websiteHostStyle()

            }

        }
        .onTapGesture {
            if let url = URL(string : bookmark.websiteURL!) {
                openURL(url)
                
            }
        }
        .onHover{ isHovering in
            if isHovering {
                NSCursor.pointingHand.push()
            } else {
                NSCursor.pop()
            }
                            
            
        }
        .contextMenu{
            Button("Open") {
                if let url = URL(string : bookmark.websiteURL!) {
                    openURL(url)
                    
                }
            }
            
            
            Divider()
            Menu("Copy"){
                Button("Copy URL"){
                    
                    clipBoard.clearContents()
                    clipBoard.setString(bookmark.websiteURL ?? "", forType: .string)
                }
                Button("Copy Title"){
                    clipBoard.clearContents()
                    clipBoard.setString(bookmark.title ?? "", forType: .string)
                }
            }

            Button("Delete"){
                onDelete(bookmark)
                
            }
            Divider()
            if let url = URL(string: bookmark.websiteURL ?? "") {
                ShareLink("Share", item: url)
            }


        }
        
        
        .background(Color.white.opacity(0.05))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.top,20)
    }
    
    
}

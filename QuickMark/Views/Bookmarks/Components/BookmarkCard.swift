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
    @State var folderList : [FolderData] = []
    var onAddToFolder : ((UUID,UUID) -> Void)
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: bookmark.imageURL?.isEmpty == false ? bookmark.imageURL ?? "" : "https://api.faviconkit.com/\(bookmark.hostURL ?? "")")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 300, height: 168)
                case .success(let image):
                    ZStack {
                        Rectangle()
                            .fill(.tertiary.opacity(0.3))
                            .frame(width: 300, height: 168)
                        
                        if (bookmark.imageURL?.isEmpty ?? true) {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48)
                        } else {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 300, height: 168)
                        }
                    }
                    .clipped()
                    .cornerRadius(8)
                case .failure:
                    Image("placeholder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 168)
                        .background(.tertiary.opacity(0.3))

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
            if let url = URL(string: bookmark.websiteURL!) {
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
        .contextMenu {
            Button("Open") {
                if let url = URL(string: bookmark.websiteURL!) {
                    openURL(url)
                }
            }
            
            Divider()
            Menu("Copy") {
                Button("Copy URL") {
                    clipBoard.clearContents()
                    clipBoard.setString(bookmark.websiteURL ?? "", forType: .string)
                }
                Button("Copy Title") {
                    clipBoard.clearContents()
                    clipBoard.setString(bookmark.title ?? "", forType: .string)
                }
            }

            Button("Delete") {
                onDelete(bookmark)
            }
            Menu("Add to folder"){
                ForEach(folderList , id : \.uuid) { folder in
                    Button(folder.folderName!) {
                        onAddToFolder(bookmark.uuid!,folder.uuid!)
                        
                        
                    }
                }
            }
            Divider()
            if let url = URL(string: bookmark.websiteURL ?? "") {
                ShareLink("Share", item: url)
            }
        }
        .background(.tertiary.opacity(0.2))
        .cornerRadius(10)
        
        .padding(.top, 20)
        .onDrag{
            return NSItemProvider(object: bookmark.websiteURL! as NSString)
        } preview: {
            CompactCard(bookmark: bookmark)
        }

    }
}

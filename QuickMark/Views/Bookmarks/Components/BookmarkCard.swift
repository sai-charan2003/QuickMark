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
    @Binding var folderList: [FolderData]
    var onAddToFolder: ((UUID, UUID) -> Void)
    var onRemoveFromFolder: ((UUID) -> Void)
    
    var body: some View {
        VStack {
            AsyncImage(url: imageURL()) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 300, height: 168)
                case .success(let image):
                    ZStack {
                        Rectangle()
                            .fill(.tertiary.opacity(0.3))
                            .frame(width: 300, height: 168)
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 300, height: 168)
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
            if let urlString = bookmark.websiteURL, let url = URL(string: urlString) {
                openURL(url)
            }
        }
        .onHover { isHovering in
            isHovering ? NSCursor.pointingHand.push() : NSCursor.pop()
        }
        .contextMenu {
            contextMenu()
        }
        .background(.tertiary.opacity(0.2))
        .cornerRadius(10)
        .padding(.top, 20)
        .onDrag {
            if let websiteURL = bookmark.websiteURL {
                return NSItemProvider(object: websiteURL as NSString)
            }
            return NSItemProvider()
        } preview: {
            CompactCard(bookmark: bookmark)
        }
    }
    
    private func imageURL() -> URL? {
        if let imageURL = bookmark.imageURL, !imageURL.isEmpty {
            return URL(string: imageURL)
        } else if let hostURL = bookmark.hostURL {
            return URL(string: "https://api.faviconkit.com/\(hostURL)")
        }
        return nil
    }
    
    private func contextMenu() -> some View {
        Group {
            Button("Open") {
                if let urlString = bookmark.websiteURL, let url = URL(string: urlString) {
                    openURL(url)
                }
            }
            Divider()
            Menu("Copy") {
                Button("Copy URL") {
                    copyToClipboard(bookmark.websiteURL)
                }
                Button("Copy Title") {
                    copyToClipboard(bookmark.title)
                }
            }
            folderOperation()
            Button("Delete") {
                onDelete(bookmark)
            }

            Divider()
            if let urlString = bookmark.websiteURL, let url = URL(string: urlString) {
                ShareLink("Share", item: url)
            }
        }
    }
    
    private func copyToClipboard(_ text: String?) {
        guard let text = text else { return }
        clipBoard.clearContents()
        clipBoard.setString(text, forType: .string)
    }
    
    private func folderOperation() -> some View {
        Menu("Add to folder") {
            ForEach(folderList, id: \.uuid) { folder in
                Button(action: {
                    if(folder.uuid == bookmark.folderUUID){
                        onRemoveFromFolder(bookmark.uuid!)
                        
                    } else{
                        onAddToFolder(bookmark.uuid!,folder.uuid!)
                    }
                }) {
                    HStack {
                        if bookmark.folderUUID == folder.uuid {
                            Image(systemName: "checkmark")
                        }
                        Text(folder.folderName ?? "Unnamed Folder")
                    }
                }
            }
        }
        
    }
}


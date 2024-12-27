//
//  BookmarksView.swift
//  QuickMark
//
//  Created by Sai Charan on 25/12/24.
//
import SwiftUI

struct BookmarksView: View {
    
    @StateObject private var viewModel: HomeViewModel
    
    
    
    @State var showAddURL: Bool = false
    @State var url : String = ""
    
    @State var bookmarks : [QuickMark] = []
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(context: context))
        
    }
    

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 300), spacing: 30)], spacing: 30) {
                ForEach(viewModel.bookmarks, id: \.uuid) { bookmark in
                    BookmarkCard(bookmark: bookmark,onDelete: { bookmark in
                        deleteBookmark(bookmark: bookmark)
                        
                        
                    })
                        .frame(width: 300, height: 250)
                }
            }
            .padding(.horizontal, 30)

        }
        .toolbar{
            Button(action: {
                showAddURL.toggle()
            }) {
                Label("Add Item", systemImage: "plus")
            }
            .alert("Enter URL",isPresented: $showAddURL){
                TextField("Enter URL",text: $url)
                Button("Bookmark") {
                    addURL()
                }
                
                
            }
            
        }


        
        
    }
    private func addURL(){
        print("Testing for adding URL")
        
            viewModel.addBookmark(url: url)
            
        
        
        
    }
    private func ClearAll(){
        DispatchQueue.main.async {
            viewModel.clearAll()
            bookmarks = viewModel.bookmarks
        }
    }
    
    private func deleteBookmark(bookmark : QuickMark){
        viewModel.deleteBookmark(bookmark: bookmark)
    }
}

struct BookmarkCard: View {
    let bookmark: QuickMark
    @Environment(\.openURL) var openURL
    var onDelete: ((QuickMark) -> Void)

    var body: some View {
        VStack {
            
            AsyncImage(url: URL(string: bookmark.imageURL ?? "https://icon.horse/icon/\(String(describing: bookmark.hostURL))")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 100, height: 100)
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
                        .frame(width: 160, height: 100)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }

            
            VStack(alignment: .leading, spacing: 4) {
                Text(bookmark.title ?? "Untitled")
                    .font(.title3)
                    .foregroundColor(.primary)
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)

                Text("Added on \(bookmark.createdAt?.formatted(.dateTime.month().day().year()) ?? "")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 3.3)
            .padding(.vertical, 4)
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
            Button("Delete"){
                onDelete(bookmark)
                
            }
        }
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    
}


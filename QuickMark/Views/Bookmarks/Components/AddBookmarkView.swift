//
//  AddBookmark.swift
//  QuickMark
//
//  Created by Sai Charan on 28/12/24.
//
import SwiftUI

struct AddBookmarkView: View {
    @State var urlString: String = ""
    @Binding var loadingState: LoadingState?
    @State var folderList : [FolderData] = []
    @State var selectedFolder: FolderData?
    
    var onBookmark: ((String,UUID?) -> Void)
    var onCancel: (() -> Void)
    
    var body: some View {
        VStack {
            Text("Add Bookmark")
                .font(.title)
            
            Divider()
            
            
            VStack(alignment: .leading, spacing: 4) {
                TextField("Enter URL", text: $urlString)
                    .bookmarkTextFieldStyle()
                    .onSubmit {
                        onBookmark(urlString,selectedFolder?.uuid)
                    }
                    
 
                    
                if case .some(.error(_)) = loadingState {
                    Text("Invalid URL")
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal,20)
                        .transition(.opacity.combined(with: .scale))
                }
                AddFolderSection()

 
                

            }
            .padding(.bottom, 16)
            
            Divider()
            
            
            HStack {
                Button("Cancel") {
                    onCancel()
                }
                .keyboardShortcut(.cancelAction)
                
                Button {
                    onBookmark(urlString,selectedFolder?.uuid)
                } label: {
                    HStack {
                        if loadingState == .loading {
                            ProgressView()
                                .controlSize(.mini)
                                .scaleEffect(1.2)
                        }
                        if loadingState == .success {
                            Image(systemName: "checkmark.circle")
                        }
                        Text("Bookmark it")
                    }
                }
                .keyboardShortcut(.return)
            }
        }
        .padding()
        .onChange(of: loadingState) { _, newState in
            if newState == .success {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    onCancel()
                    
                }
               
            }
        }
    }
    
    private func AddFolderSection() -> some View {
        Section("Add To Folder") {
            List {
                ForEach(folderList, id: \.self) { folder in
                    HStack {
                        Toggle(isOn: Binding(
                            get: { selectedFolder == folder },
                            set: { isSelected in
                                if isSelected {
                                    selectedFolder = folder
                                } else {
                                    selectedFolder = nil
                                }
                            }
                        )) {
                            HStack {
                                Image(systemName: "folder.fill")
                                    .foregroundColor(.blue)
                                Text(folder.folderName ?? "")
                                    .font(.system(size: 16, weight: .medium))
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .listStyle(.plain)
            .frame(height: 100)
            .cornerRadius(8)
            .scrollContentBackground(.hidden)
        }
        .padding(.horizontal, 20)
    }
        
    }


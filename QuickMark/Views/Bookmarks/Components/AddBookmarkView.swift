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
    
    var onBookmark: ((String) -> Void)
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
                        onBookmark(urlString)
                    }
                    
 
                    
                if case .some(.error(_)) = loadingState {
                    Text("Invalid URL")
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal,20)
                        .transition(.opacity.combined(with: .scale))
                }
 
                

            }
            .padding(.bottom, 16)
            
            Divider()
            
            
            HStack {
                Button("Cancel") {
                    onCancel()
                }
                .keyboardShortcut(.cancelAction)
                
                Button {
                    onBookmark(urlString)
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
}

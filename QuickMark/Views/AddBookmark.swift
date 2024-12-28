//
//  AddBookmark.swift
//  QuickMark
//
//  Created by Sai Charan on 28/12/24.
//
import SwiftUI
struct AddBookmarkView : View {
    @State var urlString: String = ""
    @Binding var loadingState: LoadingState?
    
    var onBookmark : ((String)->Void)
    var onCancel : (()->Void)
    
    
    var body: some View {
        VStack {
            Text("Add Bookmark")
                .font(.title)
            Divider()
            TextField("Enter URL",text: $urlString)
                .padding()
            Divider()
            HStack {
                Button("Cancel"){
                    onCancel()
                    
                }
                .keyboardShortcut(.cancelAction)
                Button{
                    onBookmark(urlString)
                    
                } label: {
                    if(loadingState == .loading){
                        ProgressView()
                            .controlSize(.small)  
                    }
                    Text("Bookmark it")
                }
                .keyboardShortcut(.return)
                
            }
            
            
        }
        .padding()
        .onChange(of: loadingState){ oldState, newState in
            if newState == .success{
                onCancel()
            }
            
        }
    }
}

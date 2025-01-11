//
//  AddFolderView.swift
//  QuickMark
//
//  Created by Sai Charan on 10/01/25.
//
import SwiftUI
struct AddFolderView : View {
    @State var folderNmae: String = ""
    
    
    var onFolderBookmark: ((String) -> Void)
    var onCancel: (() -> Void)
    
    var body: some View {
        VStack {
            Text("Create Folder")
                .font(.title)
            
            Divider()
            
            
            VStack(alignment: .leading, spacing: 4) {
                TextField("Folder Name", text: $folderNmae)
                    .bookmarkTextFieldStyle()
                    .onSubmit {
                        onFolderBookmark(folderNmae)
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
                    onFolderBookmark(folderNmae)
                } label: {
                    Text("Add folder")

                }
                .keyboardShortcut(.return)
            }
        }
        .padding()

    }

}

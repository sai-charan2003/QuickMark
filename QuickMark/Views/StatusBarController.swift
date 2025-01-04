//
//  StatusBarController.swift
//  QuickMark
//
//  Created by Sai Charan on 03/01/25.
//
import AppKit
import SwiftUI

struct TextFieldMenuView: View {
    @State private var bookmarkURL: String = ""
    @EnvironmentObject private var viewModel : HomeViewModel

    var body: some View {
        VStack {
            TextField("Enter bookmark URL", text: $bookmarkURL)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
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
        }
        .frame(width: 200)
    }
}

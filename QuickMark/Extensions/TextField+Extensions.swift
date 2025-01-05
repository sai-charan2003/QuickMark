//
//  TextField+Extensions.swift
//  QuickMark
//
//  Created by Sai Charan on 04/01/25.
//

import SwiftUI

extension TextField {
    func bookmarkTextFieldStyle() -> some View {
        self
            .submitLabel(.return)
            .textFieldStyle(.roundedBorder)
            .padding()
        
    }
    

}

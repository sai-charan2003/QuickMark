//
//  Text+Extensions.swift
//  QuickMark
//
//  Created by Sai Charan on 04/01/25.
//

import SwiftUI

extension Text {
    
    func websiteTitleStyle() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.title3)
            .foregroundColor(.primary)
            .lineLimit(4)
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 5)
        
    }
    
    func websiteHostStyle() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.subheadline)
            .foregroundColor(.secondary)
            .padding(.horizontal, 5)
            .padding(.vertical, 10)
        
    }
    
}

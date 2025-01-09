//
//  CompactCard.swift
//  QuickMark
//
//  Created by Sai Charan on 08/01/25.
//

import SwiftUI

struct CompactCard : View{
    @State var bookmark : QuickMark?
    var body: some View {
        VStack {
            
            Text(bookmark?.title ?? "")
                .frame(maxWidth: .infinity,alignment: .leading)
                .lineLimit(1)
            Text(bookmark?.websiteURL ?? "")
                .frame(maxWidth: .infinity,alignment: .leading)
                .lineLimit(1)
        }
        .padding(8)
        
        .background(.secondary.opacity(0.1))
        .cornerRadius(10)
        .frame(minWidth: 0,  alignment: .leading)
        
    }
}

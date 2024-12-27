//
//  SideBarEnums.swift
//  QuickMark
//
//  Created by Sai Charan on 25/12/24.
//

enum SideBarItems : String, Identifiable, CaseIterable {
    var id : String {rawValue}
    case All
    
    var title : String {
        switch self {
        case .All : return "All Bookmarks"
        }
    }
    
    var icon : String {
        switch self {
            case .All : return "bookmark.circle"
        }
    }
   
}


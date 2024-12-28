//
//  LoadingState.swift
//  QuickMark
//
//  Created by Sai Charan on 28/12/24.
//
enum  LoadingState : Equatable{
    static func == (lhs: LoadingState, rhs: LoadingState) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading):
                return true
            case (.success, .success):
                return true
            case let (.error(lhsError), .error(rhsError)):
                return lhsError.localizedDescription == rhsError.localizedDescription
            default:
                return false
            }
        }
    
    case error(Error)
    case loading
    case success
}

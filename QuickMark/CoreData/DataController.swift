//
//  DataController.swift
//  QuickMark
//
//  Created by Sai Charan on 25/12/24.
//

import CoreData
class DataController : ObservableObject {
    let container = NSPersistentContainer(name: "QuickMark")
    
    init() {
        container.loadPersistentStores{ description, error in
            if let error = error {
                print("Failed to the data")
            }
            
        }
    }
    
}

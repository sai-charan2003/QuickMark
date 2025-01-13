//
//  HomeViewModel.swift
//  QuickMark
//
//  Created by Sai Charan on 25/12/24.
//
import Foundation
import CoreData
import SwiftSoup

class HomeViewModel : ObservableObject {
    @Published var bookmarks : [QuickMark] = []
    @Published var loadingState : LoadingState? = nil
    @Published var folders : [FolderData] = []
    var selectedUUID : UUID? = nil
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchBookmarks()
        fetchFolders()
        observeBookmarks()
    }
    
    func fetchBookmarks() {
        let request: NSFetchRequest<QuickMark> = QuickMark.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \QuickMark.createdAt, ascending: false)]
        
        do {
            bookmarks = try context.fetch(request)
            print(bookmarks)
        } catch {
            print("Unable to get the data. Please try again.")
        }
    }
    

    
    func clearAll(){
        do {
            bookmarks.forEach { context.delete($0) }
            try context.save()
            fetchBookmarks()
        } catch {
            print(error)
        }
        
    }
    
    func addBookmark(url: String,folderUUID : UUID?) {
        loadingState = .loading
        
        extractWebsiteData(from: url) { quickmark in
            

            DispatchQueue.main.async {
                if quickmark != nil {
                    do {
                        print("Saving bookmark with extracted data")
                        quickmark?.folderUUID = folderUUID
                        
                        try self.context.save()
                        self.loadingState = .success
                    } catch {
                        print("Error saving context: \(error)")
                        self.loadingState = .error(error)
                    }
                } else {
                    print("Error")
                    self.loadingState = .error(NSError(domain: "Invalid URL", code: 0, userInfo: nil))
                }
            }
        }
    }



    func extractWebsiteData(from urlString: String, completion: @escaping (QuickMark?) -> Void) {
        
        var normalizedURLString = urlString
        if !urlString.hasPrefix("http://") && !urlString.hasPrefix("https://") {
            normalizedURLString = "https://\(urlString)"
        }
        
        guard let url = URL(string: normalizedURLString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data, let html = String(data: data, encoding: .utf8) else {
                print("No data or invalid encoding")
                completion(nil)
                return
            }
            
            do {
                let document = try SwiftSoup.parse(html)
                let title = try document.select("title").text()
                let imageURL = try document.select("meta[property=og:image]").attr("content")
                print(imageURL)
                
                let quickMark = QuickMark(context: self.context)
                quickMark.title = title
                quickMark.imageURL = imageURL 
                quickMark.hostURL = url.host
                quickMark.websiteURL = normalizedURLString
                quickMark.uuid = UUID()
                quickMark.createdAt = Date()
                print(quickMark.imageURL)
                completion(quickMark)
            } catch {
                print("Error parsing HTML: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }


    
    func deleteBookmark(bookmark : QuickMark){
        do {
            context.delete(bookmark)
            try context.save()
            fetchBookmarks()
            
        } catch {
            print(error)
        }
       
        
        
        
    }

    
    func observeBookmarks(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contextDidChange(notification:)),
            name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
            object: context
        )
        
    }
    @objc private func contextDidChange(notification: Notification) {
        
        fetchBookmarks()
        

    }
    
    func resetLoadingState(){
        loadingState = nil
    }
    
    func searchBookmarks(query: String,selectedUUID : UUID? = nil) {
        bookmarks = bookmarks.filter {
                    ($0.title?.localizedCaseInsensitiveContains(query) ?? false) ||
                    ($0.websiteURL?.localizedCaseInsensitiveContains(query) ?? false)
            
                }
    }
    
    func fetchLastThreeBookmarks() -> [QuickMark] {
        return Array(bookmarks.sorted { $0.createdAt! < $1.createdAt! }.prefix(3))
    }
    
    func fetchFolders() {
        let request: NSFetchRequest<FolderData> = FolderData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FolderData.createdAt, ascending: false)]
        
        do {
            folders = try context.fetch(request)
            print(folders.count)
        } catch {
            print("Unable to get the data. Please try again.")
        }
    }
    
    func addFolder(folderName : String){
        do {
            let newFolder = FolderData(context: context)
            newFolder.createdAt = Date()
            newFolder.folderName = folderName
            newFolder.uuid = UUID()
            try context.save()
            fetchFolders()

        } catch {
            print(error)
        }
    }
    func deleteFolder(folder : FolderData){
        context.delete(folder)
        do {
            try context.save()
            fetchFolders()
        } catch {
            print(error)
        }
    }
    
    func addBookmarkToFolder(folderUUID : UUID, bookmark : UUID){
        let fetchRequest : NSFetchRequest<QuickMark> = QuickMark.fetchRequest()
        do {
            let bookmarks = try context.fetch(fetchRequest)
            let bookmarkToAdd = bookmarks.filter { $0.uuid == bookmark }
            if let itemToUpdate = bookmarkToAdd.first {
                itemToUpdate.folderUUID = folderUUID
                try context.save()
            }
            
            
            
        } catch {
            print(error)
        }
        
        
    }
    
    func folderData(folderUUID : UUID) -> FolderData?{
        do {
            let fetchRequest : NSFetchRequest<FolderData> = FolderData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "uuid == %@", folderUUID as CVarArg)
            let folder = try context.fetch(fetchRequest).first
            return folder
        } catch {
            print(error)
            return nil
        }
    }
    
    func filterDataByFolderUUID(folderUUID : UUID) {
        bookmarks = bookmarks.filter{$0.folderUUID == folderUUID}
        
    }


}

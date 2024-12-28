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
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchBookmarks()
        observeBookmarks()
    }
    
    func fetchBookmarks() {
        let request: NSFetchRequest<QuickMark> = QuickMark.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \QuickMark.createdAt, ascending: false)]
        
        do {
            bookmarks = try context.fetch(request)
            print(bookmarks.count)
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
    
    func addBookmark(url: String) {
        loadingState = .loading
        
        extractWebsiteData(from: url) { quickmark in
            

            DispatchQueue.main.async {
                if let quickmark {
                    
                    
                    do {
                        print("Saving bookmark with extracted data")
                        try self.context.save()
                        self.loadingState = .success
                    } catch {
                        print("Error saving context: \(error)")
                        self.loadingState = .error(error)
                    }
                } else {
                    self.loadingState = .error(NSError(domain: "Unable to add.", code: 0, userInfo: nil))
                }
            }
        }
    }

    


    func extractWebsiteData(from urlString: String, completion: @escaping (QuickMark?) -> Void) {
        guard let url = URL(string: urlString) else {
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

                
                let quickMark = QuickMark(context : self.context)
                quickMark.title = title
                quickMark.imageURL = imageURL
                quickMark.hostURL = url.host
                quickMark.websiteURL = urlString
                quickMark.uuid = UUID()
                quickMark.createdAt = Date()


            
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
}

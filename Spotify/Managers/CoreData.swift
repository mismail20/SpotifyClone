//
//  CoreData.swift
//  MusicApp
//
//  Created by Mohamed Ismail on 17/09/2023.
//

import Foundation
import CoreData
import UIKit

class CoreData {
    static let shared = CoreData()

    func saveTitle(model: Library, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = LibraryItem(context: context)
        
        item.title = model.title
        item.artist = model.artist
        item.image = model.image
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func fetchLibrary(completion: @escaping (Result<[LibraryItem], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<LibraryItem>
        
        request = LibraryItem.fetchRequest()
        
        do {
            let titles = try context.fetch(request)
            completion(.success(titles))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removeTitle(model: Library, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext

        let request: NSFetchRequest<LibraryItem>
        
        request = LibraryItem.fetchRequest()
        
        request.predicate = NSPredicate(format: "title == %@", model.title)
        
        do {
            try context.delete(context.fetch(request).first!)
            try context.save()
            completion(.success(()))
        } catch {
            print(error.localizedDescription)
        }
    }
    
}


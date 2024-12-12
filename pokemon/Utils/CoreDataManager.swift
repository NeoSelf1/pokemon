//
//  CoreDataManager.swift
//  pokemon
//
//  Created by Neoself on 12/12/24.
//
import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ContactModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func fetchContacts() -> [ContactEntity] {
        let request: NSFetchRequest<ContactEntity> = ContactEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching contacts: \(error)")
            return []
        }
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}

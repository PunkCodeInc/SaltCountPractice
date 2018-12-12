//
//  DataStore.swift
//  SaltCount
//
//  Created by Jeff DeWitte on 11/22/18.
//  Copyright © 2018 Jeff DeWitte. All rights reserved.
//

import CoreData
import UIKit

class DataStore: NSObject {
    
    private let delegate: NSFetchedResultsControllerDelegate
    
    // Initialization
    init(fetchedResultsDelegate: NSFetchedResultsControllerDelegate) {
        delegate = fetchedResultsDelegate
    }
    
    // MARK: - Core Data stack
    
    private lazy var persistentContainer: PunkCodePersistentContainer = {
        let container = PunkCodePersistentContainer(name: "SaltCount")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unable to Load Persistent Stores")
                print("\(error), \(error.localizedDescription)")
            }
        })
        return container
    }()
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Counter> = {
        let fetchRequest: NSFetchRequest<Counter> = Counter.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createDate", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = delegate
        
        return fetchedResultsController
    }()
    
    // MARK: - Core Data actions
    
    func performFetch(completion: Completion?) {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        completion?()
    }
    
    func addCounterFrom(dict: NSDictionary, completion: Completion) {
        let entity = NSEntityDescription.entity(forEntityName: "Counter",
                                                in: persistentContainer.viewContext)!
        let counter = Counter(dictionary: dict,
                              entity: entity,
                              insertIntoManagedObjectContext: persistentContainer.viewContext)
        
        saveFor(counter: counter, completion: completion)
    }
    
    func numberOfCounters() -> Int? {
        return fetchedResultsController.fetchedObjects?.count
    }
    
    func getCounterAt(indexPath: IndexPath) -> Counter? {
        guard let fetchedObjects = fetchedResultsController.fetchedObjects,
            indexPath.row < fetchedObjects.count else {
                return nil
        }
        return fetchedResultsController.object(at: indexPath)
    }
    
    func saveFor(counter: Counter, completion: Completion) {
        do {
            try counter.managedObjectContext?.save()
            try persistentContainer.viewContext.save()
        } catch {
            let saveError = error as NSError
            print("Unable to Save Counter")
            print("\(saveError), \(saveError.localizedDescription)")
        }
        
        completion()
    }
    
    func delete(counter: Counter, completion: Completion) {
        do {
            persistentContainer.viewContext.delete(counter)
            try persistentContainer.viewContext.save()
        } catch {
            let saveError = error as NSError
            print("Unable to Save Counter")
            print("\(saveError), \(saveError.localizedDescription)")
        }
        
        completion()
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Unable to Save")
                print("\(error), \(error.localizedDescription)")
            }
        }
    }
}

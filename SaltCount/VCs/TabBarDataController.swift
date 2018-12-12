//
//  TabBarConfigController.swift
//  SaltCount
//
//  Created by Jeff DeWitte on 11/23/18.
//  Copyright © 2018 Jeff DeWitte. All rights reserved.
//

import CoreData
import UIKit

class TabBarDataController: NSObject {
    private var dataStore: DataStore?
    
    override init() {
        
    }
    
    func configureWith(tableListDelegate: NSFetchedResultsControllerDelegate) {
        self.dataStore = DataStore(fetchedResultsDelegate: tableListDelegate)
    }
    
    func fetchCounters(completion: Completion? = nil) {
        dataStore?.performFetch(completion: completion)
    }
    
    func insert(counterDict: NSDictionary, completion: Completion) {
        dataStore?.addCounterFrom(dict: counterDict, completion: completion)
    }
    
    func incrementCounterAt(indexPath: IndexPath, completion: Completion) {
        guard let counter = dataStore?.getCounterAt(indexPath: indexPath) else {
            return
        }
        counter.incrementCount()
        dataStore?.saveFor(counter: counter, completion: completion)
    }
    
    func decrementCounterAt(indexPath: IndexPath, completion: Completion) {
        guard let counter = dataStore?.getCounterAt(indexPath: indexPath) else {
            return
        }
        counter.decrementCount()
        dataStore?.saveFor(counter: counter, completion: completion)
    }
    
    func updateCounterAt(indexPath: IndexPath,
                         withValues values: NSDictionary,
                         completion: Completion) {
        guard let counter = dataStore?.getCounterAt(indexPath: indexPath) else {
            return
        }
        counter.updateWith(values: values)
        dataStore?.saveFor(counter: counter, completion: completion)
    }
    
    func deleteCounterAt(indexPath: IndexPath, completion: Completion) {
        guard let counter = dataStore?.getCounterAt(indexPath: indexPath) else {
            return
        }
        dataStore?.delete(counter: counter, completion: completion)
    }
    
    func numberOfCounters() -> Int? {
        return dataStore?.numberOfCounters()
    }
    
    func retrieveCounterAt(indexPath: IndexPath) -> Counter? {
        return dataStore?.getCounterAt(indexPath: indexPath)
    }
    
    func saveCounterContext() {
        dataStore?.saveContext()
    }
}

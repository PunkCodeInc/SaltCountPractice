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
    
    func fetchCounters(completion: Completion?) {
        dataStore?.performFetch(completion: completion)
    }
    
    func insert(counterDict: NSDictionary, completion: Completion) {
        dataStore?.addCounterFrom(dict: counterDict, completion: completion)
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

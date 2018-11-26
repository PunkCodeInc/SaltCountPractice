//
//  Main Controller.swift
//  SaltCount
//
//  Created by Jeff DeWitte on 11/22/18.
//  Copyright © 2018 Jeff DeWitte. All rights reserved.
//

import CoreData
import UIKit

class TableListController: NSObject {

    private var updateDelegate: TableListUpdateDelegate?
    
    override init() {
        super.init()
    }
    
    func configureWith(tableUpdateDelegate: TableListUpdateDelegate) {
        updateDelegate = tableUpdateDelegate
    }
}

extension TableListController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateDelegate?.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateDelegate?.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            updateDelegate?.insertAt(indexPath: newIndexPath)
            break;
        case .delete:
            updateDelegate?.deleteAt(indexPath: indexPath)
            
            break;
        case .update:
            updateDelegate?.updateAt(indexPath: indexPath)
            break;
        case .move:
            updateDelegate?.deleteAt(indexPath: indexPath)
            
            updateDelegate?.insertAt(indexPath: newIndexPath)
            break;
        }
    }
    
}

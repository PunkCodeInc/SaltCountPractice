//
//  Counter+CoreDataClass.swift
//  SaltCountPractice
//
//  Created by Jeff DeWitte on 11/23/18.
//  Copyright © 2018 Jeff DeWitte. All rights reserved.
//
//

import CoreData
import Foundation

@objc(Counter)
public class Counter: NSManagedObject {
    
    static let kName = "name"
    static let kInc = "increment"
    static let kDec = "decrement"
    static let kCount = "count"
    
    var countInt : Int {
        get { return Int(count) }
        set { count = Int64(newValue) }
    }
    
    var incrementInt : Int {
        get { return Int(increment) }
        set { increment = Int64(newValue) }
    }
    
    var decrementInt : Int {
        get { return Int(decrement) }
        set { decrement = Int64(newValue) }
    }
    
    // MARK: Convenience init - data should have been checked before now
    convenience init(dictionary: NSDictionary, entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext) {
        self.init(entity: entity, insertInto: context)
        updateWith(values: dictionary)
        createDate = NSDate()
    }
    
    func incrementCount() {
        count += increment
    }
    
    func decrementCount() {
        count -= decrement
    }
    
    func updateWith(values: NSDictionary) {
        name = values[Counter.kName] as? String
        incrementInt = (values[Counter.kInc] as? Int) ?? 0
        decrementInt = (values[Counter.kDec] as? Int) ?? 0
        countInt = (values[Counter.kCount] as? Int) ?? 0
    }
}

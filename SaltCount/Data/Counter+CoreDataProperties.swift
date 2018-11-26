//
//  Counter+CoreDataProperties.swift
//  SaltCountPractice
//
//  Created by Jeff DeWitte on 11/23/18.
//  Copyright © 2018 Jeff DeWitte. All rights reserved.
//
//

import Foundation
import CoreData


extension Counter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Counter> {
        return NSFetchRequest<Counter>(entityName: "Counter")
    }

    @NSManaged public var name: String?
    @NSManaged public var increment: Int64
    @NSManaged public var decrement: Int64
    @NSManaged public var count: Int64
    @NSManaged public var createDate: NSDate?

}

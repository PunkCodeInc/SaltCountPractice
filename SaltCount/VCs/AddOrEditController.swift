//
//  AddOrEditController.swift
//  SaltCount
//
//  Created by Jeff DeWitte on 11/23/18.
//  Copyright © 2018 Jeff DeWitte. All rights reserved.
//

import UIKit

class AddOrEditController: NSObject {
    
    // MARK: Properties
    
    private let existingCounterData: (counter: Counter, indexPath: IndexPath)?
    
    // MARK Initialization
    
    init(counterData: (Counter, IndexPath)?) {
        existingCounterData = counterData
    }
    
    // MARK: Public Methods
    
    func isCreatingNewCounter() -> Bool {
        return existingCounterData == nil
    }
    
    func counterData() -> (counter: Counter, indexPath: IndexPath)? {
        return existingCounterData
    }
    
    func counterIndex() -> IndexPath? {
        return existingCounterData?.indexPath
    }
    
    func counterName() -> String? {
        return existingCounterData?.counter.name
    }
    
    func counterCount() -> Int? {
        return existingCounterData?.counter.countInt
    }
    
    func counterInc() -> Int? {
        return existingCounterData?.counter.incrementInt
    }
    
    func counterDec() -> Int? {
        return existingCounterData?.counter.decrementInt
    }
    
    func title() -> String {
        let title: String
        if let counter = existingCounterData?.counter {
            title = counter.name ?? "Edit Counter"
        } else {
            title = "Add New Counter"
        }
        
        return title
    }
    
    func allNumericalsIn(string: String) -> Bool {
        let numberSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: numberSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
    
    func zeroAtStartOf(numericalString: String) -> Bool {
        return numericalString.count > 0 && numericalString.first == "0"
    }
    
    func saveCriteriaMetFor(nameText: String?,
                            startCount: Int?,
                            increment: Int?,
                            decrement: Int?) -> Bool {
        if let name = nameText,
            name.trimmingCharacters(in: .whitespacesAndNewlines).count > 0,
            startCount != nil,
            let inc = increment,
            inc > 0,
            let dec = decrement,
            dec > 0 {
                return true
        } else {
            return false
        }
    }
    
    func buildCounterDictFrom(nameText: String?,
                              startCount: Int?,
                              increment: Int?,
                              decrement: Int?) -> NSDictionary? {
        guard let name = nameText,
            let count = startCount,
            let inc = increment,
            let dec = decrement else {
            return nil
        }
        
        return [Counter.kName: name,
                Counter.kCount: count,
                Counter.kInc: inc,
                Counter.kDec: dec]
    }
}

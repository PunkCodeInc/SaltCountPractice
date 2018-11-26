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
    
    private let counterToEdit: Counter?
    
    // MARK Initialization
    
    init(counter: Counter?) {
        counterToEdit = counter
    }
    
    // MARK: Public Methods
    
    func counterName() -> String? {
        return counterToEdit?.name
    }
    
    func counterCount() -> Int? {
        return counterToEdit?.countInt
    }
    
    func counterInc() -> Int? {
        return counterToEdit?.incrementInt
    }
    
    func counterDec() -> Int? {
        return counterToEdit?.decrementInt
    }
    
    func title() -> String {
        let title: String
        if let counter = counterToEdit {
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

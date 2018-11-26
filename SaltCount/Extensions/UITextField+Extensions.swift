//
//  UITextField+Extensions.swift
//  SaltCountPractice
//
//  Created by Jeff DeWitte on 11/24/18.
//  Copyright © 2018 Jeff DeWitte. All rights reserved.
//

import UIKit

extension UITextField {
    var intValue: Int? {
        get {
            if let text = self.text {
                return Int(text) ?? nil
            }
            return nil
        }
        set {
            if let text = newValue {
                self.text = String(text)
            } else {
                self.text = nil
            }
        }
    }
}

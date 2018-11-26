//
//  AddOrEditCounterViewController.swift
//  SaltCount
//
//  Created by Jeff DeWitte on 11/23/18.
//  Copyright © 2018 Jeff DeWitte. All rights reserved.
//

import UIKit

let addOrEditVCNibName = "AddOrEditCounterViewController"

class AddOrEditCounterViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var startingCountField: UITextField!
    @IBOutlet weak var incrementField: UITextField!
    @IBOutlet weak var decrementField: UITextField!
    
    private let controller: AddOrEditController
    private let parentDelegate: TabBarParentDelegate
    
    static func addEditViewControllerInNC(counter: Counter? = nil,
                                          parentDelegate: TabBarParentDelegate)
        -> UINavigationController {
            let vc = AddOrEditCounterViewController(counter: counter, parentDelegate: parentDelegate)
            let nc = UINavigationController(rootViewController: vc)
            return nc
    }
    
    init(counter: Counter? = nil,
         parentDelegate: TabBarParentDelegate) {
        controller = AddOrEditController(counter: counter)
        self.parentDelegate = parentDelegate
        super.init(nibName: addOrEditVCNibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateFields()
        setupNavBar()
    }
    
    private func populateFields() {
        nameField.text = controller.counterName()
        startingCountField.intValue = controller.counterCount()
        incrementField.intValue = controller.counterInc()
        decrementField.intValue = controller.counterDec()
    }
    
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(cancelButtonPressed(_:)))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(saveButtonPressed(_:)))
        updateSaveButton()
    }
    
    private func updateSaveButton() {
        navigationItem.rightBarButtonItem?.isEnabled = controller.saveCriteriaMetFor(nameText: nameField.text,
                                                                                     startCount: startingCountField.intValue,
                                                                                     increment: incrementField.intValue,
                                                                                     decrement: decrementField.intValue)
    }
    
    @objc private func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonPressed(_ sender: UIBarButtonItem) {
        if let countDict = controller.buildCounterDictFrom(nameText: nameField.text,
                                                           startCount: startingCountField.intValue,
                                                           increment: incrementField.intValue,
                                                           decrement: decrementField.intValue) {
            parentDelegate.createCounterFrom(counterDict: countDict) { [weak self] in
                DispatchQueue.main.async {
                    self?.dismiss(animated: true) {
                        self?.parentDelegate.fetchCounters(completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func textFieldEditingChanged(_ sender: Any) {
        updateSaveButton()
    }
}

extension AddOrEditCounterViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        var shouldReturn: Bool
        if textField == nameField {
            shouldReturn = true
        } else {
            if controller.allNumericalsIn(string: string) {
                var result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
                
                if controller.zeroAtStartOf(numericalString: result)
                    && !(textField == startingCountField && result.count == 1) {
                    result.removeFirst()
                    textField.text = result
                    shouldReturn = false
                } else {
                    shouldReturn = true
                }
            } else {
                shouldReturn = false
            }
        }
        
        return shouldReturn
    }
    
}

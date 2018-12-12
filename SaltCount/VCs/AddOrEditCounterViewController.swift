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
    @IBOutlet weak var deleteButton: UIButton!
    
    private let controller: AddOrEditController
    private let parentDelegate: TabBarParentDelegate
    
    static func addEditViewControllerInNC(counterData: (Counter, IndexPath)? = nil,
                                          parentDelegate: TabBarParentDelegate)
        -> UINavigationController {
            let vc = AddOrEditCounterViewController(counterData: counterData, parentDelegate: parentDelegate)
            let nc = UINavigationController(rootViewController: vc)
            return nc
    }
    
    init(counterData: (Counter, IndexPath)? = nil,
         parentDelegate: TabBarParentDelegate) {
        controller = AddOrEditController(counterData: counterData)
        self.parentDelegate = parentDelegate
        super.init(nibName: addOrEditVCNibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateFields()
        deleteButton.isHidden = controller.isCreatingNewCounter()
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
    
    private func dismissWithAddOrUpdateFor(counterData: NSDictionary) {
        let completion: Completion = { [weak self] in
            self?.fetchAndDismiss()
        }
        
        if let existingCounterdata = controller.counterData() {
            parentDelegate.updateCounterAt(indexPath: existingCounterdata.indexPath,
                                           withValues: counterData,
                                           completion: completion)
        } else {
            parentDelegate.createCounterFrom(counterDict: counterData, completion: completion)
        }
    }
    
    private func fetchAndDismiss() {
        parentDelegate.fetchCounters() {
            DispatchQueue.main.async { [weak self] in
                self?.dismiss(animated: true)
            }
        }
    }
    
    // MARK: Button Actions
    
    @objc private func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonPressed(_ sender: UIBarButtonItem) {
        if let countDict = controller.buildCounterDictFrom(nameText: nameField.text,
                                                           startCount: startingCountField.intValue,
                                                           increment: incrementField.intValue,
                                                           decrement: decrementField.intValue) {
            dismissWithAddOrUpdateFor(counterData: countDict)
        }
    }
    
    @IBAction func textFieldEditingChanged(_ sender: Any) {
        updateSaveButton()
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        guard let name = controller.counterName(),
            let index = controller.counterIndex() else {
            return
        }
        
        let alert = UIAlertController(title: "Confirm Delete", message: "Are you sure you want to delete \(name)?", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "No", style: .cancel)
        
        let confirmDelete = UIAlertAction(title: "Yes", style: .destructive) { [weak self] _ in
            self?.parentDelegate.deleteCounterAt(indexPath: index) {
                self?.fetchAndDismiss()
            }
        }
        
        alert.addAction(cancel)
        alert.addAction(confirmDelete)
        present(alert, animated: true)
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

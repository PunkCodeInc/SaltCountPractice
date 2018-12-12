//
//  CounterTableViewCell.swift
//  SaltCount
//
//  Created by Jeff DeWitte on 11/23/18.
//  Copyright © 2018 Jeff DeWitte. All rights reserved.
//

import UIKit

typealias CounterCellAction = (CounterAction) -> Void

enum CounterAction {
    case increment
    case decrement
    case edit
}

class CounterTableViewCell: UITableViewCell {

    // MARK: - Public properties
    static let identifier = String(describing: CounterTableViewCell.self)
    static let nib = UINib(nibName: identifier, bundle: nil)
    
    // MARK: Properties
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var countLabel: UILabel!
    @IBOutlet weak private var decButton: UIButton!
    @IBOutlet weak private var incButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    private var counterAction: CounterCellAction?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutIfNeeded()
    }

    //MARK: Public Methods
    func configureWith(counter: Counter, action: CounterCellAction?) {
        nameLabel.text = counter.name
        countLabel.text = "\(counter.countInt)"
        decButton.setTitle("-\(counter.decrementInt)", for: .normal)
        incButton.setTitle("+\(counter.incrementInt)", for: .normal)
        counterAction = action
    }
    
    //MARK: Private Methods
    @IBAction private func incrementButtonTapped(_ sender: Any) {
        counterAction?(.increment)
    }
    
    @IBAction func decrementButtonTapped(_ sender: Any) {
        counterAction?(.decrement)
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        counterAction?(.edit)
    }
    
}

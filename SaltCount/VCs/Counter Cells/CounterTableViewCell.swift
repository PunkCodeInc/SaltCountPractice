//
//  CounterTableViewCell.swift
//  SaltCount
//
//  Created by Jeff DeWitte on 11/23/18.
//  Copyright © 2018 Jeff DeWitte. All rights reserved.
//

import UIKit

class CounterTableViewCell: UITableViewCell {

    // MARK: - Public properties
    static let identifier = String(describing: CounterTableViewCell.self)
    static let nib = UINib(nibName: identifier, bundle: nil)
    
    // MARK: Properties
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var countLabel: UILabel!
    @IBOutlet weak private var decButton: UIButton!
    @IBOutlet weak private var incButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutIfNeeded()
    }

    //MARK: Public Methods
    func configureWith(counter: Counter) {
        nameLabel.text = counter.name
        countLabel.text = "\(counter.countInt)"
        decButton.setTitle("-\(counter.decrementInt)", for: .normal)
        incButton.setTitle("+\(counter.incrementInt)", for: .normal)
    }
    
    //MARK: Private Methods
    
    
}

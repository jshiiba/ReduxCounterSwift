//
//  AddCounterCell.swift
//  ReduxCounter
//
//  Created by Justin Shiiba on 4/15/17.
//  Copyright © 2017 Shiiba. All rights reserved.
//

import UIKit

protocol AddCounterCellDelegate {
    func addTapped(for cell: UITableViewCell)
}

class AddCounterCell: UITableViewCell {

    @IBOutlet weak var addButton: UIButton!

    var delegate: AddCounterCellDelegate?

    @IBAction func addButtonTapped(button: UIButton) {
        delegate?.addTapped(for: self)
    }
    
}

//
//  CounterViewCell.swift
//  ReduxCounter
//
//  Created by Justin Shiiba on 4/15/17.
//  Copyright © 2017 Shiiba. All rights reserved.
//

import UIKit

protocol CounterCellDelegate {
    func increaseTapped(for cell: UITableViewCell)
    func decreaseTapped(for cell: UITableViewCell)
    func removeTapped(for cell: UITableViewCell)
}

class CounterViewCell: UITableViewCell {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!

    var delegate: CounterCellDelegate?

    @IBAction func increaseButtonTapped(sender: UIButton) {
        delegate?.increaseTapped(for: self)
    }

    @IBAction func decreaseButtonTapped(sender: UIButton) {
        delegate?.decreaseTapped(for: self)
    }

    @IBAction func removeButtonTapped(sender: UIButton) {
        delegate?.removeTapped(for: self)
    }

}

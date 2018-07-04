//
//  InboxTableViewCell.swift
//  Pearing_Up
//
//  Created by Grace Kim on 2018-07-03.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//

import UIKit

class InboxTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
}

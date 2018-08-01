//
//  ContactListTableViewCell.swift
//  Pearing_Up
//
//  Created by Ali Arshad on 2018-07-23.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class ContactListTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var messageDetail : MessageDetail!
    
    var userPostKey: DatabaseReference!
}

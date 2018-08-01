//
//  MessagesCell.swift
//  Pearing_Up
//
//  Created by aaa117 on 7/31/18.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//

import UIKit

class MessagesCell: UITableViewCell {
    
    @IBOutlet weak var recievedMessageLabel: UILabel!
    @IBOutlet weak var recievedMessageView: UIView!

    @IBOutlet weak var sentMessageView: UIView!
    @IBOutlet weak var sentMessageLabel: UILabel!
    var message: Message!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(message: Message) {
        self.message = message
        
        if message.sender == User.Data.username {
            sentMessageView.isHidden = false
        
            sentMessageLabel.text = ""
            
            recievedMessageLabel.text = message.message
            
            recievedMessageLabel.isHidden = true
        }
        else {
            sentMessageView.isHidden = false
            
            sentMessageLabel.text = ""
            
            recievedMessageLabel.text = message.message
            
            recievedMessageLabel.isHidden = false
        }
    }
}

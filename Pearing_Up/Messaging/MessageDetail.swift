//
//  MessageDetail.swift
//  Pearing_Up
//
//  Created by aaa117 on 7/31/18.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class MessageDetail {
    
    private var _recipient: String!
    
    private var _messageKey: String!
    
    private var _messageRef: DatabaseReference!
    
    var recipient: String {
        
        return _recipient
    }
    
    var messageKey: String {
        
        return _messageKey
    }
    
    var messageRef: DatabaseReference {
        
        return _messageRef
    }
    
    init(recipient: String) {
        
        _recipient = recipient
    }
    
    init(messageKey: String, messageData: Dictionary<String, AnyObject>) {
        
        _messageKey = messageKey
        
        if let recipient = messageData["recipient"] as? String {
            
            _recipient = recipient
        }
        
        _messageRef = Database.database().reference().child("recipient").child(_messageKey)
    }
}


//
//  Message.swift
//  Pearing_Up
//
//  Created by aaa117 on 7/31/18.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class Message {
    
    private var _message: String!
    private var _sender: String!
    private var _messageKey: String!
    private var _messageRef: DatabaseReference!
    
    var message: String {
        return _message
    }
    
    var sender: String {
        return _sender
    }
    
    var messagekey: String {
        return _messageKey
    }
    
    init(message: String, sender: String) {
        _message = message
        _sender = sender
    }
    
    init(messageKey: String, postData: Dictionary<String, AnyObject>) {
        
        _messageKey = messageKey
        
        if let message = postData["message"] as? String {
            _message = message
        }
        
        if let sender = postData["sender"] as? String {
            _sender = sender
        }
        
        _messageRef = Database.database().reference().child("messages").child(_messageKey)
    }
}

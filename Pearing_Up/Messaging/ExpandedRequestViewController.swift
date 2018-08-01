//
//  ExpandedRequestViewController.swift
//  Pearing_Up
//
//  Created by Ali Arshad on 2018-07-04.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import FirebaseDatabase
import SwiftyJSON

class ExpandedRequestViewController: UIViewController {

    @IBOutlet weak var descriptionUI: UILabel!
    @IBOutlet weak var nameUI: UILabel!
    var requestDespcription : String?
    var requestName : String?
    let url = "https://pearingup.herokuapp.com"
    
    let myGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.descriptionUI.text = requestDespcription
        self.nameUI.text = requestName
        print(requestName)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        descriptionUI.sizeToFit()
        self.tabBarController?.tabBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    // WORK FROM HERE, URL MIGHT BE WRONG
    @IBAction func acceptRequest(_ sender: Any) {
        myGroup.enter()
        let accept_url : URL = URL(string: (url + "/AcceptRequest/" + User.Data.username + "/" + requestName!))!
        sendRequest(url: accept_url)
        sendMessage()
        _ = navigationController?.popViewController(animated: true)
        myGroup.leave()
    }

    @IBAction func declineRequest(_ sender: Any) {
        myGroup.enter()
        let decline_url : URL = URL(string: (url + "/declineRequest/"  + User.Data.username + "/" + requestName!))!
        sendRequest(url: decline_url)
        _ = navigationController?.popViewController(animated: true)
        myGroup.leave()
    }
    
    func sendRequest(url: URL){
        self.myGroup.enter()
        // Pass the request to the server here
        Alamofire.request(url, method: .get).responseJSON{
            response in
            if(response.result.isSuccess) {
                let temp : JSON  = JSON(response.result.value!)
                print(temp)
                
                if(temp["code"] == 302 || temp["code"] == 400 || temp["code"] == 409) {
                    self.displayAlert(message: String(describing: temp["result"]))
                }
                self.myGroup.leave()
            }
            else {
                print("Error")
                print(response.error ?? "None")
                self.myGroup.leave()
            }
        }
    }
    
    func sendMessage() {
        
        let post : Dictionary<String, AnyObject> = [
            "message" : requestDespcription as AnyObject,
            "sender" : requestName as AnyObject]
        
        let message : Dictionary<String, AnyObject> = [
            "lastmessage" : requestDespcription as AnyObject,
            "recipient" : requestName as AnyObject]
        
        let recipientMessage : Dictionary<String, AnyObject> = [
            "lastmessage" : requestDespcription as AnyObject,
            "recipient" : requestName as AnyObject]
        
        let messageId = Database.database().reference().child("messages").childByAutoId().key
        
        let firebaseMessage = Database.database().reference().child("messages").child(messageId).childByAutoId()
        
        firebaseMessage.setValue(post)
        
        let recipientMsg = Database.database().reference().child("users").child(requestName!).child("messages").child(messageId)
        
        recipientMsg.setValue(recipientMessage)
        
        let userMessage = Database.database().reference().child("users").child(User.Data.username).child("messages").child(messageId)
        
        userMessage.setValue(message)
    }
    
    func displayAlert(message: String){
        
        let alert_toDisplay = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)

        self.present(alert_toDisplay, animated: true, completion: nil)
    }
}

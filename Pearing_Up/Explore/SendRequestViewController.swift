//
//  SendRequestViewController.swift
//  Pearing_Up
//
//  Created by Ali Arshad on 2018-07-03.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

// View Controller Class used to send a request to pick from another user's tree
class SendRequestViewController: UIViewController {
    
    var owner: String!
    var image: UIImage!
    var titl: String!
    var desc: String!
    var loca: String!
    var fruitnme: String!
    
    let message_url : String = "https://pearingup.herokuapp.com/sentRequest"
    var receiverName : String!
    @IBOutlet weak var messageUI: UITextView!
    @IBOutlet weak var lastDateUI: UIDatePicker!
    @IBOutlet weak var firstDateUI: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back_to_expandview(_ sender: Any) {
        self.performSegue(withIdentifier: "sendrequest_to_expandview", sender: self)
        
    }
    
    // Pass posting info back to the expanded post so it can load
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "sendrequest_to_expandview" {
            
            let expandview  = segue.destination as! ExpandedPostViewController
            expandview.desc = self.desc
            expandview.titl = self.titl
            expandview.fruitnme = self.fruitnme
            expandview.image = self.image
        }
    }
    
    // Build URL and sends a request to that owner using the provided dates
    @IBAction func sendMessage(_ sender: Any) {
        let firstDate = firstDateUI.date
        let secondDate = lastDateUI.date
        if(firstDate > secondDate){
            print("Date Error")
            displayAlert(message: "Second Date must be after the first.")
        }
        else {
            let message = ("I am free from: " + dateToString(date: firstDate) + "\nTo: " + dateToString(date: secondDate) + "\n" + messageUI.text)
        
            let url = (message_url + "/" + User.Data.username + "/" + receiverName)
            print("send a request at " + url)
            serverRequest(url: url, params: ["add_msg" : message])// also need to pass the dates
            self.performSegue(withIdentifier: "sendrequest_to_expandview", sender: self)
        }
    }
    
    func serverRequest(url: String, params: [String:String]){
        Alamofire.request(url, method: .post, parameters: params).responseJSON{
            response in
            if response.result.isSuccess {
                let temp : JSON = JSON(response.result.value!)
                print(temp)
                // This is the case where User Already Exists
                
                if(temp["code"] == 302 || temp["code"] == 400 || temp["code"] == 409){
                    self.displayAlert(message: String(describing: temp["result"]))
                    print("Error Happened, url is:" + url)

                    return
                }
            }
            else {
                print("Error Happened, url is:" + url)
            }
        }
    }
    
    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: Date()) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }
    
    func displayAlert(message: String){
        
        let alert_toDisplay = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        alert_toDisplay.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            //self.email_holder.text = "email"
            //self.pwd_holder.text = "password"
        }))
        self.present(alert_toDisplay, animated: true, completion: nil)
    }
    
    
    
    
    
    
}






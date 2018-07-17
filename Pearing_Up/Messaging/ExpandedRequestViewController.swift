//
//  ExpandedRequestViewController.swift
//  Pearing_Up
//
//  Created by Ali Arshad on 2018-07-04.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ExpandedRequestViewController: UIViewController {

    @IBOutlet weak var descriptionUI: UILabel!
    @IBOutlet weak var nameUI: UILabel!
    var requestDespcription : String?
    var requestName : String?
    let url = "https://pearingup.herokuapp.com"
    
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
    
    // WORK FROM HERE, URL MIGHT BE WRONG
    @IBAction func acceptRequest(_ sender: Any) {
        let accept_url : URL = URL(string: (url + "/AcceptRequest/" + User.Data.username + "/" + requestName!))!
        sendRequest(url: accept_url)
        self.performSegue(withIdentifier: "acceptRequest", sender: self)
    }

    @IBAction func declineRequest(_ sender: Any) {
        let decline_url : URL = URL(string: (url + "/declineRequest/"  + User.Data.username + "/" + requestName!))!
        sendRequest(url: decline_url)
        self.performSegue(withIdentifier: "declineRequest", sender: self)
    }
    
    func sendRequest(url: URL){
        // Pass the request to the server here
        Alamofire.request(url, method: .get).responseJSON{
            response in
            if(response.result.isSuccess) {
                let temp : JSON  = JSON(response.result.value!)
                print(temp)
                
                if(temp["code"] == 302 || temp["code"] == 400 || temp["code"] == 409) {
                    self.displayAlert(message: String(describing: temp["result"]))
                }
            }
            else {
                print("Error")
                print(response.error ?? "None")
            }
        }
    }
    
    func displayAlert(message: String){
        
        let alert_toDisplay = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)

        self.present(alert_toDisplay, animated: true, completion: nil)
    }
}

//
//  RatingViewController.swift
//  Pearing_Up
//
//  Created by Grace Kim on 2018-07-31.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RatingViewController: UIViewController {

    var person : String!
    var tag: Int!
    var ratingType: String!
    
    
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet var starButtons: [UIButton]!
    @IBOutlet weak var cell: UIView!
    
    let myGroup = DispatchGroup()
    
    let url = "https://pearingup.herokuapp.com/rateUser/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(person + " " + ratingType)
        personLabel.text = person
        cell.layer.shadowRadius = 2.5
        cell.layer.masksToBounds = false
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.cornerRadius = 10.0
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func StarButtonTapped(_ sender: UIButton) {
        tag = sender.tag
        for button in starButtons {
            if button.tag <= tag {
                //select button
                button.setTitle("★", for: .normal)
            }
            else {
                //do not select
                button.setTitle("☆", for: .normal)
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
        let _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func submit(_ sender: Any) {
        //sendRating(rating: tag)
        print(tag)
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func sendRating(rating: Int) {
        self.myGroup.enter()
        var urlString = url + ratingType
        urlString = urlString + "/" + User.Data.username + "/" + person
        let url_rating : URL = URL(string: urlString)!
        print(urlString)
        let params : [String: Int] = ["rating":rating]
        // Pass the request to the server here
        
        Alamofire.request(url_rating, method: .post, parameters: params).responseJSON{
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
    
    func displayAlert(message: String){
        
        let alert_toDisplay = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        self.present(alert_toDisplay, animated: true, completion: nil)
    }
}

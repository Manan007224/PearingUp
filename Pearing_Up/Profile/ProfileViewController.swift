//
//  ProfileViewController.swift
//  Pearing_Up
//
//  Created by Manan Maniyar on 2018-06-18.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameTextView: UILabel!
    @IBOutlet weak var pickerRatingLabel: UILabel!
    @IBOutlet weak var ownerRatingLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    let myGroup = DispatchGroup()
    let url = "https://pearingup.herokuapp.com"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextView.text = User.Data.username
        locationLabel.text = User.Data.city
        //getRating(ratingType: "picker")
        //getRating(ratingType: "owner")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func getRating(ratingType: String){
        self.myGroup.enter()
        // Pass the request to the server here
        
        let rating_url : URL = URL(string: (url + "/rating/" + ratingType + "/" + User.Data.username))!
        Alamofire.request(rating_url, method: .get).responseJSON{
            response in
            if(response.result.isSuccess) {
                let temp : JSON  = JSON(response.result.value!)
                print(temp)
                if(ratingType == "owner") {
                    self.ownerRatingLabel.text = temp["rating"].stringValue
                }
                else{
                    self.pickerRatingLabel.text = temp["rating"].stringValue
                }
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToYourPosts(_ sender: Any) {
        self.performSegue(withIdentifier: "yourPostsSegue", sender: self)
    }
    
    @IBAction func gotobookmarks(_ sender: Any) {
        self.performSegue(withIdentifier: "bookmarkslist", sender: self)
    }
    
    
    @IBAction func logoutButton(_ sender: Any) {
        self.performSegue(withIdentifier: "logout", sender: self)
    }
    

    func displayAlert(message: String){
        
        let alert_toDisplay = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        self.present(alert_toDisplay, animated: true, completion: nil)
    }
}

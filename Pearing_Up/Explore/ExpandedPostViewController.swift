//
//  ExpandedPostViewController.swift
//  Pearing_Up
//
//  Created by Ali Arshad on 2018-07-03.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ExpandedPostViewController: UIViewController {

    var owner : String!
    var image : UIImage!
    var titl: String!
    var desc: String!
    var loca: String!
    var fruitnme: String!
  
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var fruitimage: UIImageView!
    @IBOutlet weak var MakeAppointmentButton: UIButton!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var fruitname: UILabel!
    @IBOutlet weak var bookmarkButtonUI: UIButton!
    
    let myGroup = DispatchGroup()
    
    var bookmarkedPosts : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
        fruitimage.layer.borderWidth = 1
        fruitimage.layer.shadowRadius = 5.0
        fruitimage.layer.masksToBounds = false
        fruitimage.layer.shadowOpacity = 1.0
        fruitimage.layer.shadowOffset = CGSize.zero
        fruitimage.layer.cornerRadius = 10.0
        descriptionText.text = desc
        titleText.text = titl.replacingOccurrences(of: "_", with: " ")
        fruitname.text = fruitnme
        fruitimage.image = image
        location.text = loca
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        myGroup.notify(queue: .main) {
            print("before update")
            self.update_data()
        }
        
        
        bookmarkedPosts = []
        getBookmarkedPosts(){
            print(self.bookmarkedPosts)
            if(self.bookmarkedPosts.contains(self.titl)) {
                print("is bookmarked")
                self.bookmarkButtonUI.setImage(UIImage(named: "bookmark filled"), for: .normal)
            }
            else {
                print("is not bookmarked")
                self.bookmarkButtonUI.setImage(UIImage(named: "bookmark-50"), for: .normal)
            }
        }
    }
    
    func update_data() {
        print("Data Reloaded")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func ApplyToPostingClicked(_ sender: Any){
        self.performSegue(withIdentifier: "applyToPost", sender: self)
    }
    
    //post is bookmarked/unbookmarked when button is pressed
    @IBAction func bookmarkButton(_ sender: Any) {
        var bookmark_url : URL!
        if(bookmarkedPosts.contains(titl)) {
            bookmark_url = URL(string: "https://pearingup.herokuapp.com/unBookmarkPost/" + User.Data.username + "/" + titl)!
            bookmarkButtonUI.setImage(UIImage(named: "bookmark-50"), for: .normal)
        }
        else {
            bookmark_url = URL(string: "https://pearingup.herokuapp.com/bookmarkPost/" + User.Data.username + "/" + titl)!
            bookmarkButtonUI.setImage(UIImage(named: "bookmark filled"), for: .normal)
            }
        Alamofire.request(bookmark_url, method: .get).responseJSON {
            response in
            if(response.result.isSuccess){
                print(response.result.value)
            }
            else{
                print("error")
            }
        }
    }
    
    // Retrieve list of bookmarked posts from server
    func getBookmarkedPosts(completionHandler : @escaping ()->()) {
        
        let url : URL = URL(string: "https://pearingup.herokuapp.com/" + User.Data.username + "/getBookmarkedPosts")!
        
        self.myGroup.enter()
        
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if(response.result.isSuccess){
                let bkPosts : JSON = JSON(response.result.value!)
                if(bkPosts["result"].count > 0) {
                    for i in 0...(bkPosts["result"].count-1) {
                        self.bookmarkedPosts.append(bkPosts["result"][i]["title"].stringValue)
                    }
                }
                self.myGroup.leave()
                completionHandler()
            }
            else {
                print("error")
                self.myGroup.leave()
            }
        }
    }
    
    // pass data to apply to sendrequestviewcontroller so when you
    // press the back button all the data is still there in this view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "applyToPost" {
            
            let destination = segue.destination as! SendRequestViewController
            destination.receiverName = self.owner
            destination.desc = self.desc
            destination.titl = self.titl
            destination.fruitnme = self.fruitnme
            destination.image = self.image
            destination.loca = self.loca
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

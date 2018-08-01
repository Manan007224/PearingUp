//
//  yourPostsViewController.swift
//  Pearing_Up
//
//  Created by yoshiumw on 7/17/18.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class yourPostsViewController: UIViewController, UICollectionViewDataSource {

    
    
    @IBAction func goBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }

    let bookmarks_url : URL = URL(string: "https://pearingup.herokuapp.com/manan/savedposts")!
    let posts_url : URL = URL(string: "https://pearingup.herokuapp.com/getpost/apple_post")!
    var postTitles : [String] = []
    var postAdditionalMsgs : [String] = []
    var postFruits: [String] = []
    var postCities : [String] = []
    var postIDs : [String] = []
    var postImages : [UIImage] = []
    var postCount : Int = 0
    var booleann : Int = 1
    
    // needsUpdate will indicate to viewWillAppear() if the view needs to be reloaded
    static var needsUpdate : Bool!
    

    @IBOutlet weak var tableView: UICollectionView!
    let myGroup = DispatchGroup()

    
    override func viewDidLoad() {
        // print("yolo")
        super.viewDidLoad()
        
        
        print("boolean value:")
        print(booleann)
        
        yourPostsViewController.needsUpdate = false
        
        // Clear table when reloaded
        postTitles = []
        postAdditionalMsgs = []
        postFruits = []
        postCities = []
        postIDs = []
        postImages = []
        postCount = 0
        let all_titles_url : URL = URL(string: "https://pearingup.herokuapp.com/allPosts")!
        get_titles(url: all_titles_url)
        
        myGroup.notify(queue: .main) {
            print("before update")
            //print(self.postImages.count)
            self.tableView.isUserInteractionEnabled = true
            print("enable")
            self.update_data()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(yourPostsViewController.needsUpdate) {
            print("disable")
            self.tableView.isUserInteractionEnabled = false
            viewDidLoad()
        }
    }
    
    public static func setNeedsUpdate(needsUpdate : Bool) {
        self.needsUpdate = needsUpdate
    }
    
    // Get all information for each post
    func get_titles(url: URL){
        
        self.myGroup.enter()
        Alamofire.request(url, method: .get).responseJSON { response in
            
            if( response.result.isSuccess){
                let temp : JSON = JSON(response.result.value!)
                let posts : JSON = temp["Posts"]
                print(posts)
                
                self.postCount = 0
                for i in 0...(posts.count - 1){
                    if(posts[i]["owner"].stringValue == User.Data.username){

                        self.getimage( title: posts[i]["title"].stringValue) { 

                            self.postTitles.append( posts[i]["title"].stringValue)
                            self.postAdditionalMsgs.append(posts[i]["additional_msg"].stringValue )
                            self.postFruits.append(posts[i]["info"]["fruits"].stringValue )
                            self.postIDs.append(posts[i]["img_id"].stringValue)
                        }
                        self.postCount = self.postCount + 1
                    }
                }
                self.myGroup.leave()
            }
            else{
                /// print(response.result.error!)
                self.myGroup.leave()
            }
        }
    }
    
    // Get corresponding image per post
    func getimage(title: String, completionHandler : @escaping ()->Void) {
        self.myGroup.enter()
        let urlstring = "https://pearingup.herokuapp.com/getpost/" + title
        print(urlstring)
        let image_url : URL = URL(string: urlstring)!
        
        Alamofire.request(image_url, method: .get).responseString {
            response in
            if(response.result.isSuccess) {
                print("get image function")
                
                let postImg = UIImage(data: response.data!)
                self.postImages.append(postImg!)
                
                self.myGroup.leave()
                completionHandler()
            }
            else {
                print(response.result.error!)
                self.myGroup.leave()
            }
        }
    }
    
    // Reloads table view with all posts
    func update_data() {
        
        self.tableView.dataSource = self
        self.tableView.reloadData()
        print("Data Reloaded")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("click")
        self.performSegue(withIdentifier: "goToEditPosts", sender: indexPath)
        
    }
    
    // passes data to next controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("clicker")
        if segue.identifier == "goToEditPosts" {
            if let collectionCell: yourPostsCell = sender as? yourPostsCell {
                if let collectionView: UICollectionView = collectionCell.superview as? UICollectionView {
                    
                    if let destination = segue.destination as? editPostsViewController {
                        // Pass some data to YourViewController
                        // collectionView.tag will give your selected tableView index
                        destination.owner = User.Data.username
                        
                        if let selectedindexpath = collectionView.indexPathsForSelectedItems?.first {
                            
                            destination.titl = postTitles[selectedindexpath.row]
                            destination.desc = postAdditionalMsgs[selectedindexpath.row]
                            destination.fruitnme = postFruits[selectedindexpath.row]
                            destination.idee = postIDs[selectedindexpath.row]
                            destination.image = postImages[selectedindexpath.row]
                            print(postTitles[selectedindexpath.row] + " " + postIDs[selectedindexpath.row])
                            
                        }
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return postCount
    }
    
    // Load post details into cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let saved_posts = collectionView.dequeueReusableCell(withReuseIdentifier: "your_posts_cell", for: indexPath) as! yourPostsCell
        
        saved_posts.layer.shadowRadius = 5.0
        saved_posts.layer.masksToBounds = false
        saved_posts.layer.shadowOpacity = 1.0
        saved_posts.layer.shadowOffset = CGSize.zero
        saved_posts.layer.cornerRadius = 10.0
//        saved_posts.layer.borderColor = UIColor.black.cgColor
//        saved_posts.layer.borderWidth = 2
        saved_posts.post_fruit.text! = postFruits[indexPath.item]
        saved_posts.post_description.text! = postAdditionalMsgs[indexPath.item]
        saved_posts.post_title.text! = postTitles[indexPath.item].replacingOccurrences(of: "_", with: " ")
        saved_posts.post_image.layer.cornerRadius = 5.0
        saved_posts.post_image.clipsToBounds = true
        saved_posts.post_image.image = postImages[indexPath.item]
        
        return saved_posts
    }
    
    func displayAlert(message: String){
        let alert_toDisplay = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert_toDisplay.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            print("Error")
        }));
        self.present(alert_toDisplay, animated: true, completion: nil)
    }

}

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
    //var postImages : [UIImage] = []
    var postCount : Int = 0
    var allposts : [PostObject] = []
    var booleann : Int = 1
    
    @IBOutlet weak var saved_posts: UICollectionView!
    let myGroup = DispatchGroup()

    override func viewDidLoad() {
        // print("yolo")
        super.viewDidLoad()
        print("boolean value:")
        print(booleann)
        
        let all_titles_url : URL = URL(string: "https://pearingup.herokuapp.com/allPosts")!
        get_titles(url: all_titles_url)
        
        myGroup.notify(queue: .main) {
            print("before update")
            //print(self.postImages.count)
            self.update_data()
        }
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    
    
    
    func get_titles(url: URL){
        
        self.myGroup.enter()
        Alamofire.request(url, method: .get).responseJSON { response in
            
            if( response.result.isSuccess){
                let temp : JSON = JSON(response.result.value!)
                let posts : JSON = temp["Posts"]
                print(posts)
                
                self.postCount = posts.count
                var count = 0
                
                for i in 0...(self.postCount-1){
                    var post : PostObject = PostObject.init()
                    let info : JSON = posts[i]["info"]
                    if(posts[i]["owner"].stringValue == User.Data.username){
                        post.title = posts[i]["title"].stringValue
                        print("title " + post.title)
                        post.additional_msg = posts[i]["additional_msg"].stringValue
                        post.id = posts[i]["id"].stringValue
                        post.img_id = posts[i]["img_id"].stringValue
                        post.owner = posts[i]["owner"].stringValue
                        post.fruit = info["fruits"].stringValue
                        count = count + 1
                        self.allposts.append(post)
                    }
                }
                /*
                 var additional_msg : String = ""
                 var id : String = ""
                 var img_id: String = ""
                 var owner : String = ""
                 var title : String = "" */
                
                //let image_url : URL = URL(string: "https://pearingup.herokuapp.com/getpost" + title)!
                //getimage(url_image)
                // self.prepareArrays()
                self.myGroup.leave()
                self.myGroup.enter()
                if (count > 0){
                    
                    for i in 0...(count-1) {
                        
                        self.postTitles.append( self.allposts[i].title )
                        self.postAdditionalMsgs.append(self.allposts[i].additional_msg )
                        self.postFruits.append( self.allposts[i].fruit )
                        self.postIDs.append(self.allposts[i].img_id)
                        
                        
                        //print(self.postTitles[i])
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
    
    
    // Reloads table view with all posts
    func update_data() {
        
        self.saved_posts.dataSource = self
        self.saved_posts.reloadData()
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
                            print(postTitles[selectedindexpath.row] + " " + postIDs[selectedindexpath.row])
                            
                        }
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return allposts.count
    }
    
    
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
        saved_posts.post_title.text! = postTitles[indexPath.item]
        
        
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

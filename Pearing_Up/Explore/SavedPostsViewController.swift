//
//  SavedPostsViewController.swift
//  Pearing_Up
//
//  Created by Manan Maniyar on 2018-06-30.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//
/*
 data that is received
 */

import UIKit
import Alamofire
import SwiftyJSON

class SavedPostsViewController: UIViewController, UICollectionViewDataSource{
    
    let bookmarks_url : URL = URL(string: "https://pearingup.herokuapp.com/manan/savedposts")!
    let posts_url : URL = URL(string: "https://pearingup.herokuapp.com/getpost/apple_post")!
    var postTitles : [String] = []
    var postAdditionalMsgs : [String] = []
    var postFruits: [String] = []
    var postOwners: [String] = []
    var postCities : [String] = []
    var postImages : [UIImage] = []
    var postCount : Int = 0
    var allposts : [PostObject] = []
    var booleann : Int = 1
    var selectedRow = -1
    
    @IBOutlet weak var saved_posts: UICollectionView!
    let myGroup = DispatchGroup()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("boolean value:")
        print(booleann)
       /*
        UIApplication.shared.statusBarStyle = .default
        
        let all_titles_url : URL = URL(string: "https://pearingup.herokuapp.com/allPosts")!
        get_titles(url: all_titles_url)
        
        myGroup.notify(queue: .main) {
            print("before update")
            print(self.postImages.count)
            self.update_data()
        }
        
        */
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        UIApplication.shared.statusBarStyle = .default
        
        let all_titles_url : URL = URL(string: "https://pearingup.herokuapp.com/allPosts")!
        get_titles(url: all_titles_url)
        
        myGroup.notify(queue: .main) {
            print("before update")
            print(self.postImages.count)
            self.update_data()
        }
    }
    
    func getimage(title: String){
        var imgdata : UIImage
        
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
            }
            else {
                print(response.result.error!)
                self.myGroup.leave()
            }
        }
    }
    
    
    func bookmarkPost(url: URL){
        Alamofire.request(url, method: .post).responseJSON { response in
            
        }
    }
    
    @IBAction func bookmarkButton(_ sender: Any) {
        displayAlert(message: "Post bookmarked.")
    }
    
    
    func get_titles(url: URL){
        
        self.myGroup.enter()
        Alamofire.request(url, method: .get).responseJSON { response in
            
            if( response.result.isSuccess){
                let temp : JSON = JSON(response.result.value!)
                let posts : JSON = temp["Posts"]
                print(posts)
               
                self.postCount = posts.count
                for i in 0...(self.postCount-1){
                   // print("-----hello-----")
                    var post : PostObject = PostObject.init()
                    let info : JSON = posts[i]["info"]
                    post.title = posts[i]["title"].stringValue
                    post.additional_msg = posts[i]["additional_msg"].stringValue
                    post.id = posts[i]["id"].stringValue
                    post.img_id = posts[i]["img_id"].stringValue
                    post.owner = posts[i]["owner"].stringValue
                    post.fruit = info["fruits"].stringValue
                    self.getimage( title: posts[i]["title"].stringValue)
                    self.allposts.append(post)
                }
                self.myGroup.leave()
                self.myGroup.enter()
                
                for i in 0...(self.postCount-1) {
                    
                    self.postTitles.append( self.allposts[i].title )
                    self.postAdditionalMsgs.append(self.allposts[i].additional_msg )
                    self.postFruits.append( self.allposts[i].fruit )
                    self.postOwners.append(self.allposts[i].owner)
                }
                
                self.myGroup.leave()
            }
            else{
                self.myGroup.leave()
            }
        }
    }
    
 
    
    func update_data() {
        
        self.saved_posts.dataSource = self
        //bookmarked_posts.reloadData()
        print("Data Reloaded")
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("click")
        self.performSegue(withIdentifier: "contentVideoSegue", sender: indexPath)
    }
    
    // passes data to next controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "expandPost" {
            if let collectionCell: SavedPostsCell = sender as? SavedPostsCell {
                if let collectionView: UICollectionView = collectionCell.superview as? UICollectionView {
                   
                    if let destination = segue.destination as? ExpandedPostViewController {
                        // Pass some data to YourViewController
                        // collectionView.tag will give your selected tableView index
                        destination.owner = User.Data.username
                        
                        if let selectedindexpath = collectionView.indexPathsForSelectedItems?.first {
                            
                            destination.image = postImages[selectedindexpath.row]
                            destination.owner = postOwners[selectedindexpath.row]
                            destination.titl = postTitles[selectedindexpath.row]
                            destination.desc = postAdditionalMsgs[selectedindexpath.row]
                            destination.fruitnme = postFruits[selectedindexpath.row]
                        }
                    }
                }
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // originally was postTitle.count
        
        return allposts.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let saved_posts = collectionView.dequeueReusableCell(withReuseIdentifier: "saved_posts_cell", for: indexPath) as! SavedPostsCell
        
        saved_posts.layer.shadowRadius = 5.0
        saved_posts.layer.masksToBounds = false
        saved_posts.layer.shadowOpacity = 1.0
       // saved_posts.layer.shadowPath = UIBezierPath.init(rect: saved_posts.bounds).cgPath
        saved_posts.layer.shadowOffset = CGSize.zero
        saved_posts.layer.cornerRadius = 10.0
        saved_posts.post_fruit.text! = postFruits[indexPath.item]
        saved_posts.post_description.text! = postAdditionalMsgs[indexPath.item]
        saved_posts.post_title.text! = postTitles[indexPath.item]
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

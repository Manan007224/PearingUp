//
//  bookmarkedPostsViewController.swift
//  Pearing_Up
//
//  Created by waz on 2018-07-17.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class bookmarkedPostsViewController: UIViewController, UICollectionViewDataSource {
    
    
    let myGroup = DispatchGroup()
    @IBOutlet weak var bookmar_posts: UICollectionView!
    var bookmarkedTitles: [String] = []
    
    
    // Declaring all the variables from here
    
    var firstStartUp : Bool = true
    var bookmarkTitles : [String] = []
    var bookmarkMsgs : [String] = []
    var bookmarkFruits : [String] = []
    var bookmarkCities : [String] = []
    var bookmarkImages : [UIImage] = []
    var bookmarkOwners : [String] = []
    var bookmarkedPosts : [String] = []
    var bookmarkPostsCount: Int = 0;

    override func viewDidLoad() {
        super.viewDidLoad()
        bookmarkTitles = []
        bookmarkMsgs = []
        bookmarkFruits = []
        bookmarkCities = []
        bookmarkImages = []
        bookmarkOwners = []
        bookmarkedPosts = []
        bookmarkPostsCount = 0

        let bookmarks_url : URL = URL(string: "https://pearingup.herokuapp.com/" + User.Data.username + "/getBookmarkedPosts")!

        
        getBookmarkedPosts(url: bookmarks_url)
        myGroup.notify(queue: .main){
            self.update_data()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // We want to reload the page whenever it is visited, instead of only on first visit
        if(!firstStartUp) {
            print("Not first start up")
            viewDidLoad()
        }
        else{
            firstStartUp = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func update_data(){
        self.bookmar_posts.dataSource = self
        self.bookmar_posts.reloadData()
        print(self.bookmarkImages.count)
    }
    
    func getBookmarkedPosts(url: URL){
        
        // Sending the Alamofire Request to the bookmark posts function
        
        self.myGroup.enter()
        
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if(response.result.isSuccess){
                let bkPosts : JSON = JSON(response.result.value!)
                if(bkPosts["result"].count > 0){
                    for i in 0...(bkPosts["result"].count-1){
                        self.bookmarkMsgs.append(bkPosts["result"][i]["additional_msg"].string!)
                        self.bookmarkFruits.append(bkPosts["result"][i]["info"]["fruits"].string!)
                        self.bookmarkOwners.append(bkPosts["result"][i]["owner"].string!)
                        self.bookmarkTitles.append(bkPosts["result"][i]["title"].string!)
                        self.bookmarkedPosts.append(bkPosts["result"][i]["title"].string!)
                        self.getBookmarkedImages(title: bkPosts["result"][i]["title"].string!)
                    }
                }
                self.myGroup.leave()
            }
            else {
            }
        }
    }
    
    
    func getBookmarkedImages(title: String){
        self.myGroup.enter()
        let urlstring = "https://pearingup.herokuapp.com/getpost/" + title
        let image_url : URL = URL(string: urlstring)!
        Alamofire.request(image_url, method: .get).responseString{
            response in
            if(response.result.isSuccess){
                let bookmarkImg = UIImage(data: response.data!)
                self.bookmarkImages.append(bookmarkImg!)
                self.myGroup.leave()
            }
            else{
                print(response.result.error!)
                self.myGroup.leave()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "expandBookmarkPost" {
            if let collectionCell: bookmarkedPostCell = sender as? bookmarkedPostCell {
                if let collectionView: UICollectionView = collectionCell.superview as? UICollectionView {
                    
                    if let destination = segue.destination as? ExpandedPostViewController {
                        // Pass some data to YourViewController
                        // collectionView.tag will give your selected tableView index                        
                        if let selectedindexpath = collectionView.indexPathsForSelectedItems?.first {
                            
                            destination.image = bookmarkImages[selectedindexpath.row]
                            destination.owner = bookmarkOwners[selectedindexpath.row]
                            destination.titl = bookmarkTitles[selectedindexpath.row]
                            destination.desc = bookmarkMsgs[selectedindexpath.row]
                            destination.fruitnme = bookmarkFruits[selectedindexpath.row]
                        }
                    }
                }
            }
        }
    }
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bookmarkOwners.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let post = collectionView.dequeueReusableCell(withReuseIdentifier: "bookmarked_posts_cell", for: indexPath) as! bookmarkedPostCell
        
        post.layer.shadowRadius = 5.0
        post.layer.masksToBounds = false
        post.layer.shadowOpacity = 1.0
        post.layer.shadowOffset = CGSize.zero
        post.layer.cornerRadius = 10.0
        post.bookmarkCell_description.text! = self.bookmarkMsgs[indexPath.item]
        post.bookmarkcell_title.text! = self.bookmarkTitles[indexPath.item]
        post.bookmarkCell_fruit.text! = self.bookmarkFruits[indexPath.item]
        post.bookmarkCell_Image.image = self.bookmarkImages[indexPath.item]
        
        // Update whether or not post is bookmarked or not

        
        // Button press event listener
        post.buttonAction = { sender in
            if(self.bookmarkedPosts.contains(self.bookmarkTitles[indexPath.item])) {
                self.unBookmarkPost(title: self.bookmarkTitles[indexPath.item])
                post.bookmarkButton.setImage(UIImage(named: "bookmark-50"), for: .normal)
                self.bookmarkedPosts = self.bookmarkedPosts.filter() { $0 != self.bookmarkTitles[indexPath.item]}
            }
            else {
                self.bookmarkPost(title: self.bookmarkTitles[indexPath.item])
                post.bookmarkButton.setImage(UIImage(named: "bookmark filled"), for: .normal)
                self.bookmarkedPosts.append(self.bookmarkTitles[indexPath.item])
            }
        }
        
        return post
    }
    
    // Send request to server to bookmark titled post
    func bookmarkPost(title: String){
        myGroup.enter()
        let url : URL = URL(string: "https://pearingup.herokuapp.com/bookmarkPost/" + User.Data.username + "/" + title)!
        
        Alamofire.request(url, method: .get).responseJSON { response in
            if(response.result.isSuccess){
                print(title + " Successfully Bookmarked")
                self.myGroup.leave()
            }
            else {
                print("error")
            }
        }
    }
    
    // Send request to server to unbookmark titled post
    func unBookmarkPost(title: String) {
        myGroup.enter()
        let url : URL = URL(string: "https://pearingup.herokuapp.com/unBookmarkPost/" + User.Data.username + "/" + title)!
        
        Alamofire.request(url, method: .get).responseJSON { response in
            if(response.result.isSuccess){
                print(title + "Successfully Unbookmarked")
                self.myGroup.leave()
            }
            else {
                print("error")
            }
        }
    }
 
}

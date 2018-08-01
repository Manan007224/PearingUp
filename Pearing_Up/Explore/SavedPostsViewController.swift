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
    
    var firstStartUp : Bool  = true
    var changedViewMode : Bool = false

    
    let bookmarks_url : URL = URL(string: "https://pearingup.herokuapp.com/manan/savedposts")!
    let posts_url : URL = URL(string: "https://pearingup.herokuapp.com/getpost/apple_post")!
    
    var postTitles : [String] = []
    var bookmarkedPosts : [String] = []
    var postAdditionalMsgs : [String] = []
    var postFruits: [String] = []
    var postOwners: [String] = []
    var postCities : [String] = []
    var postImages : [UIImage] = []
    
    var didSearch : Bool = false
    var searchQuery : String = ""
    
    var searchOwners: [String] = []
    var searchTitles : [String] = []
    var searchFruits : [String] = []
    var searchAdditionalMsgs : [String] = []
    var searchCities : [String] = []
    var searchImages : [UIImage] = []
    
    var postCount : Int = 0
    var booleann : Int = 1
    var selectedRow = -1
    
    @IBOutlet weak var saved_posts: UICollectionView!
    let myGroup = DispatchGroup()
    
    @IBOutlet weak var behindSearchView: UIView!
    @IBOutlet weak var behindButton: UIView!
    @IBOutlet weak var searchtext: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("disable")
        self.saved_posts.isUserInteractionEnabled = false
        UIApplication.shared.statusBarStyle = .default
        
        
        let tabBarControllerItems = self.tabBarController?.tabBar.items
        
        if let tabArray = tabBarControllerItems {
            let tabBarItem1 = tabArray[0]
            tabBarItem1.isEnabled = false
        }
        
        print("LOOK AT ME: ", changedViewMode)
        if(!changedViewMode) {
            didSearch = false
            
            postTitles = []
            bookmarkedPosts = []
            postAdditionalMsgs = []
            postFruits = []
            postCities = []
            postImages = []
            postOwners = []
            postCount = 0
            let all_titles_url : URL = URL(string: "https:pearingup.herokuapp.com/allPosts")!
            getPosts(url: all_titles_url)
        }
        else {
            changedViewMode = false
            searchtext.text = searchQuery
        }
        
        behindSearchView.layer.shadowRadius = 2.5
        behindSearchView.layer.masksToBounds = false
        behindSearchView.layer.shadowOpacity = 1.0
        behindSearchView.layer.shadowOffset = CGSize.zero
        behindSearchView.layer.cornerRadius = 10.0
        
        behindButton.layer.cornerRadius = 5.0
        behindButton.layer.shadowRadius = 2.5
        behindButton.layer.masksToBounds = false
        behindButton.layer.shadowOpacity = 1.0
        behindButton.layer.shadowOffset = CGSize.zero
        
        myGroup.notify(queue: .main) {
            print("before update")
            self.saved_posts.isUserInteractionEnabled = true
            print("enable")
            print(self.postImages.count)
            self.update_data()
        }
        
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchtext.text! = ""
        
        let tabBarControllerItems = self.tabBarController?.tabBar.items
        
        if let tabArray = tabBarControllerItems {
            let tabBarItem1 = tabArray[0]
            tabBarItem1.isEnabled = false
            tabBarItem1.badgeColor = UIColor.green
        }
        
        // We want to reload the page whenever it is visited, instead of only on first visit
        if(!firstStartUp) {
            print("Not first start up")
            viewDidLoad()
        }
        else{
            firstStartUp = false
        }
        
        self.tabBarController?.tabBar.isHidden = false

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let tabBarControllerItems = self.tabBarController?.tabBar.items
        
        if let tabArray = tabBarControllerItems {
            let tabBarItem1 = tabArray[0]
            tabBarItem1.isEnabled = true
        }
    }
    func update_data() {
        
        self.saved_posts.dataSource = self
        self.saved_posts.reloadData()
        print("Data Reloaded")
    }
    
    // Retrieve list of posts from server
    func getPosts(url: URL) {
        
        self.myGroup.enter()
        Alamofire.request(url, method: .get).responseJSON { response in
            
            if( response.result.isSuccess){
                let temp : JSON = JSON(response.result.value!)
                let posts : JSON = temp["Posts"]
                print(posts)
                self.postCount = posts.count
                if (self.postCount > 0){
                    for i in 0...(self.postCount-1){
                        self.getImage( title: posts[i]["title"].stringValue) {
                            self.postTitles.append( posts[i]["title"].stringValue )
                            self.postAdditionalMsgs.append(posts[i]["additional_msg"].stringValue )
                            self.postFruits.append(posts[i]["info"]["fruits"].stringValue )
                            self.postOwners.append(posts[i]["owner"].stringValue)
                            self.postCities.append(posts[i]["location_p"].stringValue  )
                            self.getBookmarkedPosts()
                        }
                    }
                }
                self.myGroup.leave()
        
        }
            else{
                self.myGroup.leave()
            }
        }
    }
    
    // Retrieve image for correspoding titled post from server
    func getImage(title: String, completionHandler : @escaping ()->Void){
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

    // Retrieve list of booksmarked posts from server
    func getBookmarkedPosts() {
        self.myGroup.enter()
        
        let url : URL = URL(string: "https://pearingup.herokuapp.com/" + User.Data.username + "/getBookmarkedPosts")!
        
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
            }
            else {
                print("error")
            }
        }
    }
    
    
    @IBAction func searchButton(_ sender: Any) {
        if (!(searchtext.text?.isEmpty)!) {
            // array of indices that contains the search word
            var ind : [Int] = []
            
            searchTitles = []
            searchFruits = []
            searchAdditionalMsgs = []
            searchCities = []
            searchOwners = []
            searchImages = []
            
            check(data: postFruits, indices:  &ind,srchtxt:  searchtext.text!);
            check(data: postCities, indices: &ind, srchtxt: searchtext.text!);
            check(data: postAdditionalMsgs, indices: &ind, srchtxt: searchtext.text!);
            check(data: postTitles, indices: &ind, srchtxt: searchtext.text!);
            
            // update post count
            postCount = ind.count
            
            for val in ind {
                searchTitles.append(postTitles[val] )
                searchFruits.append(postFruits[val])
                searchAdditionalMsgs.append(postAdditionalMsgs[val] )
                searchCities.append(postCities[val] )
                searchOwners.append(postOwners[val])
                searchImages.append(postImages[val])
                
            }
            didSearch = true
        }
        else {
            // If there are no inputs, just reload the data with all posts
            postCount = postTitles.count
            didSearch = false
        }
        update_data()
    }
    
    
    // goes through data arary and if srchtxt is found put the index into indices array if it
    // does not already exists in there
    func check(data: [String], indices: inout [Int], srchtxt: String) {
        
        
        var lowerData : [String] = []
        
        if(data.count > 0) {
            
            for i in 0...(data.count-1) {
                
                lowerData.append(data[i].lowercased())
                
                if (lowerData[i].range(of: srchtxt.lowercased()) != nil) {
                    if ( indices.contains(i) == false ){
                        
                        indices.append(i);
                    }
                }
            }
        }
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
                            if(!didSearch) {
                                destination.image = postImages[selectedindexpath.row]
                                print("post owners" , postOwners)
                                destination.owner = postOwners[selectedindexpath.row]
                                destination.titl = postTitles[selectedindexpath.row]
                                destination.desc = postAdditionalMsgs[selectedindexpath.row]
                                destination.fruitnme = postFruits[selectedindexpath.row]
                                destination.loca = postCities[selectedindexpath.row]
                            }
                            else {
                                destination.image = searchImages[selectedindexpath.row]
                                destination.owner = searchOwners[selectedindexpath.row]
                                destination.titl = searchTitles[selectedindexpath.row]
                                destination.desc = searchAdditionalMsgs[selectedindexpath.row]
                                destination.fruitnme = searchFruits[selectedindexpath.row]
                                destination.loca = searchCities[selectedindexpath.row]
                            }
                        }
                    }
                }
            }
        }
        if segue.identifier == "listToCard" {
             if let destination = segue.destination as? SecondaryViewController {
                print("transition")
                
                destination.changedViewMode = true
                
                destination.postCount = self.postCount
                destination.postTitles = self.postTitles
                destination.bookmarkedPosts = self.bookmarkedPosts
                destination.postAdditionalMsgs = self.postAdditionalMsgs
                destination.postOwners = self.postOwners
                destination.postFruits = self.postFruits
                destination.postCities = self.postCities
                destination.postImages = self.postImages
                destination.didSearch = self.didSearch
                destination.searchTitles = self.searchTitles
                destination.searchAdditionalMsgs = self.searchAdditionalMsgs
                destination.searchOwners = self.searchOwners
                destination.searchFruits = self.searchFruits
                destination.searchCities = self.searchCities
                destination.searchImages = self.searchImages
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // originally was postTitle.count
        
        return postCount
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let post = collectionView.dequeueReusableCell(withReuseIdentifier: "saved_posts_cell", for: indexPath) as! SavedPostsCell
        
        post.layer.shadowRadius = 5.0
        post.layer.masksToBounds = false
        post.layer.shadowOpacity = 1.0
        post.layer.shadowOffset = CGSize.zero
        post.layer.cornerRadius = 10.0
        
        if(didSearch) {
            post.post_fruit.text! = searchFruits[indexPath.item]
            post.post_description.text! = searchAdditionalMsgs[indexPath.item]
            post.post_title.text! = (searchTitles[indexPath.item].replacingOccurrences(of: "_", with: " ")).capitalized
            post.post_city.text! = (searchCities[indexPath.item]).capitalized
            
            post.post_image.image = searchImages[indexPath.item]
        }
        else {
            post.post_fruit.text! = postFruits[indexPath.item]
            post.post_description.text! = postAdditionalMsgs[indexPath.item]
            post.post_title.text! = (postTitles[indexPath.item].replacingOccurrences(of: "_", with: " ")).capitalized
            post.post_city.text! = (postCities[indexPath.item]).capitalized
            
            post.post_image.image = postImages[indexPath.item]
        }
        
        
        post.post_image.layer.cornerRadius = 5.0
        post.post_image.clipsToBounds = true
        // Update whether or not post is bookmarked or not
        if(self.bookmarkedPosts.contains(self.postTitles[indexPath.item])) {
            post.bookmarkButton.setImage(UIImage(named: "bookmark filled"), for: .normal)
        }
        else {
            post.bookmarkButton.setImage(UIImage(named: "bookmark-50"), for: .normal)
        }
        
        // Button press event listener
        post.buttonAction = { sender in
            if(self.bookmarkedPosts.contains(self.postTitles[indexPath.item])) {
                self.unBookmarkPost(title: self.postTitles[indexPath.item])
                post.bookmarkButton.setImage(UIImage(named: "bookmark-50"), for: .normal)
                self.bookmarkedPosts = self.bookmarkedPosts.filter() { $0 != self.postTitles[indexPath.item]}
            }
            else {
                self.bookmarkPost(title: self.postTitles[indexPath.item])
                post.bookmarkButton.setImage(UIImage(named: "bookmark filled"), for: .normal)
                self.bookmarkedPosts.append(self.postTitles[indexPath.item])
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
 
    @IBAction func switchViews(_ sender: Any) {
        //self.performSegue(withIdentifier: "listToCard", sender: self)
    }

    func displayAlert(message: String){
        let alert_toDisplay = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert_toDisplay.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            print("Error")
        }));
        self.present(alert_toDisplay, animated: true, completion: nil)
    }

}

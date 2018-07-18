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
    
    let bookmarks_url : URL = URL(string: "https://pearingup.herokuapp.com/said/getBookmarkedPosts")!
    var bookmarkTitles : [String] = []
    var bookmarkMsgs : [String] = []
    var bookmarkFruits : [String] = []
    var bookmarkCities : [String] = []
    var bookmarkImages : [UIImage] = []
    var bookmarkOwners : [String] = []
    var bookmarkPostsCount: Int = 0;

    override func viewDidLoad() {
        super.viewDidLoad()
        getBookmarkedPosts(url: bookmarks_url)
        myGroup.notify(queue: .main){
            self.update_data()
        }
    }
    
    func update_data(){
        self.bookmar_posts.dataSource = self
        print(self.bookmarkImages.count)
    }
    
    func getBookmarkedPosts(url: URL){
        
        // Sending the Alamofire Request to the bookmark posts function
        
        self.myGroup.enter()
        
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if(response.result.isSuccess){
                let bkPosts : JSON = JSON(response.result.value!)
                for i in 0...(bkPosts["result"].count-1){
                    self.bookmarkMsgs.append(bkPosts["result"][i]["additional_msg"].string!)
                    self.bookmarkFruits.append(bkPosts["result"][i]["info"]["fruits"].string!)
                    self.bookmarkOwners.append(bkPosts["result"][i]["owner"].string!)
                    self.bookmarkTitles.append(bkPosts["result"][i]["title"].string!)
                    self.getBookmarkedImages(title: bkPosts["result"][i]["title"].string!)
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
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bookmarkOwners.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bookmarked_posts = collectionView.dequeueReusableCell(withReuseIdentifier: "bookmarked_posts_cell", for: indexPath) as! bookmarkedPostCell
        bookmarked_posts.bookmarkCell_description.text! = self.bookmarkMsgs[indexPath.item]
        bookmarked_posts.bookmarkcell_title.text! = self.bookmarkTitles[indexPath.item]
        bookmarked_posts.boomarkCell_fruit.text! = self.bookmarkFruits[indexPath.item]
        bookmarked_posts.bookmarkCell_Image.image = self.bookmarkImages[indexPath.item]
        return bookmarked_posts
    }
 
}

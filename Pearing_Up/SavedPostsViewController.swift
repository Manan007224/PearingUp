//
//  SavedPostsViewController.swift
//  Pearing_Up
//
//  Created by Manan Maniyar on 2018-06-30.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SavedPostsViewController: UIViewController, UICollectionViewDataSource{
    
    let bookmarks_url : URL = URL(string: "https://pearingup.herokuapp.com/manan/savedposts")!
    let posts_url : URL = URL(string: "https://pearingup.herokuapp.com/getpost/apple_post")!
    var postsTitles : [String] = []
    var postAdditionalMsgs : [String] = []
    var postFruits: [String] = []
    var postCities : [String] = []
    var postImages : [UIImage] = []
    let tArray = ["A", "B", "C", "D", "E"]
    var posts_name : [String]  = []
    let temp_posts = ["apple_post", "banana_post"]
    let tImage = [UIImage(named: "tree"), UIImage(named: "tree1"), UIImage(named: "tree2"), UIImage(named: "tree2"), UIImage(named: "tree")]
    let tDescription = ["A", "B", "C", "D", "E"]
    let tFruits = ["Apples", "Bananas", "Kiwi", "Oranges", "Pineapple"]
    let tCity = ["Vancouver", "Burnaby", "Surrey", "Coquitlam", "Richmond"]
    
    @IBOutlet weak var bookmarked_posts: UICollectionView!
    
    let myGroup = DispatchGroup()
    
    override func viewDidLoad() {
        print("yolo")
        super.viewDidLoad()
        bookmarked_posts.dataSource = self
        get_bookmarks(url: bookmarks_url)
        get_allPosts() { data in
            
        }
        
//        get_allDetails() { data in
//
//        }
        myGroup.notify(queue: .main) {
            self.update_data()
            print("All Done")
        }
        
    }
    
    func update_data() {
        print("Reached this Function")
        bookmarked_posts.reloadData()
    }
    
    func get_allPosts(completed: @escaping (String) -> Void) {
        self.myGroup.enter()
        print("Reached allPosts function")
        for pst in temp_posts {
          let p_url : URL = URL(string: "https://pearingup.herokuapp.com/getpost/apple_post")!
          self.request_posts(url: p_url)
        }
        self.myGroup.leave()
    }
    
    func get_allDetails(completed: @escaping (String) -> Void) {
        self.myGroup.enter()
        print("Reached Get all Details")
        for pst in temp_posts {
              let p_url : URL = URL(string: "https://pearingup.herokuapp.com/getpost/getPostsData/apple_post")!
              self.request_posts(url: p_url)
        }
        self.myGroup.leave()
    }
    
    
    func request_posts(url : URL) {
        print("Reached inside request_post")
            self.myGroup.enter()
            Alamofire.request(url, method: .get).responseString {
                response in
                if(response.result.isSuccess) {
                   let temp : JSON = JSON(response.result.value!)
                    print("Success in get-posts route")
                    self.postsTitles.append("A")
                    self.postAdditionalMsgs.append("A")
                    self.postFruits.append("A")
                    self.postCities.append("Vancouver")
                    print(response.data!)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "contentVideoSegue", sender: indexPath)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "expandPost" {
            if let collectionCell: SavedPostsCell = sender as? SavedPostsCell {
                if let collectionView: UICollectionView = collectionCell.superview as? UICollectionView {
                    if let destination = segue.destination as? ExpandedPostViewController {
                        // Pass some data to YourViewController
                        // collectionView.tag will give your selected tableView index
                        destination.owner = "manan"
                    }
                }
            }
        }
    }
    
//    func request_postsData(url: URL) {
//        self.myGroup.enter()
//        Alamofire.request(url, method: .get).responseString {
//            response in
//            if(response.result.isSuccess) {
//                let temp: JSON = JSON(response.result.value!)
//                self.postsTitles.append(temp["title"].string!)
//                self.postFruits.append(temp["fruits"].string!)
//                self.postAdditionalMsgs.append(temp["description"].string!)
//                self.postCities.append("Vancouver")
//                self.myGroup.leave()
//
//            }
//            else {
//                print("Error")
//                self.myGroup.leave()
//            }
//        }
//    }
    
    
    func request_Bookmarks(url: URL, completion : @escaping (JSON) -> Void) {
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if(response.result.isSuccess) {
                let temp : JSON = JSON(response.result.value!)
                print("Success in the get-saved-posts route")
                //print(response.result!)
                completion(temp)
            }
            else {
                print("Error happened")
                completion(response.result.error! as! JSON)
            }
        }
    }
 
    
    func get_bookmarks(url: URL) {
        self.myGroup.enter()
        print("Came at get_bookmarks")
        self.myGroup.leave()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postCities.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let saved_posts = collectionView.dequeueReusableCell(withReuseIdentifier: "saved_posts_cell", for: indexPath) as! SavedPostsCell
        saved_posts.post_image.image = postImages[indexPath.row]
        saved_posts.post_city.text! = postCities[indexPath.item]
        saved_posts.post_fruit.text! = postFruits[indexPath.item]
        saved_posts.post_description.text! = postAdditionalMsgs[indexPath.item]
        saved_posts.post_title.text! = postsTitles[indexPath.item]
        
     //   saved_posts.postImage.image = postImages[indexPath.row]
//        saved_posts.postCity.text! = postCities[indexPath.item]
  //      saved_posts.postFruit.text! = postFruits[indexPath.item]
//        saved_posts.postDescription.text! = postAdditionalMsgs[indexPath.item]
  //      saved_posts.postTitle.text! = postsTitles[indexPath.item]
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









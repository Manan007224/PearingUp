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
    var posts_city : [String] = []
    let tArray = ["A", "B", "C", "D", "E"]
    var posts_name : [String]  = []
    let temp_posts = ["apple_post", "banana_post"]
    let tImage = [UIImage(named: "tree"), UIImage(named: "tree1"), UIImage(named: "tree2"), UIImage(named: "tree2"), UIImage(named: "tree")]
    let tDescription = ["A", "B", "C", "D", "E"]
    let tFruits = ["Apples", "Bananas", "Kiwi", "Oranges", "Pineapple"]
    let tCity = ["Vancouver", "Burnaby", "Surrey", "Coquitlam", "Richmond"]
    
    @IBOutlet weak var bookmarked_posts: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookmarked_posts.dataSource = self
        get_bookmarks(url: bookmarks_url) { response in
            let all_posts = response["result"].array
            for posts in all_posts! {
                //print(posts)
                self.posts_name.append(String(describing: posts))
            }
            print(self.posts_name.count)
        }
        update_data() { data in
            print(data)
        }
        
    }
    func update_data(completion : (String) -> Void) {
        print("Here")
        for post in self.posts_name {
            let PostURl : URL = URL(string: "https://pearingup.herokuapp.com/getpost/\(post)")!
            print("Post = ", post)
            self.get_allPosts(url: PostURl) { resp in
                print("Received Response")
                let city = resp["title"].string
                self.posts_city.append(city!)
            }
        }
        completion("Done")
    }

    
    func get_allPosts(url: URL, completion : @escaping (JSON) -> Void) {
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if(response.result.isSuccess) {
                let temp : JSON = JSON(response.result.value!)
                print("Success in get-posts route")
                completion(temp)
            }
            else {
                print(response.result.error!)
                completion("error")
            }
        }
    }
    
 
    
    func get_bookmarks(url: URL, completion : @escaping (JSON) -> Void) {
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
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let saved_posts = collectionView.dequeueReusableCell(withReuseIdentifier: "saved_posts_cell", for: indexPath) as! CollectionViewCell
        saved_posts.postImage.image = tImage[indexPath.row]
        saved_posts.postCity.text! = tCity[indexPath.item]
        saved_posts.postFruit.text! = tFruits[indexPath.item]
        saved_posts.postDescription.text! = tDescription[indexPath.item]
        saved_posts.postTitle.text! = tArray[indexPath.item]
        return saved_posts
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(indexPath.row)
//    }
    
    
    
    func displayAlert(message: String){
        let alert_toDisplay = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert_toDisplay.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            print("Error")
        }));
        self.present(alert_toDisplay, animated: true, completion: nil)
    }

}

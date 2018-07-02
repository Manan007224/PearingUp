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
    
     let myGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookmarked_posts.dataSource = self
        get_bookmarks(url: bookmarks_url)
        myGroup.notify(queue: .main) {
            self.get_allPosts() { data in
                print(data)
            }
        }
        update_data()
    }
    
    
    func update_data() {
        print("JUST_SHOW")
    }
    
    func get_allPosts(completed: @escaping (String) -> Void) {
        print("Reached allPosts function")
        for pst in temp_posts {
          let p_url : URL = URL(string: "https://pearingup.herokuapp.com/getpost/\(pst)")!
            self.request_posts(url: p_url) { data in
                print(data)
                completed("Done with get_all Posts finally")
                print("Coming out now")
            }
        }
       
    }
    
    
    func request_posts(url : URL, completion :@escaping (String) -> Void) {
        print("Reached inside request_post")
            Alamofire.request(url).responseJSON {
                response in
                if(response.result.isSuccess) {
                   let temp : JSON = JSON(response.result.value!)
                    print("Success in get-posts route")
                    completion("Inside request")
                }
                else {
                    print(response.result.error!)
                    completion("Inside request_posts")
                }
            }
    }
    
    
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
    
    
    func displayAlert(message: String){
        let alert_toDisplay = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert_toDisplay.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            print("Error")
        }));
        self.present(alert_toDisplay, animated: true, completion: nil)
    }

}

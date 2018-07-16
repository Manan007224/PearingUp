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
    var postCities : [String] = []
    var postImages : [UIImage] = []
    var postCount : Int = 0
    var allposts : [PostObject] = []
    
    
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
       // print("yolo")
        super.viewDidLoad()
        
        let all_titles_url : URL = URL(string: "https://pearingup.herokuapp.com/allPosts")!
        get_titles(url: all_titles_url)
        
        myGroup.notify(queue: .main) {
            print("before update")
            self.update_data()
        }
        self.tabBarController?.tabBar.isHidden = false
        
    }
    /*
     get post data
     get post image
     put in an array
     
     */
    func get_titles(url: URL){
        
        self.myGroup.enter()
        Alamofire.request(url, method: .get).responseJSON { response in
            
            if( response.result.isSuccess){
                let temp : JSON = JSON(response.result.value!)
                let posts : JSON = temp["Posts"]
               
                self.postCount = posts.count
                print(self.postCount )
                print("=== postcoutn")
                for i in 0...self.postCount{
                    var post : PostObject = PostObject.init()
                    post.title = posts[i]["title"].stringValue
                    post.additional_msg = posts[i]["additional_msg"].stringValue
                    post.id = posts[i]["id"].stringValue
                    post.img_id = posts[i]["img_id"].stringValue
                    post.owner = posts[i]["owner"].stringValue
                    
                   
                    self.allposts.append(post)
                    
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
            }
            else{
                print(response.result.error!)
                self.myGroup.leave()
            }
        }
    }
    
    
     func getimage(url : URL) {
         self.myGroup.enter()
        
        Alamofire.request(url, method: .get).responseJSON {
             response in
             if(response.result.isSuccess) {

                 self.myGroup.leave()
             }
             else {
                 print(response.result.error!)
                 self.myGroup.leave()
             }
         }
     }
 
    
    func update_data() {
        self.bookmarked_posts.dataSource = self
        
        //bookmarked_posts.reloadData()
        print("Data Reloaded")
    }
    
    func prepareArrays(){
        self.myGroup.enter()
        print("fucn collectionview")
        for i in 0...2 {
            postTitles.append( self.allposts[i].title )
            postAdditionalMsgs.append(self.allposts[i].additional_msg)
            print(postTitles[i])
            
            //postFruits.append(self.allposts[i].fruit)
        }
        
        self.myGroup.leave()
    }
    
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
                        destination.owner = "manan"
                        
                        destination.titl = tArray[1]
                        destination.desc = tDescription[1]
                        
                        
                        // pass the values to destination
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
    
    ////////////////////////////
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // originally was postTitle.count
        
        return postTitles.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let saved_posts = collectionView.dequeueReusableCell(withReuseIdentifier: "saved_posts_cell", for: indexPath) as! SavedPostsCell

        
        saved_posts.post_image.image = postImages[indexPath.row]
        saved_posts.post_city.text! = postCities[indexPath.item]
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
/*
 
 /*
 var dic : [String: Any]
 dic = ["code": 200, "Posts":{ ["pickers" : [], "id": "1234567", "info" : [ "id": "1234567", "fruits": "apples" ], "msg" : "yoloway i got cool", "title": "butts", "owner": "saad" ] as [String : Any];
 
 ["pickers" : [], "id": "3456", "info" : [ "id": "3456", "fruits": "banaa" ], "msg" : "hi there i got cool", "title": "legs", "owner": "manan" ] as [String : Any]
 } ]
 */
 
 
 /*
 Alamofire.request(url, method: .get).responseString {
 response in
 if(response.result.isSuccess) {
 //    let temp : Data = JSON(response.result.value!)
 let dacc : Data = Data(response.result.value!)
 
 //let temp : JSON = JSON(response.result.value!
 
 var sJson = JSONSerialization.JSONObjectWithData(temp, options: .MutableContainers) as NSArray
 print(sJson)
 
 /*
 print("    \n    \n        ")
 print(temp)
 var alll = temp["Posts"]
 print("print alll     \n   \n")
 print(alll)
 
 var titl = alll["title"]
 print("printing title  \n")
 print(titl)
 */
 
 //     self.postsTitles.append(temp["title"])
 //   self.postAdditionalMsgs.append(temp["additional_msg"])
 //  var imgid = temp["img_id"]
 
 self.myGroup.leave()
 }
 else {
 print(response.result.error!)
 self.myGroup.leave()
 }
 }*/
 
 */

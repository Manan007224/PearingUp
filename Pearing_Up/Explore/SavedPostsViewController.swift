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
            self.update_data()
        }
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    func getimage(title: String) -> String?{
        var imgdata : String = ""
        
        self.myGroup.enter()
        let urlstring = "https://pearingup.herokuapp.com/getpost/" + title
        print(urlstring)
        let image_url : URL = URL(string: urlstring)!
  
        Alamofire.request(image_url, method: .get).responseString {
            response in
            if(response.result.isSuccess) {
                //let temp : String = String(response.result.value!)
                print("get image function")
                //print(temp)
                
                //let posting = uiimage(response.data!
                /*
                 let temp : JSON = JSON(response.result.value!)
                 let posts : JSON = temp["Posts"]
                 print(posts)
                 */
                //print(response.data!)
                self.myGroup.leave()
            }
            else {
                print(response.result.error!)
                self.myGroup.leave()
            }
        }
        if(imgdata == nil){
            print("yolololololol datta")
        }
        return imgdata
        
    }
    
    
    
    
    func get_titles(url: URL){
        
        self.myGroup.enter()
        Alamofire.request(url, method: .get).responseJSON { response in
            
            if( response.result.isSuccess){
                let temp : JSON = JSON(response.result.value!)
                let posts : JSON = temp["Posts"]
                print(posts)
                //print(info["fruits"])
                
                self.postCount = posts.count
            //    print(self.postCount )
            //    print("=== postcoutn")
                
                for i in 0...(self.postCount-1){
                   // print("-----hello-----")
                    var post : PostObject = PostObject.init()
                    let info : JSON = posts[i]["info"]
                 //   print(posts[i]["title"].stringValue )
                    post.title = posts[i]["title"].stringValue
                    post.additional_msg = posts[i]["additional_msg"].stringValue
                    post.id = posts[i]["id"].stringValue
                    post.img_id = posts[i]["img_id"].stringValue
                    post.owner = posts[i]["owner"].stringValue
                    post.fruit = info["fruits"].stringValue
                    
                    var imgdata  = self.getimage( title: posts[i]["title"].stringValue )
                    if ( imgdata == nil ){
                        print("yoo dayta is nil")
                    }
                    //  post.img =  UIImage(data: imgdata! , scale: 1.0 )!
                    
                    self.allposts.append(post)
                  //  self.booleann = 55
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
                
                for i in 0...(self.postCount-1) {
                    
                    self.postTitles.append( self.allposts[i].title )
                    self.postAdditionalMsgs.append(self.allposts[i].additional_msg )
                    self.postFruits.append( self.allposts[i].fruit )
                  //  var img = UIImage(data: self.allposts[i].imgdata)
                    //self.postImages.append( img! )
                    self.postImages.append( self.allposts[i].img )
                    
                    //print(self.postTitles[i])
                }
                
                self.myGroup.leave()
            }
            else{
               /// print(response.result.error!)
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
                            
                            destination.titl = postTitles[selectedindexpath.row]
                            destination.desc = postAdditionalMsgs[selectedindexpath.row]
                            destination.fruitnme = postFruits[selectedindexpath.row]
                        }
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
    

    ////////////////////////////
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // originally was postTitle.count
        
        return allposts.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let saved_posts = collectionView.dequeueReusableCell(withReuseIdentifier: "saved_posts_cell", for: indexPath) as! SavedPostsCell

        
      //  saved_posts.post_image.image = postImages[indexPath.row]
       // saved_posts.post_city.text! = postCities[indexPath.item]
      //  print(postFruits.count,  " ",  postAdditionalMsgs.count,  "  ",  postTitles.count )
        
        saved_posts.post_fruit.text! = postFruits[indexPath.item]
        saved_posts.post_description.text! = postAdditionalMsgs[indexPath.item]
        saved_posts.post_title.text! = postTitles[indexPath.item]
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

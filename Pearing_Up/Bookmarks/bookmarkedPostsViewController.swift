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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var urlString: String  = "https://pearingup.herokuapp.com/" + "manan" + "/getBookmarkedPosts"
        let bookmark_url : URL = URL(string: urlString)!
        request_bookmarks(url: bookmark_url)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func request_bookmarks(url: URL) {
        self.myGroup.enter()
        Alamofire.request(url, method: .get ).responseJSON { response in
            if( response.result.isSuccess ) {
                let temp : JSON = JSON( response.result.value! )
                print("inside reqest bookmars")
                print(temp)
                
            } else{
                print(response.result.error!)
                self.myGroup.leave()
            }
        }
    }
    
    /*
    func request_bookmarks(url: URL, completion : @escaping (JSON) -> Void) {
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
    }*/
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bookmarked_posts = collectionView.dequeueReusableCell(withReuseIdentifier: "bookmarked_posts_cell", for: indexPath) as! bookmarkedPostCell
        
        return bookmarked_posts
    }
 
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

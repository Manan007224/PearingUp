//
//  ExpandedPostViewController.swift
//  Pearing_Up
//
//  Created by Ali Arshad on 2018-07-03.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//

import UIKit
import Alamofire

class ExpandedPostViewController: UIViewController {

    var owner : String!
    var image : UIImage!
    var titl: String!
    var desc: String!
    var loca: String!
    var fruitnme: String!
  
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var fruitimage: UIImageView!
    @IBOutlet weak var MakeAppointmentButton: UIButton!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var fruitname: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
        fruitimage.layer.borderWidth = 1
        fruitimage.layer.shadowRadius = 5.0
        fruitimage.layer.masksToBounds = false
        fruitimage.layer.shadowOpacity = 1.0
        fruitimage.layer.shadowOffset = CGSize.zero
        fruitimage.layer.cornerRadius = 10.0
        descriptionText.text = desc
        titleText.text = titl
        fruitname.text = fruitnme
        fruitimage.image = image
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func ApplyToPostingClicked(_ sender: Any){
        self.performSegue(withIdentifier: "applyToPost", sender: self)
    }
    
    @IBAction func bookmarkButton(_ sender: Any) {
        var bookmarks_url : URL = URL(string: "https://pearingup.herokuapp.com/bookmarkPost/" + User.Data.username + "/" + titl)!
        Alamofire.request(bookmarks_url, method: .get).responseJSON {
            response in
            if(response.result.isSuccess){
                print(response.result.value)
            }
            else{
                print("error")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "applyToPost" {
            
            let destination = segue.destination as! SendRequestViewController
            destination.receiverName = self.owner
            destination.desc = self.desc
            destination.titl = self.titl
            destination.fruitnme = self.fruitnme
            destination.image = self.image
            
        }
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

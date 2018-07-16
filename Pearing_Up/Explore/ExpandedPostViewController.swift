//
//  ExpandedPostViewController.swift
//  Pearing_Up
//
//  Created by Ali Arshad on 2018-07-03.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//

import UIKit

class ExpandedPostViewController: UIViewController {

    var owner = "owner"
    var titl: String!
    var desc: String!
    var loca: String!
    var fruitnme: String!
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var fruitimage: UIImageView!
    @IBOutlet weak var MakeAppointmentButton: UIButton!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var fruitname: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
        
        descriptionText.text = desc
        titleText.text = titl
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ApplyToPostingClicked(_ sender: Any)
        {
                self.performSegue(withIdentifier: "applyToPost", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "applyToPost" {
            
            let destination = segue.destination as! SendRequestViewController
            owner = destination.receiverName
            descriptionText.text = destination.description
            titleText.text = destination.title
         //   location.text = destination.location
        
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

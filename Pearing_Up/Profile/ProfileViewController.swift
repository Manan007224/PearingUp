//
//  ProfileViewController.swift
//  Pearing_Up
//
//  Created by Manan Maniyar on 2018-06-18.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//

import UIKit



class ProfileViewController: UIViewController {

    @IBOutlet weak var nameTextView: UILabel!
    @IBOutlet weak var pickerRatingLabel: UILabel!
    @IBOutlet weak var ownerRatingLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextView.text = User.Data.username
        locationLabel.text = User.Data.city // this does not work right now 07.25
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToYourPosts(_ sender: Any) {
        self.performSegue(withIdentifier: "yourPostsSegue", sender: self)
    }
    
    @IBAction func gotobookmarks(_ sender: Any) {
        self.performSegue(withIdentifier: "bookmarkslist", sender: self)
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

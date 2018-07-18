//
//  ExpandedBookmarkViewController.swift
//  Pearing_Up
//
//  Created by waz on 2018-07-17.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//

import UIKit

class ExpandedBookmarkViewController: UIViewController {

    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var fruitimage: UIImageView!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var fruitname: UILabel!
    

    @IBOutlet weak var removeBookmark_click: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func removeBookmark_click(_ sender: Any) {
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

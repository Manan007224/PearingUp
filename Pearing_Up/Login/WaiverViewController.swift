//
//  WaiverViewController.swift
//  Pearing_Up
//
//  Created by yoshiumw on 7/28/18.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//

import UIKit

class WaiverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func acceptButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toLogin", sender: self)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "waiverBack", sender: self)
    }
}

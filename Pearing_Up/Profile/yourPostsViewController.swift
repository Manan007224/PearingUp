//
//  yourPostsViewController.swift
//  Pearing_Up
//
//  Created by yoshiumw on 7/17/18.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//

import UIKit

class yourPostsViewController: UIViewController {

    @IBAction func goBack(_ sender: Any) {
        self.performSegue(withIdentifier: "goBackYPtoProfile", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

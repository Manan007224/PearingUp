//
//  SecondaryViewController.swift
//  Pearing_Up
//
//  Created by yoshiumw on 7/30/18.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//

import UIKit

class SecondaryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func switchViews(_ sender: Any) {
        self.performSegue(withIdentifier: "cardToList", sender: self)
    }
    
}

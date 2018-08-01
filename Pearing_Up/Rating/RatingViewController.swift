//
//  RatingViewController.swift
//  Pearing_Up
//
//  Created by Grace Kim on 2018-07-31.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController {

    @IBOutlet var starButtons: [UIButton]!
    
    @IBAction func StarButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        for button in starButtons {
            if button.tag <= tag {
                //select button
                button.setTitle("★", for: .normal)
            }
            else {
                //do not select
                button.setTitle("☆", for: .normal)
            }
        }
        print(tag)
        
        // ALAMOFIRE REQUEST GOES HERE
        
        let _ = navigationController?.popViewController(animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

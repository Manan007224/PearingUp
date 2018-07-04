//
//  InboxViewController.swift
//  Pearing_Up
//
//  Created by Grace Kim on 2018-07-03.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class InboxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //populate this array with names of senders
    let nameList = ["User1", "User2", "User3", "User4", "User5"]
    
    //populate this array with attached messages
    let descriptionList = ["Hello", "I am a test" , "Hey" ,"Let me come over" , "I want to pick your apples. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."]
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return(nameList.count)
    }
	
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inboxCell", for: indexPath) as! InboxTableViewCell
        
        cell.myLabel.text = nameList[indexPath.row]
        cell.descriptionLabel.text = descriptionList[indexPath.row]
        
        return(cell)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "expandRequest", sender: indexPath)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "expandRequest" {
            if let collectionCell: InboxTableViewCell = sender as? InboxTableViewCell {
                if let destination = segue.destination as? ExpandedRequestViewController {
                    destination.requestName = collectionCell.myLabel.text!
                    destination.requestDespcription = collectionCell.descriptionLabel.text!
                }
            }
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

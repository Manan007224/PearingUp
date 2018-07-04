//
//  InboxViewController.swift
//  Pearing_Up
//
//  Created by Grace Kim on 2018-07-03.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//

import UIKit

class InboxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //populate this array with names of senders
    let nameList = ["User1", "User2", "User3", "User4", "User5"]
    
    //populate this array with attached messages
    let descriptionList = ["Hello", "I am a test" , "Hey" ,"Let me come over" , "I want to pick your apples"]
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

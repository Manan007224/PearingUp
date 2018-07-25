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
    
    
    let myGroup = DispatchGroup()
    
    
    func get_RequestData(name: String, completion: @escaping (String) -> Void) {
        self.myGroup.enter()
        populate(uname: name)
        self.myGroup.leave()
    }
    
    func populate(uname : String)
    {
        self.myGroup.enter()
        let url = "https://pearingup.herokuapp.com/" + uname + "/getRequests"
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if(response.result.isSuccess) {
                let json : JSON = JSON(response.result.value!)
                //print(json)
                let requested_people = json["result"].array
                //print(result)
                
                for people in requested_people! {
                    self.nameList.append(people["username"].string!)
                    self.descriptionList.append(people["add_msg"].string!)
                }
                self.myGroup.leave()
                
            } else {
                print("Inbox View Controller Error")
                self.myGroup.leave()
            }
        }
    }
    
    func update_data() {
        print("Came at update_Data()")
        self.inboxTableView.reloadData()
    }
    
    
    //populate this array with names of senders
    var nameList : [String] = []
    
    //populate this array with attached messages
    var descriptionList : [String] = []
    
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
    
    @IBOutlet weak var inboxTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.inboxTableView.dataSource = self
        self.inboxTableView.delegate = self
        //populate(uname : "manan")
        self.get_RequestData(name: User.Data.username) { data in
            print("Came here")
        }
        myGroup.notify(queue: .main) {
            self.update_data()
        }
        self.tabBarController?.tabBar.isHidden = false

        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.update_data()
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

}

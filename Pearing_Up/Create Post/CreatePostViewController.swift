//
//  MakePostViewController.swift
//  Pearing_Up
//
//  Created by waz on 2018-06-27.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
// change made

import UIKit
import Alamofire
import SwiftyJSON

class MakePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let myGroup = DispatchGroup()
    
    // var imgData: NSData!
    var id : String = ""
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextView: UITextField!
    @IBOutlet weak var descriptionTextView: UITextField!
    @IBOutlet weak var fruitTextView: UITextField!
    @IBOutlet weak var locationTextView: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        myGroup.notify(queue: .main) {
            self.update_data()
        }
    }
    
    func update_data() {
        //self.bookmarked_posts.dataSource = self
        //bookmarked_posts.reloadData()
        print("Data Reloaded")
    }
    /*
     if produce name, title, image location  empty
     display alert
     else
     alamofire
     */
    
    
    @IBAction func CreatePost(_ sender: Any) {
        if(titleTextView.text == "" ){
            print("title field required")
            displayAlert(message: "title field required")
            return
        }
        else if (fruitTextView.text == ""){
            print("produce field required")
            displayAlert(message: "produce field required")
            return
        }
        else if(locationTextView.text == ""){
            print("location field required")
            displayAlert(message: "location field required")
            return
        }
        else if(imageView.image == nil ){
            print("image required")
            displayAlert(message: " image required")
            return
        }
        else{
            //UPLOAD PICTURE
            let url_image = "https://pearingup.herokuapp.com/upload/"
            
            let image_params: [String: Any] = ["file" : imageView.image!]
            
            makePost(url: url_image, params: image_params)
            print(url_image)
            let info_params : [String: String] = ["fruits":fruitTextView.text!]
            
            let username = User.Data.username
            
            let user_params : [String: Any] = ["owner":username, "info":info_params, "additional_msg": descriptionTextView.text!,"title":titleTextView.text!]
            
            //UPLOAD POST
            let url_post = "https://pearingup.herokuapp.com/uploadPostDetails/" + id
            print(url_post)
            makePost(url: url_post, params: user_params)
        }
    }
    
    
    //Completion handler to retrieve json response data
    func uploadData(url : String, params : [String : Any], completion: @escaping (JSON) -> Void){
        Alamofire.request(url, method: .post, parameters: params).responseJSON{
            response in
            if response.result.isSuccess{
                print("---------if response result issuccess-----------")
                completion(JSON(response.result.value!))
            }
            else{
                print("error occured")
            }
        }
    }
    
    func makePost(url: String, params: [String : Any]){
        self.myGroup.enter()
        
        uploadData(url: url, params: params) { response in
            // Do your stuff here
            let temp : JSON = response
            
            print(temp)
            
            // this  is the most is made successfully
            
            if( temp["code"].exists() ){
                print("---------if temp code exists-----------")
                
                if(temp["code"] == 409){
                    self.displayAlert(message: "server errror-------------------")
                }
            }
            if( temp["id"].exists() ){
                
                self.id = temp["id"].string!
            }
            
        }
        self.myGroup.leave()
    }
    
    @IBAction func addImg(_ sender: Any) {
        print("yollllll")
        let picker = UIImagePickerController()
        picker.delegate = self
        
        print("1")
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
        print("2")

        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: nil)
            } else {
                print("camera not available")
            }
        
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }))
        
        print("3")

        actionSheet.addAction(UIAlertAction(title: "Photo Library" , style: .default, handler: {(action:UIAlertAction) in picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
        print("4")
        self.present(actionSheet, animated:true, completion: nil)
    }
    
    
    func imagePickerController( _ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        print("pic")
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        imageView.image = chosenImage //4
        dismiss(animated:true, completion: nil) //5
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func displayAlert(message: String){
        
        let alert_toDisplay = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        alert_toDisplay.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            // self.titleText.text = "yoo"
        }))
        self.present(alert_toDisplay, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

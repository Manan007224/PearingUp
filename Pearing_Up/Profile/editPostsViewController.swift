//
//  editPostsViewController.swift
//  Pearing_Up
//
//  Created by yoshiumw on 7/17/18.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class editPostsViewController: UIViewController,UIImagePickerControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextView: UITextField!
    @IBOutlet weak var descriptionTextView: UITextField!
    @IBOutlet weak var locationTextView: UITextField!
    @IBOutlet weak var fruitPickerView: UIPickerView!
    
    let myGroup = DispatchGroup()
    var id = "manan"
    let fruit = ["Almond" , "Apple" , "Apricot", "Avocado", "Blood Orange", "Cherry", "Citron", "Feijoa", "Fig", "Grapefruit", "Hardy Citrus","Jujube", "Kaffir Lime", "Kiwi", "Kumquat","Lemon", "Lime","Loquat", "Mandarin Orange", "Medlar", "Mulberry", "Navel Orange", "Nectarine", "Olive", "Pawpaw", "Peach", "Pear", "Persimmon", "Plum", "Pomegranate","Quince" , "Sour Orange"]
    
    @IBAction func goBack(_ sender: Any) {
        self.performSegue(withIdentifier: "goBackYourPosts", sender: self)
    }
    
    var pickedFruit = ""
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        
        label.text = fruit[row]
        
        return label
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fruit[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fruit.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickedFruit = fruit[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myGroup.notify(queue: .main) {
            self.update_data()
        }
        
    }

    func update_data() {
        print("Data Reloaded")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func editPostsButton(_ sender: Any) {
        if(titleTextView.text == "" ){
            print("title field required")
            displayAlert(message: "title field required")
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
        else {
            let url_image = "https://pearingup.herokuapp.com/upload/"
            let image_params: [String: Any] = ["file" : imageView.image!]
            
            makePost(url: url_image, params: image_params)
            let info_params : [String: String] = ["fruits":pickedFruit]
            print(pickedFruit)
            let username = User.Data.username
            
            let user_params : [String: Any] = ["owner":username, "info":info_params, "additional_msg": descriptionTextView.text!,"title":titleTextView.text!]
            
            //UPLOAD POST
            let url_post = "https://pearingup.herokuapp.com/uploadPostDetails/" + id
            print(url_post)
            makePost(url: url_post, params: user_params)
        }
    }
    
    //delete the post using posts id(?) and then repost it with new information
    func deletePost(){
        
    }
    
    func makePost(url: String, params: [String : Any]){
        self.myGroup.enter()
        
        uploadData(url: url, params: params) { response in
            let temp : JSON = response
        
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
        let picker = UIImagePickerController()
        picker.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
        
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
    
    //edit the data here (delete post -> create new post? / edit post)
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
    
    func displayAlert(message: String){
        
        let alert_toDisplay = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        alert_toDisplay.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            // self.titleText.text = "yoo"
        }))
        self.present(alert_toDisplay, animated: true, completion: nil)
    }
    
    

}

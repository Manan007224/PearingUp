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
    
    let myGroup = DispatchGroup()
    
    var owner = ""
    var titl : String!
    var desc : String!
    var fruitnme : String!
    var city = "Vancouver"
    var idee : String!
    var image : UIImage!
    // needsUpdate will indicate to yourPostViewController if the view needs to be reloaded
    var needsUpdate : Bool = false
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextView: UITextField!
    @IBOutlet weak var descriptionTextView: UITextField!
    @IBOutlet weak var locationTextView: UITextField!
    @IBOutlet weak var fruitPickerView: UIPickerView!
    
    var fileLocation : NSURL!
    var id : String = ""
    let url = "https://pearingup.herokuapp.com/"
    
    let fruit = ["Almond" , "Apple" , "Apricot", "Avocado", "Blood Orange", "Cherry", "Citron", "Feijoa", "Fig", "Grapefruit", "Hardy Citrus","Jujube", "Kaffir Lime", "Kiwi", "Kumquat","Lemon", "Lime","Loquat", "Mandarin Orange", "Medlar", "Mulberry", "Navel Orange", "Nectarine", "Olive", "Pawpaw", "Peach", "Pear", "Persimmon", "Plum", "Pomegranate","Quince" , "Sour Orange"]
    
    var pickedFruit = "Almond"
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
    
    @IBAction func backButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fruit[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fruit.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //label.text = fruit[row] // fruit[row] is what is selected
        pickedFruit = fruit[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        myGroup.notify(queue: .main) {
            self.update_data()
        }
        
        imageView.image = image
        titleTextView.text = titl.replacingOccurrences(of: "_", with: " ")
        descriptionTextView.text = desc
        locationTextView.text = city
        imageView.layer.cornerRadius = 5.0
        imageView.clipsToBounds = true
        imageView.layer.shadowRadius = 5.0
        imageView.layer.masksToBounds = false
        imageView.layer.shadowOpacity = 1.0
        imageView.layer.shadowOffset = CGSize.zero
        
        let border = CALayer()
        let border2 = CALayer()
        let border3 = CALayer()
        
        let width = CGFloat(1.5)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: titleTextView.frame.size.height - width, width: titleTextView.frame.size.width, height: titleTextView.frame.size.height)
        border.borderWidth = width
        
        border2.borderColor = UIColor.lightGray.cgColor
        border2.frame = CGRect(x: 0, y: titleTextView.frame.size.height - width, width: titleTextView.frame.size.width, height: titleTextView.frame.size.height)
        border2.borderWidth = width
        
        border3.borderColor = UIColor.lightGray.cgColor
        border3.frame = CGRect(x: 0, y: titleTextView.frame.size.height - width, width: titleTextView.frame.size.width, height: titleTextView.frame.size.height)
        border3.borderWidth = width
        
        titleTextView.layer.addSublayer(border)
        titleTextView.layer.masksToBounds = true
        
        descriptionTextView.layer.addSublayer(border2)
        descriptionTextView.layer.masksToBounds = true
        
        locationTextView.layer.addSublayer(border3)
        locationTextView.layer.masksToBounds = true
        
        print("id: " + idee)
    }
    
    func update_data() {
        //self.bookmarked_posts.dataSource = self
        //bookmarked_posts.reloadData()
        print("Data Reloaded")
    }
    
    // Edits the selected post information and uploads it to the server
    @IBAction func editPost(_ sender: Any) {
        myGroup.enter()
        deletePostRequest() {
            let info_param : [String: String] = ["fruits": self.pickedFruit]
            let params : [String: Any] = ["owner": User.Data.username, "info": info_param, "additional_msg": self.descriptionTextView.text!,"title": self.titleTextView.text!]
            self.makePost(params: params) {
                yourPostsViewController.setNeedsUpdate(needsUpdate: true)
                _ = self.navigationController?.popViewController(animated: true)
                self.myGroup.leave()
            }
        }
    }
    
    // Deletes the selected post and its associated image from the server
    @IBAction func deletePost(_ sender: Any) {
        myGroup.enter()
        deletePostRequest() {
            self.deleteImageRequest() {
                yourPostsViewController.setNeedsUpdate(needsUpdate: true)
                _ = self.navigationController?.popViewController(animated: true)
                self.myGroup.leave()
            }
        }
    }
    
    func deletePostRequest(completionHandler : @escaping () -> Void) {
        myGroup.enter()
        let requestUrl = (url + "post/" + titl)
        print(requestUrl)
        Alamofire.request(requestUrl, method: .delete).responseJSON{
            response in
            if response.result.isSuccess{
                print("---------if response result issuccess-----------")
                let temp : JSON = JSON(response.result.value!)
                
                if( temp["code"].exists() ){
                    print("---------if temp code exists-----------")
                    
                    if(temp["code"] == 409){
                        self.displayAlert(message: "server errror-------------------")
                    }
                }
                self.myGroup.leave()
                completionHandler()
            }
            else{
                print("error occured")
            }
        }
    }
    
    func deleteImageRequest(completionHandler : @escaping () -> Void) {
        myGroup.enter()
        let requestUrl = (url + "image/" + idee)
        print(requestUrl)
        Alamofire.request(requestUrl, method: .delete).responseJSON{
            response in
            if response.result.isSuccess{
                print("---------if response result issuccess-----------")
                let temp : JSON = JSON(response.result.value!)
                
                if( temp["code"].exists() ){
                    print("---------if temp code exists-----------")
                    
                    if(temp["code"] == 409){
                        self.displayAlert(message: "server errror-------------------")
                    }
                }
                self.myGroup.leave()
                completionHandler()
            }
            else{
                print("error occured")
            }
        }
    }
    
    func makePost(params : [String : Any], completionHandler : @escaping () -> Void) {
        myGroup.enter()
        let requestUrl = (url + "uploadPostDetails/" + idee)
        print(requestUrl)
        Alamofire.request(requestUrl, method: .post, parameters : params).responseJSON{
            response in
            if response.result.isSuccess{
                print("---------if response result issuccess-----------")
                let temp : JSON = JSON(response.result.value!)
                
                if( temp["code"].exists() ){
                    print("---------if temp code exists-----------")
                    
                    if(temp["code"] == 409){
                        self.displayAlert(message: "server errror-------------------")
                    }
                }
                self.myGroup.leave()
                completionHandler()
            }
            else{
                print("error occured")
            }
        }
    }
    
    func imagePickerController( _ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        print("pic")
        fileLocation = info[UIImagePickerControllerImageURL] as! NSURL
        print(fileLocation)
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
        }))
        self.present(alert_toDisplay, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

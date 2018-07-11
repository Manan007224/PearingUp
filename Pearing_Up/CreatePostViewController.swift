//
//  MakePostViewController.swift
//  Pearing_Up
//
//  Created by waz on 2018-06-27.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//

import UIKit
import Alamofire

class MakePostViewController: UIViewController {
    
    
    // var imgData: NSData!
    var img : UIImage?
  
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleText: UITextView!
    @IBOutlet weak var postdescriptionText: UITextField!
    @IBOutlet weak var ProduceName: UITextField!
    @IBOutlet weak var location: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    /*
     if produce name, title, image location  empty
     display alert
     else
     alamofire
     
     */
    
    @IBAction func CreatePost(_ sender: Any) {
        if(titleText.text == "" ){
            print("title field required")
            displayAlert(message: "title field required")
            return
        }
        else if (ProduceName.text == ""){
            print("produce field required")
            displayAlert(message: "produce field required")
            return
        }
        else if(location.text == ""){
            print("location field required")
            displayAlert(message: "location field required")
            return
        }
        else if(img == nil ){
            print("image required")
            displayAlert(message: " image required")
            return
        }
        else{
            //make params dictionary n call makepost
            let info_params : [String: String] = ["expected_yield":ExpectedYield.text! ,"fruits":ProduceName.text!]
            let username = "manan"
            
            let user_params : [String: Any] = ["owner":username, "info":info_params, "additional_msg": postdescriptionText.text!,"title":titleText.text!]
            
            // get username
            let url = "https://pearingup.herokuapp.com/:" + username + "/createPost"
            print(url)
            makePost(url: url,params: user_params)
            
        }
    }
    //
    func makePost(url: String, params: [String : Any]){
        print("---------makePost-----------")
        Alamofire.request(url, method: .post, parameters: params).responseJSON{
            response in
            if response.result.isSuccess{
                print("---------if response result issuccess-----------")
                
                let temp : JSON = JSON(response.result.value!)
                print(temp)
                
                // this  is the most is made successfully
                
                if( temp["code"].exists() ){
                    print("---------if temp code exists-----------")
                    
                    if(temp["code"] == 409){
                        self.displayAlert(message: "server errror-------------------")
                    }
                }
                //self.performSegue(withIdentifier: "makePostSegue", sender: self)
                
            }
            else{
                print("error occured")
            }
        }
    }
    
    
    @IBAction func addImage(_ sender: Any) {
        print("yollllll")
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("camera not available")
            }
            
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library" , style: .default, handler: {(action:UIAlertAction) in imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
        
        self.present(actionSheet, animated:true, completion: nil)
    }
    
//    @IBAction func addImg(_ sender: Any) {
//        print("yollllll")
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.delegate = self
//
//        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
//        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
//
//            if UIImagePickerController.isSourceTypeAvailable(.camera){
//                imagePickerController.sourceType = .camera
//                self.present(imagePickerController, animated: true, completion: nil)
//            } else {
//                print("camera not available")
//            }
//
//            imagePickerController.sourceType = .camera
//            self.present(imagePickerController, animated: true, completion: nil)
//        }))
//
//        actionSheet.addAction(UIAlertAction(title: "Photo Library" , style: .default, handler: {(action:UIAlertAction) in imagePickerController.sourceType = .photoLibrary
//            self.present(imagePickerController, animated: true, completion: nil)
//        }))
//
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
//
//        self.present(actionSheet, animated:true, completion: nil)
//
//    }
//
    
    
    func imagePickerController( _ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //  imgData = UIImagePNGRepresentation(image)! as NSData
        //print(imgData)
        img = image
        imageView.image  = image
        picker.dismiss(animated: true, completion: nil)
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
    
    
    /*
     // MARK: - Navigation
     
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

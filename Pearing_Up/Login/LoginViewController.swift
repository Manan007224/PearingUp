//
//  LoginViewController.swift
//  Pearing_Up
//
//  Created by Manan Maniyar on 2018-06-18.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//
// lst updated
import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
    var gradientLayer: CAGradientLayer!
    
/*    func createGradientLayer()
    {
        gradientLayer = CAGradientLayer()
        
        //define colors
        gradientLayer.colors=[UIColor.white.cgColor, UIColor.lightGray.cgColor]
        gradientLayer.locations=[0.0,0.6,0.8]
        gradientLayer.frame=self.view.bounds
        self.view.layer.addSublayer(gradientLayer)
        
    }*/
    
    @IBOutlet weak var login_tet: UILabel!
    @IBOutlet weak var pwd_holder: UITextField!
    @IBOutlet weak var email_holder: UITextField!
    let login_url = "https://pearingup.herokuapp.com/login"
    let profile_url = "http://pearingup.herokuapp.com/Profile/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //createGradientLayer()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login_click(_ sender: Any) {
        let user_params: [String:String] = ["email": email_holder.text!, "password": pwd_holder.text!]
      //  let user_params: [String:String] = ["email": "q@sfu.ca", "password": "q"]
        
        login(url: login_url, params: user_params)
    }
    
    func login(url: String, params: [String:String]){
        
        // Check weather email or password entered are not empty strings
        
        if(email_holder.text == "" || pwd_holder.text == ""){
            print("All fields required")
            displayAlert(message: "Email or Password is Empty. Please fill in again")
            return
        }
        
        // Check a valid email id using regular expressions
        
        if(valid_email(emailString: email_holder.text!)){
            Alamofire.request(url, method: .post, parameters: params).responseJSON{
                response in
                if response.result.isSuccess {
                    let temp : JSON = JSON(response.result.value!)
                    print("Reached Here")
                    print(temp)
                    
                    // API DOCUMENTATION
                    // Success, result: "email_id"
                    // If the password is wrong, errCode == 409
                    // If the User is not found, errCode == 400
                    // If there is any server side error, errCode == 302
                    
                    if(temp["code"].exists()){
                        if(temp["code"] == 400){
                            self.displayAlert(message: "User with this email_id is not found. Please enter the credentials again")
                        }
                        
                        else if(temp["code"] == 409){
                            self.displayAlert(message: "The entered password is incorrect. Please enter the password again")
                        }
                        
                        else if(temp["code"] == 302){
                            self.displayAlert(message: "Server-Side error. Please contact Manan Maniyar")
                        }
                    }
                    
                    User.Data.email = self.email_holder.text!
                    if(temp["result"].exists()){
                        User.Data.username = temp["result"].rawString()!
                        self.userSetUp()
                    }
                    self.performSegue(withIdentifier: "goToLanding", sender: self)
                    
                }
                else {
                    print("Error Occurred")
                }
            }
        }
        
        else {
            print("Error in the email Address")
            displayAlert(message: "Please enter a valid email address.")
            return
        }
        
    }
    
    func userSetUp() {
        let url = profile_url + User.Data.username
        Alamofire.request(url, method: .get).responseJSON{
            response in
            if response.result.isSuccess {
                let profile : JSON = JSON(response.result.value!)
                if(profile["full_name"].exists()) {
                    User.Data.fullName = profile["full_name"].rawString()!
                }
                if(profile["location"].exists()) {
                    User.Data.address = profile["location"].rawString()!
                }
                if(profile["city"].exists()) {
                    User.Data.city = profile["city"].rawString()!
                }
            }
        }
    }
    
    func valid_email(emailString: String) -> Bool {
        
        let email_regex = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: email_regex)
            let rnstring = emailString as NSString
            let results = regex.matches(in: emailString, range: NSRange(location: 0, length: rnstring.length))
            
            if results.count == 0 {
                return false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return false
        }
        
        return true
    }
    
    func displayAlert(message: String){
        
        let alert_toDisplay = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        alert_toDisplay.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            //self.email_holder.text = "email"
            //self.pwd_holder.text = "password"
        }))
        self.present(alert_toDisplay, animated: true, completion: nil)
    }
    
}

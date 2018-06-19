//
//  RegisterUserViewController.swift
//  Onboard Test
//
//  Created by FAIR FARE on 6/14/18.
//  Copyright © 2018 FAIR FARE. All rights reserved.
//

import UIKit
import Alamofire

class RegisterUserViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        //Checks for empty fields
        if (nameTextField.text?.isEmpty)! || (userNameTextField.text?.isEmpty)!||(pwdTextField.text?.isEmpty)!||(emailTextField.text?.isEmpty)! {
            displayMessage(errorMessage: "Please fill in all fields")
            return
        }
        
        //Activity Indicator
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)

        //http request
        let myURL = "http://myviralstuff.com/API-App/register.php"
        
        let parameters : Parameters=["username":userNameTextField.text!, "name":nameTextField.text!, "pwd":pwdTextField.text!, "email":emailTextField.text!]
        
        Alamofire.request(myURL, method: .post, parameters:parameters, encoding: JSONEncoding.default).responseJSON{
            response in
            
            if let result = response.result.value{
                let jsonData = result as! [String:AnyObject]
                let myStatus = jsonData["status"] as? Bool
                if myStatus!{
                    let myMessage = jsonData["message"] as? String
                    self.displayMessageClear(errorMessage: myMessage! + " please sign in")
                }else{
                    let myMessage = jsonData["data"] as! [[String:AnyObject]]
                    let myError = myMessage[0]["error"] as! String
                    self.displayMessage(errorMessage: myError)
                    self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                }
            }
        }
    }
    
        func removeActivityIndicator(activityIndicator: UIActivityIndicatorView){
            DispatchQueue.main.async{
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Clears sign up page
    func displayMessageClear(errorMessage:String) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Alert", message: errorMessage, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) {(action:UIAlertAction!) in
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //Only clears alert message
    func displayMessage(errorMessage:String) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Alert", message: errorMessage, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) {(action:UIAlertAction!) in
                
            }
            
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

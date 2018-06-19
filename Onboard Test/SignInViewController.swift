//
//  SignInViewController.swift
//  Onboard Test
//
//  Created by FAIR FARE on 6/14/18.
//  Copyright © 2018 FAIR FARE. All rights reserved.
//

import UIKit
import Alamofire

class SignInViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        
        //Checks for empty fields
        if (userNameTextField.text?.isEmpty)!||(pwdTextField.text?.isEmpty)! {
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
        //let myURL = "http://myviralstuff.com/API-App/login.php"
        
        //let parameters : Parameters=["username":userNameTextField.text!,"pwd":pwdTextField.text!]
        
        let pullViewController = self.storyboard?.instantiateViewController(withIdentifier: "PullViewController") as! PullViewController
        
        self.present(pullViewController, animated:true)
        
        removeActivityIndicator(activityIndicator: myActivityIndicator)
    }
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView){
        DispatchQueue.main.async{
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier:
            "RegisterUserViewController") as! RegisterUserViewController
        
        self.present(registerViewController, animated: true)
    }
    
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

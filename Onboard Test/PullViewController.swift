//
//  PullViewController.swift
//  Onboard Test
//
//  Created by FAIR FARE on 6/18/18.
//  Copyright © 2018 FAIR FARE. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class PullViewController: UIViewController, UICollectionViewDataSource {


    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var myCollectionView: UICollectionView!
    var images: [String]?
    //var titles: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadImages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return images?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{

        let myCell:MyCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for:indexPath) as! MyCollectionViewCell
       
        let imageString = self.images?[indexPath.row]
        //let titleText = self.titles[indexPath.row]
        DispatchQueue.main.async {
            Alamofire.request(imageString!).responseImage { (response) in
                if let image = response.result.value {
                    myCell.myImageView.image = image
                    //CFStringTransform( titleText as! CFMutableString, nil, "Any-Hex/Java" as NSString, true )
                    //myCell.titleText.text = titleText
                }
            }
        }
        return myCell
    }

    @IBAction func searchTapped(_ sender: Any) {
        loadImages()
    }
    
    func loadImages(){
        //Activity Indicator
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        
        //http request
        images = []
        //titles = []
        let myURL = "http://myviralstuff.com/API-App/list-post.php"
        
        let parameters : Parameters = ["per_page":"10","page_id":"1","order":"acs","s":searchTextField.text!,"user_id":"28"]
        
        Alamofire.request(myURL, method: .post, parameters:parameters, encoding: JSONEncoding.default).responseJSON{
            response in
            if let result = response.result.value{
                let jsonData = result as! [String:AnyObject]
                let myStatus = jsonData["status"] as? Bool
                if myStatus!{
                    let myPosts = jsonData["posts"] as! [[String:AnyObject]]
                    for (index, _) in myPosts.enumerated(){
                        self.images?.append(myPosts[index]["Postimg"] as! String)
                        //self.titles.append(myPosts[index]["PostTitle"] as! String)
                    }
                    self.myCollectionView.reloadData()
                }else{
                    let myMessage = jsonData["message"] as? String
                    self.displayMessage(errorMessage: myMessage!)
                }
            }
        }
        
        removeActivityIndicator(activityIndicator: myActivityIndicator)
    }
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView){
        DispatchQueue.main.async{
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
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

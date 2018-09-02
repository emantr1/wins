//
//  FeedbackViewController.swift
//  Wins
//
//  Created by Eman I on 5/10/16.
//  Copyright © 2016 Eman. All rights reserved.
//

import UIKit
import Parse


class FeedbackViewController: UIViewController {

    @IBAction func featuresButtonTest(_ sender: AnyObject) {
        //trying to pull featured photos and description from parse
        
        
                globalfeatureArray = [Feature]()
        
                let getProQuery = PFQuery(className: "Pro")
                getProQuery.order(byAscending: "position") // order by position
                getProQuery.limit = 12
                //getProQuery.whereKey("public", equalTo: true)
                //getWinsQuery.cachePolicy = PFCachePolicy.CacheElseNetwork
                getProQuery.findObjectsInBackground() { (objects, error) -> Void in
                    if let objects = objects {
                        var featureCount = 0
                        for object in objects {
                            
                            print("feature count \(featureCount)")
                            let words = object["description"] as! String
                            if object["image"] != nil {
                                let proImage = object["image"] as! PFFile
                                
                                proImage.getDataInBackground { (data, error) -> Void in
                                    if error == nil {
                                        print("in the images")
                                        featureCount += 1
                                        if let downloadedImage = UIImage(data: data!) {
                                            globalfeatureArray.append(Feature(title:"title 1", description: words, featuredImage: downloadedImage))
                                            if featureCount == objects.count {
                                                print("got here because feature count is \(featureCount) and object count is \(objects.count)")
                                                self.performSegue(withIdentifier: "showFeatures", sender: self)
                                            }

                                        }
                                    } else {
                                        globalfeatureArray.append(Feature(title:"title 1", description: "stuff that goes into number 1", featuredImage: UIImage(named:"Smiling.jpg")!))
                                        
                                        if featureCount == objects.count {
                                            self.performSegue(withIdentifier: "showFeatures", sender: self)
                                        }
                                    }
                                }
                            }
                        }
                    
                    }
                    
                }

    }
    @IBOutlet var cancelButton: UIButton!
    @IBAction func cancelTap(_ sender: AnyObject) {
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    @IBOutlet var textView: UITextView!
    @IBOutlet var submitButton: UIButton!
    @IBAction func submit(_ sender: AnyObject) {
        
        if textView.hasText {
            
            let feedbackSubmission = PFObject(className: "Flagged")
            feedbackSubmission["message"] = textView.text
            feedbackSubmission["reportingUser"] = currentUser
            feedbackSubmission.saveInBackground()
            displayAlert2("Many Thanks!", message:"We appreciate the feedback.  Keep it coming!")
            
            
        } else {
             displayAlert("Nothing There?", message:"If you have feedback, make sure to write it down for us.")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let background = CAGradientLayer().greenLayer()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)
        
        submitButton.layer.cornerRadius = 8.0
        submitButton.clipsToBounds = true
        

        
        // Do any additional setup after loading the view.
    }

    func displayAlert2(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK, Cool", style: .default, handler: { (action) -> Void in
            self.navigationController?.popToRootViewController(animated: true)
            
            
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK, Cool", style: .default, handler: { (action) -> Void in
            //self.dismissViewControllerAnimated(true, completion: nil)
            
            
            
        }))
        self.present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ForgotPassViewController.swift
//  classified
//
//  Created by Eman I on 4/5/16.
//  Copyright © 2016 Eman
//

import UIKit
import Parse

class ForgotPassViewController: UIViewController {
    
    
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var sendButton: UIButton!
    @IBAction func send(_ sender: AnyObject) {
        
        let emailAddress = txtEmail.text
        
        if emailAddress == nil {
            
            //alert need email
            let message = "You need to give us an email for this to work"
            displayAlert("Where is it?", message: message, pop: false)
            return
  
            
        } else {
        PFUser.requestPasswordResetForEmail(inBackground: emailAddress!, block: {(success: Bool, error: NSError?) -> Void in
            if error == nil {
                //Success
                
                let message = "Check your email:\(emailAddress!) for reset instructions"
                self.displayAlert("Good Stuff!", message: message, pop: true)
                
            } else {
                //failed
                let message = error!.localizedDescription
                self.displayAlert("We got probs", message: message, pop: false)
            }
        })
    }
    }
    
    
    @IBOutlet var cancelButton: UIButton!

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var errorMessage = "Please try again later"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sendButton.layer.cornerRadius = 4.0
        sendButton.clipsToBounds = true
        cancelButton.layer.cornerRadius = 4.0
        cancelButton.clipsToBounds = true
        
        txtEmail.becomeFirstResponder()
        
        let background = CAGradientLayer().whiteLayer()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
  
    override func viewDidAppear(_ animated: Bool) {
       
    }
    func displayAlert(_ title: String, message: String, pop: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK, Got it", style: .default, handler: { (action) -> Void in
            //self.dismissViewControllerAnimated(true, completion: nil)
            if pop == true {
                self.dismiss(animated: true, completion: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

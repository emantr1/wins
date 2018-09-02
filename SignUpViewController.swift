//
//  SignUpViewController.swift
//  classified
//
//  Created by Eman I on 4/5/16.
//  Copyright © 2016 Eman
//

import UIKit
import Parse

class SignUpViewController: UIViewController {
    
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtUsername : UITextField!
    @IBOutlet var txtPassword : UITextField!
    @IBOutlet var signUpBtn : UIButton!
    @IBOutlet var signInBtn : UIButton!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var errorMessage = "Please try again later"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //signUpBtn.selected = true
        // Do any additional setup after loading the view.
        txtUsername.becomeFirstResponder()
        
        signUpBtn.layer.cornerRadius = 4.0
        signUpBtn.clipsToBounds = true
        
        signInBtn.layer.cornerRadius = 4.0
        signInBtn.clipsToBounds = true
        
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
        if PFUser.current() != nil {
            self.performSegue(withIdentifier: "startapp", sender: self)
        }
         txtUsername.text = usernamePlaceHolder
    }
    func displayAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            //self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signUpBtnTaped(_ sender : UIButton) {
        //signInBtn.selected = false
        //signUpBtn.selected = true
       
        
        if txtUsername.text == "" || txtPassword.text == "" || txtEmail.text == "" {
            displayAlert("Probs with Sign Up", message: "Gotta enter a username, password and email")
            
        } else {
            
            print("this is the pass \(txtPassword)")
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 50,height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            // UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            let communityStart = ["entrepreneur"]
            let user = PFUser()
            user.username = txtUsername.text?.lowercased()
            user.password = txtPassword.text
            user.email = txtEmail.text
            user.setValue(txtUsername.text?.lowercased(), forKey: "firstName")
            user.setValue(communityStart, forKey: "community")
            
            
            user.signUpInBackground(block: { (success, error) -> Void in
                self.activityIndicator.stopAnimating()
                // UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if error == nil {
                    print("Sign up successful")
                    self.performSegue(withIdentifier: "startSignUp", sender: self)
                    
                } else {
                    if let errorString = error!.userInfo["error"] as? String {
                        self.errorMessage = errorString
                        print(self.errorMessage)
                    }
                    self.displayAlert("Failed Signup", message: self.errorMessage)
                }
            })
        }
    }
    
    func textFieldShouldReturn (_ textField: UITextField!) -> Bool{
        if ((textField == txtUsername)){
            txtPassword.becomeFirstResponder();
        } else if (textField == txtPassword){
            txtEmail.becomeFirstResponder();
        } else if (textField == txtEmail) {
            textField.resignFirstResponder()
        }
        return true
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

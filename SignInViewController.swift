//
//  SignInViewController.swift
//  classified
//
//  Created by Eman I on 4/5/16.
//  Copyright © 2016 Eman
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4

class SignInViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet var loginScroll: UIScrollView!
    @IBOutlet var passQuestionButton: UIButton!
    @IBOutlet var fbLoginButton: UIButton!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtUsername : UITextField!
    @IBOutlet var txtPassword : UITextField!
    @IBAction func fbbuttton(_ sender: AnyObject) {
        
        PFFacebookUtils.logInInBackground(withReadPermissions: ["public_profile","email"]) { (user:PFUser?, error:NSError?) -> Void in
            if error != nil {
                self.displayAlert("Login Probs", message: (error?.localizedDescription)!)
                return
            }
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                } else {
                    print("User logged in through Facebook!")
                }
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
           
            self.processNewUser()
        }

    }
    @IBOutlet var signUpBtn : UIButton!
    @IBOutlet var signInBtn : UIButton!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var errorMessage = "Please try again later"
    
    //no longer need this button
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //signUpBtn.selected = true
        // Do any additional setup after loading the view.
//        view.addSubview(loginButton)
//        loginButton.center.y = signInBtn.center.y + 40
//        loginButton.center.x = view.center.x
//        loginButton.delegate = self
        
        fbLoginButton.layer.cornerRadius = 4.0
        fbLoginButton.clipsToBounds = true
//        fbLoginButton.layer.borderColor = UIColor.whiteColor().CGColor
//        fbLoginButton.layer.borderWidth = 2.0
        
        passQuestionButton.layer.cornerRadius = passQuestionButton.frame.size.width / 2
        passQuestionButton.clipsToBounds = true
        
        
        signUpBtn.layer.cornerRadius = 4.0
        signUpBtn.clipsToBounds = true
        
        signInBtn.layer.cornerRadius = 4.0
        signInBtn.clipsToBounds = true
        
        let background = CAGradientLayer().whiteLayer()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("completed login")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func signInBtnTapped(_ sender : UIButton) {
        //signInBtn.selected = true
        //signUpBtn.selected = false
        
        if txtUsername.text == "" || txtPassword.text == "" {
            displayAlert("We got probs", message: "Gotta enter a username and password")
            
        } else {
            
            txtUsername.text = txtUsername.text?.lowercased()
            let trimmedString = txtUsername.text!.trimmingCharacters(
                in: CharacterSet.whitespacesAndNewlines)
        
            
        PFUser.logInWithUsername(inBackground: trimmedString, password: txtPassword.text!) { (user, error) -> Void in
            
            self.activityIndicator.stopAnimating()
            //UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if user != nil {
                //logged In
                print("logged in")
                
                self.performSegue(withIdentifier: "startapp", sender: self)
                //let secondViewController = FeelingViewController(nibName:"FeelingViewController", bundle: nil)
                //self.navigationController?.pushViewController(secondViewController, animated: true)
                
            } else {
                if let errorString = error!.userInfo["error"] as? String {
                    self.errorMessage = errorString
                    print(self.errorMessage)
                }
                self.displayAlert("Failed Login", message: self.errorMessage)
               
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            self.performSegue(withIdentifier: "startapp", sender: self)
        }
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
        if txtUsername.hasText { usernamePlaceHolder = txtUsername.text!}
        print(usernamePlaceHolder)
        
    }
     func textFieldDidBeginEditing(_ textField: UITextField) {
        loginScroll.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
    }
    
    
    func textFieldShouldReturn (_ textField: UITextField!) -> Bool{
        if ((textField == txtUsername)){
            txtPassword.becomeFirstResponder();
        } else if (textField == txtPassword){
            textField.resignFirstResponder()
            loginScroll.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        return true
    }
    
    func processNewUser() {
        if PFUser.current() != nil {
            self.performSegue(withIdentifier: "startapp", sender: self)
        }
        let requestParameters = ["fields": "id, email, first_name, last_name"]
        let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)
        userDetails?.start { (connection, result, error) -> Void in
            if error != nil {
                print("\(error?.localizedDescription)")
                return
            }
            if result != nil {
                //let dict = result as? [String:[AnyObject]]
            
                //save stuff to parse
                let myUser = PFUser.current()
                
                if let firstName = result.value(forKey: "first_name") as? String{
                    print(firstName)
                    myUser?.setObject(firstName, forKey: "firstName")
                }
                if let lastName = result.value(forKey: "last_name") as? String {
                    print(lastName)
                    myUser?.setObject(lastName, forKey: "lastName")
                }
                if let email = result.value(forKey: "email") as? String {
                    print(email)
                    myUser?.setObject(email, forKey: "email")
                }
                let communityStart = ["entrepreneur"]
                myUser?.setObject(communityStart, forKey: "community")
                
               myUser?.saveInBackground(block: { (success, error) -> Void in
                if error != nil {
                    print(error)
                    return
                }
                if success { print("details updated in parse from FB")}
               })
                
                
            }
        }
        
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

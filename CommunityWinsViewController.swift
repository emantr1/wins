//
//  CommunityWinsViewController.swift
//  classified
//
//  Created by Eman I on 4/17/16.
//  Copyright © 2016 Eman
//

import UIKit
import Parse

class CommunityWinsViewController: UIViewController {

    @IBAction func saveButton(_ sender: AnyObject) {
        self.activityIndicator.startAnimating()
        //do the parse stuff here
        self.activityIndicator.stopAnimating()
    }
    @IBOutlet var entrebutton: UIButton!
    @IBOutlet var entreCheckmark: UILabel!
    @IBAction func entreTap(_ sender: AnyObject) {
        if entre == true {
            buttonOff(entrebutton, checkmark: entreCheckmark)
            entre = false
            
        } else {
            buttonOn(entrebutton, checkmark: entreCheckmark)
            entre = true
        }
    }
    @IBOutlet var bballButton: UIButton!
    @IBOutlet var bballCheckmark: UILabel!
    @IBAction func bballTap(_ sender: AnyObject) {
        if bball == true {
            buttonOff(bballButton, checkmark: bballCheckmark)
            bball = false
            
        } else {
            buttonOn(bballButton, checkmark: bballCheckmark)
            bball = true
        }
    }
    @IBOutlet var oldschoolButton: UIButton!
    @IBOutlet var oldschoolCheckmark: UILabel!
    @IBAction func oldschoolTap(_ sender: AnyObject) {
        if oldschool == true {
            buttonOff(oldschoolButton, checkmark: oldschoolCheckmark)
            oldschool = false
            
        } else {
            buttonOn(oldschoolButton, checkmark: oldschoolCheckmark)
            oldschool = true
        }
    }
    var entre = false
    var bball = false
    var oldschool = false
    var userSelection = [String]()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidAppear(_ animated: Bool) {
        controllerToStayOn = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()

        
        //start all buttons off and check parse to see what should be on
        buttonOff(entrebutton, checkmark: entreCheckmark)
        buttonOff(bballButton, checkmark: bballCheckmark)
        buttonOff(oldschoolButton, checkmark: oldschoolCheckmark)
        
        //pull user selection from Parse
        let userQuery = PFUser.query()
        userQuery!.getObjectInBackground(withId: currentUserId!) {
            (user: PFObject?, error: NSError?) -> Void in
            if error == nil && user != nil {
               
                    if user!["community"] != nil {
                        self.userSelection = user!["community"] as! [String]
                        for i in 0 ..< self.userSelection.count {
                            if self.userSelection[i] == "90s" {
                                self.buttonOn(self.oldschoolButton, checkmark: self.oldschoolCheckmark)
                                self.oldschool = true
                            }
                            if self.userSelection[i] == "entrepreneur" {
                                self.buttonOn(self.entrebutton, checkmark: self.entreCheckmark)
                                self.entre = true
                            }
                            if self.userSelection[i] == "basketball" {
                                self.buttonOn(self.bballButton, checkmark: self.bballCheckmark)
                                self.bball = true
                            }
                            self.activityIndicator.stopAnimating()
                        }
                    } else {
                        print("has no selections")
                        self.activityIndicator.stopAnimating()
                }
                
            } else {
                if error != nil {print(error)}
            }
        }
        
        // Do any additional setup after loading the view.
        
        let background = CAGradientLayer().greenLayer()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)

    }

    func buttonOn (_ button: UIButton, checkmark: UILabel) {
        
        button.layer.cornerRadius = 14.0
        button.clipsToBounds = true
        button.layer.borderColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0).cgColor
        button.layer.borderWidth = 3.0
        button.alpha = 1.0
        checkmark.layer.cornerRadius = entreCheckmark.frame.size.width / 2
        checkmark.clipsToBounds = true
        checkmark.textColor = UIColor.green
        checkmark.isHidden = false
        
    }
    
    func buttonOff (_ button: UIButton, checkmark: UILabel) {
        button.layer.cornerRadius = 14.0
        button.clipsToBounds = true
        button.layer.borderWidth = 0.0
        button.alpha = 0.5
        checkmark.isHidden = true
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


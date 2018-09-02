//
//  TermsViewController.swift
//  Wins
//
//  Created by Eman I on 5/19/16.
//  Copyright © 2016 Eman. All rights reserved.
//

import UIKit
import Parse

class TermsViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        let background = CAGradientLayer().greenLayer()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)
        
        
        
        let termQuery = PFQuery(className: "Terms")
        termQuery.getFirstObjectInBackground { (object, error) in
            if object != nil && error == nil {
                if object!["termText"] != nil {
                    self.textView.text = object!["termText"] as? String
                    self.textView.textColor = UIColor.white
                    self.textView.font = UIFont.systemFont(ofSize: 15.0)
                    
                    print("grabbed it")
                }
            }
        }
        // Do any additional setup after loading the view.
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

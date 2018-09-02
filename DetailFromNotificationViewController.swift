//
//  DetailFromNotificationViewController.swift
//  classified
//
//  Created by Eman I on 4/19/16.
//  Copyright © 2016 Eman
//

import UIKit
import Parse

@available(iOS 9.0, *)
class DetailFromNotificationViewController: UIViewController {

    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var scrollImg : UIScrollView!
    @IBOutlet var winImage : UIImageView!
    @IBOutlet var winTitle : UILabel!
    
    // @IBOutlet var winEmoji: UILabel!
    
    
    @IBOutlet var winDetails: UITextView!
  
    
    
    //if plan to add social
    @IBAction func tapIG(_ sender: AnyObject) {
    }
    @IBAction func tapTwitter(_ sender: AnyObject) {
    }
    @IBAction func tapFB(_ sender: AnyObject) {
    }
    @IBOutlet var fbButton: UIButton!
    @IBOutlet var twButton: UIButton!
    @IBOutlet var igButton: UIButton!
    var emojiString = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controllerToStayOn = true
        // scrollImg.contentSize = CGSizeMake(960, scrollImg.contentSize.height)
        // Do any additional setup after loading the view.
        fbButton.isHidden = true
        twButton.isHidden = true
        igButton.isHidden = true
        
        let winId = appDelegate.messageKey
        
        let win = PFQuery(className:"Wins")
        win.getObjectInBackground(withId: winId) {
            (info: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let info = info {
                self.winTitle.text = info["feeling"] as? String
                self.emojiString = (info["emoji"] as? String)!
                self.winDetails.text = info["details"] as? String
                
                let index = self.emojiString.characters.index(self.emojiString.startIndex, offsetBy: 0)
                let winEmoji = "\(self.emojiString[index])"
                self.winTitle.text = "\(winEmoji) \(self.winTitle.text!)"
                
                if info["image"] != nil {
                    let currentWinImage = info["image"] as! PFFile
                    currentWinImage.getDataInBackground { (data, error) -> Void in
                        if error == nil {
                            if let downloadedImage = UIImage(data: data!) {
                                self.winImage.image = downloadedImage
                            }
                        } else {
                            self.winImage.image = UIImage(named: "Relaxed.jpeg")
                        }
                    }
                } else {
                    let originalEmoji = self.emojiString
                    let sliced = String(originalEmoji.characters.dropFirst())
                    self.winImage.image = UIImage(named:"\(sliced).jpeg")
                    
                }

            }
        }
        
        
        
        
        
        
        //let str: String! = self.restorationIdentifier
        //if fromLocation == "Search" || fromLocation == "Favs"
        let background = CAGradientLayer().greenLayer()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
            controllerToStayOn = true
        
           }
    
    
    
    
    @IBAction func backBtnTapped (_ sender : UIButton) {
        appDelegate.switchRootControllers()
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

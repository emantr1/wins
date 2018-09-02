//
//  RefineNotificationsViewController.swift
//  classified
//
//  Created by Eman I on 4/18/16.
//  Copyright © 2016 Eman
//

import UIKit
import Parse

@available(iOS 9.0, *)
class RefineNotificationsViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var curvedWhite: UILabel!
    @IBOutlet var signature: UILabel!
    @IBOutlet var fadedBack: UILabel!
    @IBOutlet var firstMessage: UILabel!
    @IBOutlet var happyStayTut: UIImageView!
    
    @IBOutlet var happyStayMessage: UILabel!
    @IBOutlet var happyStopTut: UIImageView!
    @IBOutlet var happyStopMessage: UILabel!
    @IBOutlet var sadTut: UIImageView!
    @IBOutlet var sadMessage: UILabel!
    @IBOutlet var okCool: UIButton!
    @IBAction func okCoolTap(_ sender: AnyObject) {
        
         Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(RefineNotificationsViewController.introTut(_:)), userInfo: true, repeats: false)
        
        tutCountNotif = 1
        
         UserDefaults.standard.set(tutCountNotif, forKey: "tutCountNotif")
    }
    @IBOutlet var thumb: UILabel!
    @IBOutlet var categoryName: UILabel!
    @IBOutlet var backImage: UIImageView!
    @IBOutlet var textBox: UILabel!
    @IBOutlet var curveEdges: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var sadButton: UIButton!
    @IBOutlet var happyStopButton: UIButton!
    @IBOutlet var happyStayButton: UIButton!
    var likeArray = [""]
    var dislikeArray = [""]

    @IBOutlet var flagButton: UIButton!
    var motivateId = ""
    var titleArray = [""]
    @IBAction func tapFlag(_ sender: AnyObject) {
        
        //alert that says thanks for reporting - then add to their list of nos
        displayAlert("Something Wrong?", message:"Is there something fishy about this message?  Hit 'Probs' if there's an issue or 'All Good' if everything's cool")
        
    }
    
    
    func displayAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "All Good", style: .default, handler: { (action) -> Void in
            //self.dismissViewControllerAnimated(true, completion: nil)
     
        }))
        
        alert.addAction(UIAlertAction(title: "Probs", style: .default, handler: { (alert: UIAlertAction!) in
            
            let commQuery = PFQuery(className: "Community")
            commQuery.getObjectInBackground(withId: self.motivateId) {
                (message: PFObject?, error: NSError?) -> Void in
                if error == nil && message != nil {
                    message?.incrementKey("dislikes", byAmount: 1)
                    if message!["likes"] != nil && message!["likes"] as! NSNumber != 0 {
                        
                        var dlikes = 0.0
                        let likes = Double(message!["likes"] as! NSNumber)
                        if message!["dislikes"] != nil {dlikes = Double(message!["dislikes"] as! NSNumber)}
                        
                        
                        let rateScore = (likes / (likes + dlikes))*100
                        
                        message!["score"] = rateScore as NSNumber
                    }
                } else {
                    if error != nil {print(error)}
                }
                message?.saveInBackground()
            }
            
            let commTypes = PFQuery(className: "CommTypes")
            commTypes.whereKey("nameId", containedIn: self.titleArray)
            commTypes.limit = 1000
            //commTypes.cachePolicy = PFCachePolicy.CacheElseNetwork
            commTypes.findObjectsInBackground() { (objects, error) -> Void in
                if let objects = objects {
                    for object in objects {
                        object.incrementKey("totalDislikes")
                        object.saveInBackground()
                    }
                }
            }
            
            self.dislikeArray[0] = self.motivateId
            if noLikeArray != nil {
                noLikeArray!.append(self.motivateId)
            } else {
                noLikeArray = self.dislikeArray
            }
            let flagQuery = PFObject(className: "Flagged")
            flagQuery["probId"] = self.motivateId
            flagQuery["probPointer"] = PFObject(outDataWithClassName:"Community", objectId: self.motivateId)
            flagQuery["reportingUser"] = currentUser
            flagQuery.saveInBackground()
            
            
            UserDefaults.standard.set(noLikeArray, forKey: "noLikeArray")
            
            self.display2("Thanks!", message: "We'll take a look at this message and take care of the issues we find.  Thanks for flagging.")
            
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    func display2(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok, Cool", style: .default, handler: { (action) -> Void in
            //self.dismissViewControllerAnimated(true, completion: nil)
            
            
            self.leaveThisPage()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tapHappyStay(_ sender: AnyObject) {
        
        let commQuery = PFQuery(className: "Community")
        commQuery.getObjectInBackground(withId: motivateId) {
            (message: PFObject?, error: NSError?) -> Void in
            if error == nil && message != nil {
                message?.incrementKey("likes", byAmount: 1)
                if message!["likes"] != nil && message!["likes"] as! NSNumber != 0 {
                    
                    var dlikes = 0.0
                    let likes = Double(message!["likes"] as! NSNumber)
                    if message!["dislikes"] != nil {dlikes = Double(message!["dislikes"] as! NSNumber)}
                    
                    
                    let rateScore = (likes / (likes + dlikes))*100
                    
                    message!["score"] = rateScore as NSNumber
                }
            } else {
                if error != nil {print(error)}
            }
            message?.saveInBackground()
        }
        
        //if titleArray != [""] {let key = titleArray[0]}
        let commTypes = PFQuery(className: "CommTypes")
        commTypes.whereKey("nameId", containedIn: titleArray)
        commTypes.limit = 1000
        //commTypes.cachePolicy = PFCachePolicy.CacheElseNetwork
        commTypes.findObjectsInBackground() { (objects, error) -> Void in
            if let objects = objects {
                for object in objects {
                    object.incrementKey("totalLikes")
                    if object["totalLikes"] != nil && object["totalLikes"] as! NSNumber != 0 {
                        
                        var dlikes = 0.0
                        let likes = Double(object["totalLikes"] as! NSNumber)
                        if object["totalDislikes"] != nil {dlikes = Double(object["totalDislikes"] as! NSNumber)}
                        
                        
                        let rateScore = (likes / (likes + dlikes))*100
                        
                        object["score"] = rateScore as NSNumber
                    }
                    object.saveInBackground()
                }
            }
        }
        goHome(happyStayButton)
    }
    @IBAction func tapHappy(_ sender: AnyObject) {
        
        let commQuery = PFQuery(className: "Community")
        commQuery.getObjectInBackground(withId: motivateId) {
            (message: PFObject?, error: NSError?) -> Void in
            if error == nil && message != nil {
                message?.incrementKey("likes", byAmount: 1)
                if message!["likes"] != nil && message!["likes"] as! NSNumber != 0 {
                    
                    var dlikes = 0.0
                    let likes = Double(message!["likes"] as! NSNumber)
                    if message!["dislikes"] != nil {dlikes = Double(message!["dislikes"] as! NSNumber)}
                    
                    
                    let rateScore = (likes / (likes + dlikes))*100
                    
                    message!["score"] = rateScore as NSNumber
                }
            } else {
                if error != nil {print(error)}
            }
            message?.saveInBackground()
        }

        //if titleArray != [""] {let key = titleArray[0]}
        let commTypes = PFQuery(className: "CommTypes")
        commTypes.whereKey("nameId", containedIn: titleArray)
        commTypes.limit = 1000
        //commTypes.cachePolicy = PFCachePolicy.CacheElseNetwork
        commTypes.findObjectsInBackground() { (objects, error) -> Void in
            if let objects = objects {
                for object in objects {
                    object.incrementKey("totalLikes")
                    if object["totalLikes"] != nil && object["totalLikes"] as! NSNumber != 0 {
                        
                        var dlikes = 0.0
                        let likes = Double(object["totalLikes"] as! NSNumber)
                        if object["totalDislikes"] != nil {dlikes = Double(object["totalDislikes"] as! NSNumber)}
                        
                        
                        let rateScore = (likes / (likes + dlikes))*100
                        
                        object["score"] = rateScore as NSNumber
                    }
                    object.saveInBackground()
                }
            }
        }
        //add to the array of stuff they don't want to see
        dislikeArray[0] = motivateId
        if noLikeArray != nil {
            noLikeArray!.append(motivateId)
        } else {
            noLikeArray = dislikeArray
        }
        UserDefaults.standard.set(noLikeArray, forKey: "noLikeArray")
        print(noLikeArray)
        goHome(happyStopButton)
    }
    
    @IBAction func tapSad(_ sender: AnyObject) {
        
        let commQuery = PFQuery(className: "Community")
        commQuery.getObjectInBackground(withId: motivateId) {
            (message: PFObject?, error: NSError?) -> Void in
            if error == nil && message != nil {
                message?.incrementKey("dislikes", byAmount: 1)
                if message!["likes"] != nil && message!["likes"] as! NSNumber != 0 {
                    
                    var dlikes = 0.0
                    let likes = Double(message!["likes"] as! NSNumber)
                    if message!["dislikes"] != nil {dlikes = Double(message!["dislikes"] as! NSNumber)}
                    
                    
                    let rateScore = (likes / (likes + dlikes))*100
                    
                    message!["score"] = rateScore as NSNumber
                }
            } else {
                if error != nil {print(error)}
            }
            message?.saveInBackground()
        }
        
        let commTypes = PFQuery(className: "CommTypes")
        commTypes.whereKey("nameId", containedIn: titleArray)
        commTypes.limit = 1000
        //commTypes.cachePolicy = PFCachePolicy.CacheElseNetwork
        commTypes.findObjectsInBackground() { (objects, error) -> Void in
            if let objects = objects {
                for object in objects {
                    object.incrementKey("totalDislikes")
                    if object["totalLikes"] != nil && object["totalLikes"] as! NSNumber != 0 {
                        
                        var dlikes = 0.0
                        let likes = Double(object["totalLikes"] as! NSNumber)
                        if object["totalDislikes"] != nil {dlikes = Double(object["totalDislikes"] as! NSNumber)}
                        
                        
                        let rateScore = (likes / (likes + dlikes))*100
                        
                        object["score"] = rateScore as NSNumber
                    }
                    object.saveInBackground()
                }
            }
        }
        
        dislikeArray[0] = motivateId
        if noLikeArray != nil {
            noLikeArray!.append(motivateId)
        } else {
            noLikeArray = dislikeArray
        }
        UserDefaults.standard.set(noLikeArray, forKey: "noLikeArray")
        print(noLikeArray)
        goHome(sadButton)
    }
    
    var possibleImages = ["Smiling","Blushing","Yum","Relaxed","Crazy Face","Relieved","Smirk or Flirty","Smiling while Sweating","Laughing Tears","Cool","Heart Eyes","Rich","Genius","Hugs","Winking","Kissing Heart","Innocent","Grinning","Wow","Clapping","Raised Hands","Praying","Strong","Peace","Thumbs Up","Rock On","Fist Bump","Heart","Glowing Star","Fire","One Hundred","Key","Tools","Artist","Celebration","Rose","Dragon","Crown","Ghost"]
    @IBAction func goBack(_ sender: AnyObject) {
       
        thumb.isHidden = false
        
        UIView.animate(withDuration: 3.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            
            //self.thumb.center = self.view.center//CGPoint(x:67.5, y:20)
            self.thumb.alpha = 0
            
            
            }, completion: nil)
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            
            //self.thumb.center = self.view.center//CGPoint(x:67.5, y:20)
            
            
            
            }, completion: nil)
        
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(RefineNotificationsViewController.leaveThisPage), userInfo: nil, repeats: false)
        
        
    }
    
    func goHome (_ button: UIButton) {
        let possibleThumbs = ["🐣","🐬","☘","🎄","🎃","🌞","👻","🤖","👍","✌️","👌","👀","🕵","🎅","👸","🐶","🐰","🐼","🐯","🐸","🐵","☃️","🍓","🍾","🍻","🍭","🎂","🍧","🍿","🎭","🎯","🚀","🌇","🏖","🌅","🌉","💎","🔮","🛎","🎈","🎊","⚡","💡","🕹","🎰"]
        let picChoice = Int(arc4random_uniform(UInt32(possibleThumbs.count)))
        thumb.text = "\(possibleThumbs[picChoice]) Got It!"
        thumb.isHidden = false
        button.isHidden = false
        UIView.animate(withDuration: 4.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            
            //self.thumb.center = self.view.center//CGPoint(x:67.5, y:20)
            self.thumb.alpha = 0
            
            
            }, completion: nil)
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            
            //self.thumb.center = self.view.center//CGPoint(x:67.5, y:20)
            //button.alpha = 0
            button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            
            }, completion: { finish in
                UIView.animate(withDuration: 0.3, animations: {
                    button.transform = CGAffineTransform.identity
                })})
        
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(RefineNotificationsViewController.leaveThisPage), userInfo: nil, repeats: false)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controllerToStayOn = true
        print("we came here")
       
        motivateId = appDelegate.messageKey
        print("this is the message key being used \(motivateId)")
        
        let motivate = PFQuery(className:"Community")
        motivate.getObjectInBackground(withId: motivateId) {
            (info: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            }
            else {
                if info!["category"] != nil {
                    self.titleArray = info!["category"] as! [String]
                    
                    for i in 0..<self.titleArray.count {
                       self.categoryName.text = self.categoryName.text! + " \(self.titleArray[i])"
                    }
                }
                if info!["author"] != nil {
                    let name = info!["author"] as! String
                    self.signature.text = "from: \(name)"
                } else {
                    self.signature.isHidden = true
                }
            }
        }

        
        
        fadedBack.isHidden = true
        firstMessage.isHidden = true
        happyStayTut.isHidden = true
        happyStayTut.layer.cornerRadius = 10.0
        happyStayMessage.isHidden = true
        happyStopTut.isHidden = true
        happyStopTut.layer.cornerRadius = 10.0
        happyStopMessage.isHidden = true
        sadTut.isHidden = true
        sadTut.layer.cornerRadius = 10.0
        sadMessage.isHidden = true
        okCool.isHidden = true
        okCool.layer.cornerRadius = 3.0
        okCool.clipsToBounds = true
        okCool.layer.borderColor = UIColor(red: 25/255.0, green: 169/255.0, blue: 255/255.0, alpha: 1.0).cgColor
        okCool.layer.borderWidth = 2.0

      
        thumb.isHidden = true
        thumb.alpha = 1
        textBox.layer.cornerRadius = 9.0
        textBox.clipsToBounds = true
        curveEdges.layer.cornerRadius = 9.0
        curveEdges.clipsToBounds = true
        curvedWhite.layer.cornerRadius = 9.0
        curvedWhite.clipsToBounds = true
        textBox.text = appDelegate.messageToSend
        if appDelegate.messageToSend.characters.count > 300 {
            textBox.font = UIFont(name:"HelveticaNeue-Thin", size: 14)
        }
        //appdelegate type hiphop entre etc
        //appdelegate object id so update like to dislike
        
        let randIndex = Int (arc4random_uniform(UInt32(possibleImages.count)))
        backImage.image = UIImage(named: "\(possibleImages[randIndex]).jpeg")
        // Do any additional setup after loading the view.
        
        let userQuery = PFUser.query()
        userQuery!.getObjectInBackground(withId: currentUserId!) {
            (user: PFObject?, error: NSError?) -> Void in
            if error == nil && user != nil {
                user?.incrementKey("respondCount", byAmount: 1)
            } else {
                if error != nil {print(error)}
            }
            user?.saveInBackground()
        }

        
    }

    override func viewDidAppear(_ animated: Bool) {
        controllerToStayOn = true
        
        if tutCountNotif == 0 {
            //let state = false
            
            //some check to make sure user defaults needs to show tut
            Timer.scheduledTimer(timeInterval: TimeInterval(1.0), target: self, selector: #selector(RefineNotificationsViewController.introTut(_:)), userInfo: false, repeats: false)
        }

    }
    
    func introTut (_ state: Timer) {
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFromTop
        self.view.layer.add(transition, forKey: nil)
        
        
        fadedBack.isHidden = state.userInfo as! Bool
        firstMessage.isHidden = state.userInfo as! Bool
        happyStayTut.isHidden = state.userInfo as! Bool
        happyStayMessage.isHidden = state.userInfo as! Bool
        happyStopTut.isHidden = state.userInfo as! Bool
        happyStopMessage.isHidden = state.userInfo as! Bool
        sadTut.isHidden = state.userInfo as! Bool
        sadMessage.isHidden = state.userInfo as! Bool
        okCool.isHidden = state.userInfo as! Bool
        
        
    }
    
    func leaveThisPage () {
        
        appDelegate.switchRootControllers()
        
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

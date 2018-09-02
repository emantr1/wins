//
//  FeelingViewController.swift
//  classified
//
//Created by Eman Igbinosa 4/1/2016.
//

import UIKit
import Crashlytics
import Parse

class FeelingViewController: UIViewController, UITextFieldDelegate {

    @IBAction func okButton(_ sender: AnyObject) {
        Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(FeelingViewController.introTut(_:)), userInfo: true, repeats: false)
        
        tutCount = 0
        tutCountMore = 1
        UserDefaults.standard.set(tutCount, forKey: "tutCount")
        
        winTitle.isHidden = false
        tellTitle.isHidden = false
        textField.isHidden = false

    }
    
    
    @IBAction func tapToStart(_ sender: AnyObject) {
        
        Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(FeelingViewController.introTut(_:)), userInfo: false, repeats: false)
        startTut.isHidden = true
    }
    @IBOutlet var startTut: UIButton!
    @IBOutlet var tutImage: UIImageView!
    @IBOutlet var blueLine: UILabel!
    @IBOutlet var introTwo: UILabel!
    @IBOutlet var introOne: UILabel!
    @IBOutlet var fadedBackground: UILabel!
    @IBOutlet var okCool: UIButton!
    var numViewsThisController = 0
    @IBOutlet var tellTitle: UILabel!
    @IBOutlet var winTitle: UILabel!
    @IBOutlet var textField: UITextField!
    var winList = ["Crushed It!",
                   "Coolness Ensues!",
                   "Way to Ball Out!",
                   "Small win? BIG WIN?",
                   "Winning Time!",
                   "BAWSE!"]

    var tellList = ["Describe it with a couple words",
                   "Cool! What's the headline?",
                   "Nice! What would you title it?"]

    
    @IBOutlet var nextButton: UIButton!
    let limitLength = 23
    
    @IBAction func tapNext(_ sender: AnyObject) {
        if textField.hasText {
        currentWinFeeling = textField.text!
        feelingPlaceholder = textField.text!
        }
        
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController!.view.layer.add(transition, forKey: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blueLine.isHidden = true
        introTwo.isHidden = true
        introOne.isHidden = true
        tutImage.isHidden = true
        startTut.isHidden = true
        fadedBackground.isHidden = true
        okCool.isHidden = true
        okCool.layer.cornerRadius = 4.0
        okCool.clipsToBounds = true
        okCool.layer.borderColor = UIColor(red: 25/255.0, green: 169/255.0, blue: 255/255.0, alpha: 1.0).cgColor
        okCool.layer.borderWidth = 2.0
        // test crashlytics with this code Crashlytics.sharedInstance().crash()
        
        self.textField.delegate = self
        startTut.layer.cornerRadius = 10.0
        startTut.clipsToBounds = true
        
        nextButton.isHidden = true
        numTimesOnApp += 1
        UserDefaults.standard.set(numTimesOnApp, forKey: "numTimesOnApp")
        print("this is how many times on app \(numTimesOnApp)")
        if numTimesOnApp <= 3 {
            startTut.isHidden = false
            winTitle.isHidden = true
            tellTitle.isHidden = true
            textField.isHidden = true
        } else {
            startTut.isHidden = true
            winTitle.isHidden = false
            tellTitle.isHidden = false
            textField.isHidden = false

        }
       
        if numTimesOnApp > 4 && UIApplication.shared.isRegisteredForRemoteNotifications == false {
            UIApplication.shared.registerForRemoteNotifications()
            let currentInstallation: PFInstallation = PFInstallation.current()
            currentInstallation.add("personal_\(currentUserId!)", forKey: "channels")
            try! currentInstallation.save()
        }
        
        //figure out if we need to ask for notifs permission
        if let settings = UIApplication.shared.currentUserNotificationSettings
        {
            if settings.types.contains([.alert, .sound, .badge])
            {
                //Have alert and sound permissions
                print("contains alerts and sounds and badges")
            }
            else if settings.types.contains(.alert)
            {
                //Have alert permission
                print("contains alerts")
            }
            else if !(settings.types.contains([.alert, .sound, .badge])) {
                print("doesnt contain any of the three")
                if numTimesOnApp < 2 {
                    print(numTimesOnApp)
                    enableNotifs()
                }
                if numTimesOnApp == 5 {
                   // enableNotifs()// gotta add a function that sends to phone settings
                }
                // can also use numTimesOnApp here to show pic with custom button and take to settings in phone to change notifications
                
            }
        }
        
        
       
        // Do any additional setup after loading the view.
        
        //check seen vs notifs to be sent and replenish if necessary
        if notifsToBeSent != nil && notifsToBeSent!.count < 3 {
            if seenNotifs != nil && seenNotifs!.count > 1 {
                seenNotifs = [String]()
                print("resetting the seen notifications and so we can refill notifs to send out")
                UserDefaults.standard.set(seenNotifs, forKey: "seenNotifs")
            }
        }
 
        if numTimesOnApp > 8 && askedForReview == 0 {
            //and they haven't already given review - check user defaults
            userStatus("Hey There!", message: "How has the app been treating you so far?")
            askedForReview = 1
            UserDefaults.standard.set(askedForReview, forKey: "askedForReview")
        }
        
     }

    
    func introTut (_ state: Timer) {
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFromTop
        if self.navigationController != nil {
        self.navigationController!.view.layer.add(transition, forKey: nil)
        }

        
        blueLine.isHidden = state.userInfo as! Bool
        introTwo.isHidden = state.userInfo as! Bool
        introOne.isHidden = state.userInfo as! Bool
        tutImage.isHidden = state.userInfo as! Bool
        fadedBackground.isHidden = state.userInfo as! Bool
        okCool.isHidden = state.userInfo as! Bool

        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //textField code
        
        //textField.resignFirstResponder()  //if desired
        if textField.hasText {
            currentWinFeeling = textField.text!
            feelingPlaceholder = textField.text!
        }
        
        
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController!.view.layer.add(transition, forKey: nil)
        self.performSegue(withIdentifier: "toEmoji", sender: self)

        return true
    }
   func enableNotifs () {
    
        let title = "Notifications"
        
        let alertController = UIAlertController(title: title, message: "Wins only works if notifications are on so please enable them to get the full experience.  #WinLife", preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK, Cool", style: UIAlertActionStyle.default, handler: { alertAction in
            alertController.dismiss(animated: true, completion: nil)
            
            let notificationSettings = UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notificationSettings)
            UIApplication.shared.registerForRemoteNotifications()
            let currentInstallation: PFInstallation = PFInstallation.current()
            currentInstallation.add("personal_\(currentUserId!)", forKey: "channels")
            try! currentInstallation.save()
            
        })
        alertController.addAction(UIAlertAction(title: "Why", style: .default, handler: { (alert: UIAlertAction!) in
            
                self.whyNotifs()
            
        }))
        
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
        
    }

    func whyNotifs () {
        
        let title = "The Magic of Reminders"
        
        let alertController = UIAlertController(title: title, message: "The stuff we send is proven to help you stay on top of your game.  You can also adjust frequency or turn them off on the Win settings page.  #StayUndefeated", preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK, Cool", style: UIAlertActionStyle.default, handler: { alertAction in
            
            alertController.dismiss(animated: true, completion: nil)
            
            let notificationSettings = UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notificationSettings)
            UIApplication.shared.registerForRemoteNotifications()
            
            let currentInstallation: PFInstallation = PFInstallation.current()
            currentInstallation.add("personal_\(currentUserId!)", forKey: "channels")
            try! currentInstallation.save()
        })
        alertController.addAction(UIAlertAction(title: "Maybe Later", style: .default, handler: { (alert: UIAlertAction!) in
            let state = false
            numTimesOnApp += 1
            print("this is how many time bb s on app \(numTimesOnApp)")
            UserDefaults.standard.set(numTimesOnApp, forKey: "numTimesOnApp")
            //some check to make sure user defaults needs to show tut
            //NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1.0), target: self, selector: #selector(FeelingViewController.introTut(_:)), userInfo: state, repeats: false)
            
           
        }))
        
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
        
    }

    func introFromDelegate () {
        let state = false
        
        //some check to make sure user defaults needs to show tut
        Timer.scheduledTimer(timeInterval: TimeInterval(1.0), target: self, selector: #selector(FeelingViewController.introTut(_:)), userInfo: state, repeats: false)

    }
    
    func respond(_ gesture: UIGestureRecognizer)  {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.up:
                self.tabBarController?.tabBar.isHidden = false
            case UISwipeGestureRecognizerDirection.down:
                self.tabBarController?.tabBar.isHidden = true
            case UISwipeGestureRecognizerDirection.left:
                if textField.hasText {
                    currentWinFeeling = textField.text!
                    feelingPlaceholder = textField.text!
                    self.performSegue(withIdentifier: "toEmoji", sender: self)
                }
                
                
            default:
                break
            }
        }
        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkNext () {
        if textField.hasText == true {
            nextButton.isHidden = false
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(FeelingViewController.respond(_:)))
            swipeLeft.direction = .left
            view.addGestureRecognizer(swipeLeft)
        } else {
            nextButton.isHidden = true
        }
    }
    override func viewDidAppear(_ animated: Bool) {

        print("appear value of tutcount \(tutCount)")
        if tutCount == 2 {
            Timer.scheduledTimer(timeInterval: TimeInterval(1.0), target: self, selector: #selector(FeelingViewController.introTut(_:)), userInfo: false, repeats: false)
        }
        
        controllerToStayOn = false
        
        if numViewsThisController != viewsFromOtherControllers {
        let randomNum = Int(arc4random_uniform(UInt32(tellList.count)))
        tellTitle.text = tellList[randomNum]
        //let randomNum2 = Int(arc4random_uniform(UInt32(winList.count)))
        //winTitle.text = winList[randomNum2]
        numViewsThisController = viewsFromOtherControllers
        
        }
        
        if textField.hasText == true && feelingPlaceholder == "" {
            textField.text?.removeAll()
            textField.resignFirstResponder()
        }
        showTheBar = true
       
        if showTheBar == true || numTimesOnApp > 3 {
            
            self.tabBarController?.tabBar.isHidden = false
        } else {
            
            self.tabBarController?.tabBar.isHidden = true
        }
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(FeelingViewController.respond(_:)))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(FeelingViewController.respond(_:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(FeelingViewController.checkNext), userInfo: nil, repeats: true)

        let app:UIApplication = UIApplication.shared
        
        if app.scheduledLocalNotifications != nil && app.scheduledLocalNotifications!.count != 0 {
        let fireDateDesc: NSSortDescriptor = NSSortDescriptor(key: "fireDate", ascending: true)
        let allNotifs: NSArray = UIApplication.shared.scheduledLocalNotifications! as NSArray
        let sortedNotifs: NSArray = allNotifs.sortedArray(using: [fireDateDesc])
        let notificationFirst = sortedNotifs[0] as! UILocalNotification
        let unitFlags: NSCalendar.Unit = [.hour, .minute, .year, .month, .day, .timeZone]
        let newcomponents = (Calendar.current as NSCalendar).components(unitFlags, from: notificationFirst.fireDate!)
        print("this is the Next ONE TO GO OUT \(newcomponents.month)-\(newcomponents.day)-\(newcomponents.year) Time\(newcomponents.hour):\(newcomponents.minute) TimeZone:\((newcomponents as NSDateComponents).timeZone!)")
            if PFUser.current() != nil {
                let userQuery = PFUser.query()
                userQuery!.getObjectInBackground(withId: currentUserId!) {
                    (user: PFObject?, error: NSError?) -> Void in
                    if error == nil && user != nil {
                        user?["nextNotif"] = "\(newcomponents.month)-\(newcomponents.day)-\(newcomponents.year) Time\(newcomponents.hour):\(newcomponents.minute) TimeZone:\((newcomponents as NSDateComponents).timeZone!)"
                    } else {
                        if error != nil {print(error)}
                    }
                    user?.saveInBackground()
                }
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        textField.resignFirstResponder()
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func userStatus(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "😊", style: .default, handler: { (action) -> Void in
            self.askForReview("Excellent!", message: "Could you help us out and give us a review?")
            
        }))
        alert.addAction(UIAlertAction(title: "😒", style: .default, handler: { (action) -> Void in
            self.askForFeedback("Feeback", message: "Could you help us out and tell us what could be better?")
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func askForFeedback(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Maybe Later", style: .default, handler: { (action) -> Void in
            
        }))
        alert.addAction(UIAlertAction(title: "Sure, Ok", style: .default, handler: { (action) -> Void in
            self.performSegue(withIdentifier: "improveSegue2", sender: self)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func askForReview(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Maybe Later", style: .default, handler: { (action) -> Void in
            
        }))
        alert.addAction(UIAlertAction(title: "Sure, Ok", style: .default, handler: { (action) -> Void in
            //send to appstore
            UIApplication.shared.openURL(URL(string :"itms-apps://itunes.apple.com/app/id1108683636")!)
            //save userdefaults
            
        }))
        
        self.present(alert, animated: true, completion: nil)
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

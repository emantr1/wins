//
//  FinalPostViewController.swift
//  classified
//Created by Eman Igbinosa 4/1/2016.
//

import UIKit
import AVFoundation
import Contacts
import ContactsUI
import Parse
import MessageUI

@available(iOS 9.0, *)
class FinalPostViewController: UIViewController, CNContactPickerDelegate, MFMessageComposeViewControllerDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBAction func tapBack(_ sender: AnyObject) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFromTop
        self.navigationController!.view.layer.add(transition, forKey: nil)
        self.navigationController?.popViewController(animated: false)
    }
    @IBOutlet var squadLabel: UILabel!
    var player:AVAudioPlayer = AVAudioPlayer()
    var contacts = [CNContact]()
    var publicWin = false
    var emptyImageView: UIImageView!
    var numbersLeft = [String]()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    @IBAction func okButton(_ sender: AnyObject) {
        Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(FinalPostViewController.introTut(_:)), userInfo: true, repeats: false)
        
        introThreeCount += 1
    }
    @IBOutlet var blueLine: UILabel!
    @IBOutlet var tutImage: UIImageView!
    @IBOutlet var introThree: UILabel!
    @IBOutlet var introTwo: UILabel!
    @IBOutlet var introOne: UILabel!
    @IBOutlet var fadedBackground: UILabel!
    @IBOutlet var okCool: UIButton!
    var introThreeCount = 0
    @IBOutlet var theSwitch: UISwitch!
    @IBAction func isPublic(_ sender: AnyObject) {
        
        if theSwitch.isOn {
            publicWin = true
        } else { publicWin = false}
        
        print(publicWin)
        
        
    }
    @IBOutlet var addSquad: UIButton!
    @IBAction func startOver(_ sender: AnyObject) {
        feelingPlaceholder = ""
        currentWinEmoji = ""
        currentWinFeeling = ""
        currentWinDetails = ""
        currentFriendsList = emptyStringArray
        currentFriendsPhoneList = emptyDoubleStringArray
        currentFriendsEmails = emptyDoubleStringArray
        phoneNums = emptyStringArray
        imageToUpload = emptyImageView
        
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
            UIView.setAnimationTransition(UIViewAnimationTransition.curlDown, for: self.navigationController!.view, cache: false)
        })
        self.navigationController?.popToRootViewController(animated: false)
        
    }
    @IBAction func addSquadTap(_ sender: AnyObject) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(FinalPostViewController.getSquad), userInfo: nil, repeats: false)
        
    }
    
    func getSquad () {
        
        let contactPickerViewController = CNContactPickerViewController()
        
        contactPickerViewController.predicateForEnablingContact = NSPredicate(format: "phoneNumber != nil")
        
        contactPickerViewController.delegate = self
        
        present(contactPickerViewController, animated: true, completion: nil)
        activityIndicator.stopAnimating()
        
    }
    func checkContactText () {
        if phoneNums.count != 0 {
            numbersLeft = phoneNums
            var numbersFromParse = [[String]]()
            var count = 0
            //gets users added who have the app
            let phoneQuery = PFUser.query()
            phoneQuery!.whereKey("phoneNumber", containedIn: phoneNums)
            phoneQuery!.findObjectsInBackground() { (objects, error) -> Void in
                if let objects = objects {
                    for object in objects {
                        if object["phoneNumber"] != nil {
                            numbersFromParse.append(object["phoneNumber"] as! [String])
                            print("appending \(object["phoneNumber"])")
                            
                            for i in 0 ..< phoneNums.count {
                            
                                print("wondering if these two match \(numbersFromParse[count]) and \(phoneNums[i])")
                                if numbersFromParse[count].contains(phoneNums[i]) {
                                    if let index = self.numbersLeft.index(of: phoneNums[i]) {
                                        print("about to remove \(phoneNums[i])")
                                        self.numbersLeft.remove(at: index)
                                    }
                                }
                            }
                            count += 1
                        }
                    }
                    print("this is what we have left \(self.numbersLeft)")
                    print("original list of numbers \(phoneNums)")
                    
                    if self.numbersLeft.count == 0 {
                        self.saveTheStuff()
                    } else {
                    //alert sending to texts
                        self.textAlert()
                    }
                }
            }
        } else { self.saveTheStuff()}
    }
    @IBAction func doneButton(_ sender: AnyObject) {
        
        //activity Indicator
        checkContactText()
        
        
    }
    
    func textAlert () {
        
        let title = "Squad Goals!"
        
        let alertController = UIAlertController(title: title, message: "Some of these folks aren't on the app so we gotta send a text", preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "Ok, Cool", style: .default, handler: { (alert: UIAlertAction!) in
            self.sendTexts()
            
        })
       
        
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
        

    }
    func sendTexts () {
       
        let messageVC = MFMessageComposeViewController ()
        messageVC.body = "Hey, I added you to my Win, check it out.  #StayUndefeated  bit.ly/getwins"
        messageVC.recipients = numbersLeft
        messageVC.messageComposeDelegate = self
        self.present(messageVC, animated: true, completion: nil)

    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            print ("Message canceled")
            self.dismiss(animated: true, completion: nil)
            self.saveTheStuff()
            
        case MessageComposeResult.failed.rawValue:
            print ("Message failed")
            self.dismiss(animated: true, completion: nil)
            self.saveTheStuff()
            
        case MessageComposeResult.sent.rawValue:
            print ("Message sent")
            self.dismiss(animated: true, completion: nil)
            self.saveTheStuff()
            
        default:
            break
        }
    }

    func saveTheStuff () {
        
        playSound("notifSound1",fileType: ".mp3")
        feelingPlaceholder = ""
        showTheBar = true
        addedWin = true
        
        let addWin = PFObject(className:"Wins")
        addWin["winAuthor"] = currentUser
        addWin["feeling"] = currentWinFeeling
        addWin["emoji"] = currentWinEmoji
        addWin["squad"] = currentFriendsList
        addWin["details"] = currentWinDetails
        addWin["publicWin"] = publicWin
        addWin["phoneNumbers"] = phoneNums
        addWin["authorId"] = currentUserId
        
        //pick image
        if imageToUpload != nil {
            //addWin["image"] =
            let imageData = UIImageJPEGRepresentation(imageToUpload.image!, 0.5)
            let imageFile = PFFile(name:"image.png", data: imageData!)
            addWin["image"] = imageFile
            
            imageToUpload = emptyImageView
            let imageSize: Int = imageData!.count
            print("size of image in KB: \(imageSize)  1024.0")
            print("there was an image and we added it")
        }
        
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
            UIView.setAnimationTransition(UIViewAnimationTransition.curlUp, for: self.navigationController!.view, cache: false)
        })
        self.navigationController?.popToRootViewController(animated: false)
        
        addWin.saveInBackground {
            (success: Bool, error: NSError?) -> Void in
            
            if (success) {
                print("saved this time around")
                currentWinEmoji = ""
                currentWinFeeling = ""
                currentWinDetails = ""
                currentFriendsList = emptyStringArray
                currentFriendsPhoneList = emptyDoubleStringArray
                currentFriendsEmails = emptyDoubleStringArray
                phoneNums = emptyStringArray
                
            }
            else {
                // There was a problem, check error.description
                print("failed this time \(error)")
            }
            
            
            
            //currentWinImage
            viewsFromOtherControllers += 1
//            
//            UIApplication.sharedApplication().cancelAllLocalNotifications()
//            let gregorian:NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
//            gregorian.timeZone = NSTimeZone.localTimeZone() //(abbreviation: "GMT")!//NSTimeZone.localTimeZone()
//            
//            let recentOffset = NSDateComponents()
//            recentOffset.hour = 5
//            
//            //offset the time the notifs begin by 5 hours from now
//            let rightNow = NSDate()
//            let today:NSDate = gregorian.dateByAddingComponents(recentOffset, toDate: rightNow, options: NSCalendarOptions(rawValue: 0))!
//            lastNotifDate = today
//            NSUserDefaults.standardUserDefaults().setObject(lastNotifDate, forKey: "lastNotifDate")
//            self.appDelegate.refillLocalNotifs()
            var number = 0
            let app:UIApplication = UIApplication.shared
            let amountGoingOut = app.scheduledLocalNotifications?.count
            print("this is how many are going out \(amountGoingOut)")
            for oneEvent in app.scheduledLocalNotifications! {
                let notification = oneEvent as UILocalNotification
                print("this is the fire date of current notif \(notification.fireDate)")
                if amountGoingOut != nil && number >= amountGoingOut! / 4 {
                   app.cancelLocalNotification(notification)
                } else {
                    print("this was previous last notif \(lastNotifDate)")
                    lastNotifDate = notification.fireDate
                    print("this is the new notif date \(lastNotifDate)")
                    
                }
                number += 1
            }
            self.appDelegate.refillLocalNotifs()
            for twoEvent in app.scheduledLocalNotifications! {
                let notification = twoEvent as UILocalNotification
                print(notification.fireDate)
            }
            
            
            
            
        }
        let userQuery = PFUser.query()
        userQuery!.getObjectInBackground(withId: currentUserId!) {
            (user: PFObject?, error: NSError?) -> Void in
            if error == nil && user != nil {
                user?.incrementKey("winCount", byAmount: 1)
            } else {
                if error != nil {print(error)}
            }
            user?.saveInBackground()
        }
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        blueLine.isHidden = true
        introTwo.isHidden = true
        introOne.isHidden = true
        tutImage.isHidden = true
        introThree.isHidden = true
        fadedBackground.isHidden = true
        okCool.isHidden = true
        okCool.layer.cornerRadius = 4.0
        okCool.layer.borderColor = UIColor(red: 25/255.0, green: 169/255.0, blue: 255/255.0, alpha: 1.0).cgColor
        okCool.layer.borderWidth = 2.0

        // Do any additional setup after loading the view.
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(FinalPostViewController.respond(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)

        
        if tutCountFinal == 1 {
        let state = false
        
        //some check to make sure user defaults needs to show tut
        Timer.scheduledTimer(timeInterval: TimeInterval(1.0), target: self, selector: #selector(FinalPostViewController.introTut(_:)), userInfo: state, repeats: false)
        }
    }

    func introTut (_ state: Timer) {
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFromTop
        self.navigationController!.view.layer.add(transition, forKey: nil)
        
        
        blueLine.isHidden = state.userInfo as! Bool
        introTwo.isHidden = state.userInfo as! Bool
        introOne.isHidden = state.userInfo as! Bool
        tutImage.isHidden = state.userInfo as! Bool
        fadedBackground.isHidden = state.userInfo as! Bool
        okCool.isHidden = state.userInfo as! Bool
        
        if introThreeCount == 1 {
            introThree.isHidden = false
            okCool.isHidden = false
            fadedBackground.isHidden = false
            
        }
        if introThreeCount > 1 {
            introThree.isHidden = true
            okCool.isHidden = true
            fadedBackground.isHidden = true
            tutCountFinal = 0
            UserDefaults.standard.set(tutCountFinal, forKey: "tutCountFinal")
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //let friend = String()
        controllerToStayOn = true
        
        for friend in currentFriendsList {
            squadLabel.text! = "\(squadLabel.text!) \(friend)!"
            squadLabel.font.withSize(15.0)
        }
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func playSound(_ fileName:String, fileType:String){
        let correctSound = Bundle.main.path(forResource: fileName, ofType: fileType)
        
        do {
            player2 = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: correctSound!))
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch {
            print("Something bad happened. Try catching specific errors to narrow things down")
        }
        
        player2.play()
    }
    
    func didFetchContacts(_ contacts: [CNContact]) {
        
        
        squadLabel.text! = "Squad:"
        for contact in contacts {
            self.contacts.append(contact)
            //print("name \(contact.givenName)")
            currentFriendsList.append(contact.givenName)
            //squadLabel.text! = "\(squadLabel.text!) \(contact.givenName)!"
            //squadLabel.font.fontWithSize(15.0)
            
            var emailArray = [String]()
            for email in contact.emailAddresses {
                let emailAddress = email.value as? String
                emailArray.append(emailAddress!)
            }
            //print(emailArray)
            currentFriendsEmails.append(emailArray)
            
            var numberArray = [String]()
            for number in contact.phoneNumbers {
                let phoneNumber = number.value 
                numberArray.append(phoneNumber.stringValue)
            }
            //print("\(numberArray)")
            currentFriendsPhoneList.append(numberArray)
            for i in 0 ..< numberArray.count {
            let phone = numberArray[i] as String
            let stringArray = phone.components(
                separatedBy: CharacterSet.decimalDigits.inverted)
            let newString = stringArray.joined(separator: "")
            //print ("this is new string \(newString)")
                phoneNums.append(newString)
            }
        }
        
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        didFetchContacts(contacts)
        navigationController?.dismiss(animated: true, completion: nil)
    }

    func respond(_ gesture: UIGestureRecognizer)  {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.right:
                self.navigationController?.popViewController(animated: true)
                
            default:
                break
            }
        }
        
        
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

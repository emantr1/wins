//
//  PushSettingsViewController.swift
//  classified
//
//Created by Eman Igbinosa 4/1/2016.
//


import UIKit
import Parse

@available(iOS 9.0, *)
class PushSettingsViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var counterLabel = 1
    var perDay = notifsSentPerDay
    @IBOutlet var frequency: UISegmentedControl!
    @IBOutlet var repeatLabel: UILabel!
    @IBOutlet var counter: UISegmentedControl!
    var commWinsOnOff = "Community On"
    var notif = "notifs on"
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    @IBAction func repeatCount(_ sender: AnyObject) {
        
        if counter.selectedSegmentIndex == 0 {
            if counterLabel != 1 {
            counterLabel -= 1
            }
        } else {
            if counterLabel != 5 {
                counterLabel += 1
            }
        }
        
        colorIt(counterLabel)
        print("we're at this number for counters \(counterLabel)")
    }
    
    func colorIt(_ counter: Int) {
        
        if counter == 1 {
            //0, 213, 105
            repeatLabel.text = "only one"
            repeatLabel.textColor = UIColor(red: 0/255.0, green: 213/255.0, blue: 105/255.0, alpha: 1.0)
            perDay = 1
        } else if counter == 2 {
            //255, 202, 57
            repeatLabel.text = "a few please"
            repeatLabel.textColor = UIColor(red: 255/255.0, green: 202/255.0, blue: 57/255.0, alpha: 1.0)
            perDay = 3
        } else if counter == 3 {
            //254, 140, 0
            repeatLabel.text = "a little more"
            repeatLabel.textColor = UIColor(red: 254/255.0, green: 140/255.0, blue: 0/255.0, alpha: 1.0)
            perDay = 5
        } else if counter == 4 {
            //255, 61, 0
            repeatLabel.text = "even more!"
            repeatLabel.textColor = UIColor(red: 255/255.0, green: 61/255.0, blue: 0/255.0, alpha: 1.0)
            perDay = 7
        } else if counter == 5 {
            //171, 0, 60
            repeatLabel.text = "crank it up!!"
            repeatLabel.textColor = UIColor(red: 171/255.0, green: 0/255.0, blue: 60/255.0, alpha: 1.0)
            perDay = 10
        } else {
            repeatLabel.text = "\(counter)x"
            perDay = counter
        }

        
    }
    @IBOutlet var remindersSwitch: UISwitch!
    @IBAction func remindersOn(_ sender: AnyObject) {
        
        
        
        if remindersSwitch.isOn {
            receiveReminders = 0
            notif = "notifs on"
            displayAlert("Make Sure", message: "Your notifications are turned on in your phone settings ;)")
            
        } else {
            receiveReminders = 1
            notif = "notifs off"
        }
        
        print("receive reminders is \(receiveReminders)")
        let userQuery = PFUser.query()
        userQuery!.getObjectInBackground(withId: currentUserId!) {
            (user: PFObject?, error: NSError?) -> Void in
            if error == nil && user != nil {
                user!["notifsState"] = "\(self.notif) \(self.repeatLabel.text) reminders=\(receiveReminders)"
            } else {
                if error != nil {print(error)}
            }
            user?.saveInBackground()
        }
       
        UserDefaults.standard.set(receiveReminders, forKey: "receiveReminders")
        UIApplication.shared.cancelAllLocalNotifications()
        var gregorian:Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        gregorian.timeZone = TimeZone.autoupdatingCurrent //(abbreviation: "GMT")!//NSTimeZone.localTimeZone()
        
        var recentOffset = DateComponents()
        recentOffset.hour = 5
        
        //offset the time the notifs begin 1 day from now
        let rightNow = Date()
        let today:Date = (gregorian as NSCalendar).date(byAdding: recentOffset, to: rightNow, options: NSCalendar.Options(rawValue: 0))!
        lastNotifDate = today
        UserDefaults.standard.set(lastNotifDate, forKey: "lastNotifDate")
        self.appDelegate.refillLocalNotifs()
    }
    
    
    @IBOutlet var theSwitch: UISwitch!
    @IBAction func commWinsOn(_ sender: AnyObject) {
        
        if myCommTypesArray != nil && myCommTypesArray! != [""] {
            myCommTypesArrayPlaceholder = myCommTypesArray
            UserDefaults.standard.set(myCommTypesArrayPlaceholder, forKey: "myCommTypesArrayPlaceholder")
        }
        
        if theSwitch.isOn {
            commWinsOnOff = "Community On"
            onlyPersonal = 0
            if myCommTypesArrayPlaceholder != nil && myCommTypesArrayPlaceholder! != [""] {
                myCommTypesArray = myCommTypesArrayPlaceholder
            } else {
                myCommTypesArray = ["entrepreneur"]
            }
        } else {
            myCommTypesArray = [""]
            onlyPersonal = 1
            commWinsOnOff = "Community Off"
        }
        
        UserDefaults.standard.set(onlyPersonal, forKey: "onlyPersonal")
        print("this is what we're showing you \(myCommTypesArray)")
        UIApplication.shared.cancelAllLocalNotifications()
        var gregorian:Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        gregorian.timeZone = TimeZone.autoupdatingCurrent //(abbreviation: "GMT")!//NSTimeZone.localTimeZone()
        
        var recentOffset = DateComponents()
        recentOffset.hour = 5
        
        //offset the time the notifs begin 1 day from now
        let rightNow = Date()
        let today:Date = (gregorian as NSCalendar).date(byAdding: recentOffset, to: rightNow, options: NSCalendar.Options(rawValue: 0))!
        lastNotifDate = today
        UserDefaults.standard.set(lastNotifDate, forKey: "lastNotifDate")
        self.appDelegate.refillLocalNotifs()
        
    }
    
    @IBOutlet var startReminders: UIDatePicker!
    @IBOutlet var endReminders: UIDatePicker!
    @IBOutlet var tblItems : UITableView!
    var items : NSArray! = NSArray()
    
    @IBAction func saveButton(_ sender: AnyObject) {
        
        self.view.isUserInteractionEnabled = false
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        notifsSentPerDay = perDay
        
        var gregorian:Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        gregorian.timeZone = TimeZone.autoupdatingCurrent //(abbreviation: "GMT")!//NSTimeZone.localTimeZone()
        
        var recentOffset = DateComponents()
        recentOffset.hour = 5
        
        //offset the time the notifs begin 1 day from now
        let rightNow = Date()
        let today:Date = (gregorian as NSCalendar).date(byAdding: recentOffset, to: rightNow, options: NSCalendar.Options(rawValue: 0))!
        lastNotifDate = today
        UserDefaults.standard.set(lastNotifDate, forKey: "lastNotifDate")
        UserDefaults.standard.set(notifsSentPerDay, forKey: "notifsSentPerDay")
        Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(PushSettingsViewController.updateNotifsSendTime), userInfo: nil, repeats: false)
        //updateNotifsSendTime()
        print("planning on sending out \(notifsSentPerDay) per day")
        
        
        let userQuery = PFUser.query()
        userQuery!.getObjectInBackground(withId: currentUserId!) {
            (user: PFObject?, error: NSError?) -> Void in
            if error == nil && user != nil {
                user!["notifsState"] = "\(self.notif) \(self.repeatLabel.text!) \(self.commWinsOnOff) reminders=\(receiveReminders)"
            } else {
                if error != nil {print(error)}
            }
            user?.saveInBackground()
        }
        
    }
    
    var startHour = 9
    var endHour = 22
    var startMin = 00
    var endMin = 00
    let dateFormatter = DateFormatter()
    
    override func viewDidAppear(_ animated: Bool) {
        controllerToStayOn = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pull saved counter number from user defaults - also the time they last chose
        let today = Date()
        if onlyPersonal == 0 {
            theSwitch.isOn = true
        } else { theSwitch.isOn = false}
        
        if receiveReminders == 0 {
            remindersSwitch.isOn = true
        } else { remindersSwitch.isOn = false}
        
        if notifsSentPerDay == 10 { counterLabel = 5}
        else if notifsSentPerDay == 7 { counterLabel = 4}
        else if notifsSentPerDay == 5 { counterLabel = 3}
        else if notifsSentPerDay == 3 { counterLabel = 2}
        else { counterLabel = notifsSentPerDay}
        colorIt(counterLabel)
        //repeatLabel.text = "\(notifsSentPerDay)x"
        
        if reminderStart == 0 {reminderStart = startHour}
        if reminderEnd == 0 {reminderEnd = endHour}
        
        print("this is reminder start \(reminderStart) and this is reminder end \(reminderEnd)")
        
        let startPicker:Date = (Calendar.current as NSCalendar).date(bySettingHour: reminderStart, minute: startMinSaved, second: 30, of: today, options: NSCalendar.Options(rawValue: 0))!
        
        let endPicker:Date = (Calendar.current as NSCalendar).date(bySettingHour: reminderEnd, minute: endMinSaved, second: 30, of: today, options: NSCalendar.Options(rawValue: 0))!
        
        
        startReminders.setDate(startPicker, animated: true)
        endReminders.setDate(endPicker, animated: true)
        
        
        
        // Do any additional setup after loading the view.
        /*let background = CAGradientLayer().greenLayer()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)*/
        
        startReminders.addTarget(self, action: #selector(PushSettingsViewController.startReminderChanged(_:)), for: UIControlEvents.valueChanged)
         endReminders.addTarget(self, action: #selector(PushSettingsViewController.endReminderChanged(_:)), for: UIControlEvents.valueChanged)
    }
    
    func startReminderChanged(_ datePicker:UIDatePicker) {
        
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        let strDate = dateFormatter.string(from: startReminders.date)
        
        
        //let dateFormatter = NSDateFormatter()
        //dateFormatter.dateFormat = "Your date Format"
        let date = dateFormatter.date(from: strDate)
        let calendar = Calendar.current
        let comp = (calendar as NSCalendar).components([.hour, .minute], from: date!)
        startHour = comp.hour!
        startMin = comp.minute!
        //print("start hour \(startHour)")
        
    }
    
    func endReminderChanged(_ datePicker:UIDatePicker) {
        
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        let strDate = dateFormatter.string(from: endReminders.date)
        
        
        //let dateFormatter = NSDateFormatter()
        //dateFormatter.dateFormat = "Your date Format"
        let date = dateFormatter.date(from: strDate)
        let calendar = Calendar.current
        let comp = (calendar as NSCalendar).components([.hour, .minute], from: date!)
        endHour = comp.hour!
        endMin = comp.minute!
        //print("end hour \(endHour)")
        
    }
    
    func updateNotifsSendTime () {
        
        
        UIApplication.shared.cancelAllLocalNotifications()
//        print("this is the start hour \(startHour)")
//        print("this is the end hour \(endHour)")
//        print("these are how many we're sending out \(notifsSentPerDay)")
        reminderStart = startHour
        
        if startHour < endHour {
            reminderDiff = endHour - startHour
        }
        else if startHour > endHour {
            reminderDiff = 24 - abs(startHour - endHour)
        } else {
            endHour = startHour + 1
            reminderDiff = endHour - startHour
        }
        reminderEnd = endHour
        startMinSaved = startMin
        endMinSaved = endMin
        //print("this is the difference \(reminderDiff)")
       
        UserDefaults.standard.set(reminderEnd, forKey: "reminderEnd")
        UserDefaults.standard.set(reminderDiff, forKey: "reminderDiff")
        UserDefaults.standard.set(reminderStart, forKey: "reminderStart")
        UserDefaults.standard.set(startMinSaved, forKey: "startMinSaved")
        UserDefaults.standard.set(endMinSaved, forKey: "endMinSaved")
        appDelegate.applicationDidBecomeActive(UIApplication.shared)
        activityIndicator.stopAnimating()
        displayAlert("Got It", message:"Reminder Settings have been updated and will start tomorrow")
        self.view.isUserInteractionEnabled = true
        print("screen enabled again")
        //self.navigationController?.popViewControllerAnimated(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK, Cool", style: .default, handler: { (action) -> Void in
            //self.dismissViewControllerAnimated(true, completion: nil)
            
            if title == "Got It" {
            self.navigationController?.popViewController(animated: true)
            }
            
        }))
        self.present(alert, animated: true, completion: nil)
    }

    
       
}

//
//  CommunityNotifsViewController.swift
//  Wins
//
//  Created by Eman I on 4/30/16.
//  Copyright © 2016 Eman. All rights reserved.
//
import UIKit
import Parse
import ParseUI

class CommunityNotifsViewController: UIViewController {
    
    
    @IBOutlet var saveArrow: UIImageView!
    var originalArrowY: CGFloat = 1.0
    var seenArrow = false
    @IBOutlet var tutImage: UIImageView!
    @IBOutlet var line2: UILabel!
    @IBOutlet var doneMessage: UILabel!
    var doneMessageCount = 0
    @IBOutlet var fadedBack: UILabel!
    @IBOutlet var blueLine: UILabel!
    @IBOutlet var okButton: UIButton!
    @IBOutlet var firstMessage: UILabel!
    @IBOutlet var secondMessage: UILabel!
    
    var refresher: UIRefreshControl!
    var centerHolder = CGPoint()
    @IBAction func okTap(_ sender: AnyObject) {
        
        Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(CommunityNotifsViewController.introTut(_:)), userInfo: true, repeats: false)
        
        doneMessageCount += 1
    }
    @IBOutlet var tblContents : UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var arrAds : NSMutableArray! = NSMutableArray()
    //var cellblur = [Int]()
    
    
    
    @IBAction func saveButton(_ sender: AnyObject) {
        self.activityIndicator.startAnimating()
        //do the parse stuff here
        saveArrow.isHidden = true
        seenArrow = true
        let userQuery = PFUser.query()
        userQuery!.getObjectInBackground(withId: currentUserId!) {
            (user: PFObject?, error: NSError?) -> Void in
            if error == nil && user != nil {
                user!["community"] = myCommTypesArray
            } else {
                if error != nil {print(error)}
            }
            user?.saveInBackground()
        }
        //save to NSUserDefaults.standardUserDefaults().arrayForKey("myCommTypesArray") as? [String] user defaluts and save to parse user commtyps column
        UserDefaults.standard.set(myCommTypesArray, forKey: "myCommTypesArray")

        
        
        notifsToBeSent = [String:[String]]()
        print("this is what we should be filling \(myCommTypesArray)")
        
        UIApplication.shared.cancelAllLocalNotifications()
        var gregorian:Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        gregorian.timeZone = TimeZone.autoupdatingCurrent //(abbreviation: "GMT")!     //NSTimeZone.localTimeZone()
        
        var recentOffset = DateComponents()
        recentOffset.hour = 5
        
        //offset the time the notifs begin 5 hours from now
        let rightNow = Date()
        let today:Date = (gregorian as NSCalendar).date(byAdding: recentOffset, to: rightNow, options: NSCalendar.Options(rawValue: 0))!
        lastNotifDate = today
        UserDefaults.standard.set(lastNotifDate, forKey: "lastNotifDate")
        self.appDelegate.refillLocalNotifs()
        
        self.activityIndicator.stopAnimating()
        displayAlert("Cool Beans", message:"Your choices are updated.  Now just chill and let the good stuff roll in.  You can adjust the frequency in settings")
        //self.navigationController?.popViewControllerAnimated(true)
    }
    
    func displayAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK, Cool", style: .default, handler: { (action) -> Void in
            //self.dismissViewControllerAnimated(true, completion: nil)
            
            self.appDelegate.switchRootControllers()
            
        }))
        self.present(alert, animated: true, completion: nil)
    }


    func refresh() {
        
        
        let getCommQuery = PFQuery(className: "CommTypes")
        getCommQuery.order(byDescending: "score") // order by best score later
        getCommQuery.limit = 1000
        getCommQuery.whereKey("public", equalTo: true)
        //getWinsQuery.cachePolicy = PFCachePolicy.CacheElseNetwork
        getCommQuery.findObjectsInBackground() { (objects, error) -> Void in
            if let objects = objects {
                commTypeArray = emptyPFArray
                for object in objects {
                    commTypeArray.append(object)
                    
                }
            }
            self.tblContents.reloadData()
            self.refresher.endRefreshing()
            //self.createProducts()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commTypeArray = emptyPFArray
        //let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        originalArrowY = saveArrow.center.y
        saveArrow.isHidden = true
        line2.isHidden = true
        doneMessage.isHidden = true
        blueLine.isHidden = true
        firstMessage.isHidden = true
        tutImage.isHidden = true
        secondMessage.isHidden = true
        fadedBack.isHidden = true
        okButton.isHidden = true
        okButton.layer.cornerRadius = 3.0
        okButton.clipsToBounds = true
        okButton.layer.borderColor = UIColor(red: 25/255.0, green: 169/255.0, blue: 255/255.0, alpha: 1.0).cgColor
        okButton.layer.borderWidth = 2.0
        centerHolder = okButton.center
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.center = (self.view.center)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        
        
        
        // Do any additional setup after loading the view.
        let background = CAGradientLayer().blueLayer()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)
        
        let getCommQuery = PFQuery(className: "CommTypes")
        getCommQuery.order(byDescending: "score")
        getCommQuery.limit = 1000
        getCommQuery.whereKey("public", equalTo: true)
        //getWinsQuery.cachePolicy = PFCachePolicy.CacheElseNetwork
        getCommQuery.findObjectsInBackground() { (objects, error) -> Void in
            if let objects = objects {
                for object in objects {
                    commTypeArray.append(object)
                    
                }
            }
            self.tblContents.reloadData()
            self.activityIndicator.stopAnimating()
            //self.createProducts()
        }
        
        refresher = UIRefreshControl()
        refresher.tintColor = UIColor.white
        refresher.addTarget(self, action: #selector(CommunityNotifsViewController.refresh), for: UIControlEvents.valueChanged)
        self.tblContents.addSubview(refresher)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        controllerToStayOn = false
        
        doneMessageCount = 0
        viewsFromOtherControllers += 1
        
        if tutCountCommunity == 0 {
            //let state = false
            
            //some check to make sure user defaults needs to show tut
            Timer.scheduledTimer(timeInterval: TimeInterval(1.0), target: self, selector: #selector(CommunityNotifsViewController.introTut(_:)), userInfo: false, repeats: false)
        }

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func introTut (_ state: Timer) {
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFromTop
        self.navigationController!.view.layer.add(transition, forKey: nil)
        

        
        blueLine.isHidden = state.userInfo as! Bool
        firstMessage.isHidden = state.userInfo as! Bool
        tutImage.isHidden = state.userInfo as! Bool
        secondMessage.isHidden = state.userInfo as! Bool
        fadedBack.isHidden = state.userInfo as! Bool
        okButton.isHidden = state.userInfo as! Bool
        
        if doneMessageCount == 1 {
            line2.isHidden = false
            doneMessage.isHidden = false
            okButton.isHidden = false
            fadedBack.isHidden = false
            okButton.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 50)
            
        }
        if doneMessageCount > 1 {
            line2.isHidden = true
            doneMessage.isHidden = true
            okButton.isHidden = true
            okButton.center = centerHolder
            fadedBack.isHidden = true
            tutCountCommunity = 1
            UserDefaults.standard.set(tutCountCommunity, forKey: "tutCountCommunity")
            
        }
        
        
    }
    
    internal func tableView(_ tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 170.0
    }
    
    func tableView(_ tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return commTypeArray.count
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView!) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView!, cellForRowAtIndexPath indexPath: IndexPath!) -> UITableViewCell! {
        return basicCellAtIndexPath(indexPath)
    }
    
    func basicCellAtIndexPath(_ indexPath:IndexPath) -> UITableViewCell {
    
        var cell : ClassifiedListTableViewCell!
        cell = tblContents.dequeueReusableCell(withIdentifier: "CellClassified") as! ClassifiedListTableViewCell
        setImageForCell(cell, indexPath: indexPath)
        setTitlesForCell(cell, indexPath: indexPath)
        return cell
    }
    
    func setImageForCell(_ cell: ClassifiedListTableViewCell, indexPath: IndexPath) {
        
        //set indexrow
        let typeIndex = (indexPath as NSIndexPath).row
        //Figure out row details
        let typeDetails = commTypeArray[typeIndex]
        
        if typeDetails["image"] != nil {
            if let commImage = typeDetails["image"] as? PFFile {
                cell.testPF.file = commImage
                cell.testPF.load(inBackground: {
                    (image, error) in
                    // do stuff here
                    DispatchQueue.main.async(execute: {
                        cell.typeReminder.setImage(image, for: UIControlState())
                        cell.typeReminder.imageView?.contentMode = UIViewContentMode.scaleAspectFill
                    })
                    
                })
//                commImage.getDataInBackgroundWithBlock { (data, error) -> Void in
//                    if error == nil {
//                        if let downloadedImage = UIImage(data: data!) {
//                            dispatch_async(dispatch_get_main_queue(), {
//                            cell.typeReminder.setImage(downloadedImage, forState: .Normal)
//                            cell.typeReminder.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
//                                 })
//                            
//                        }
//                    } else {
//                        //make private function
//                        let replace = UIImage(named: "Relaxed.jpeg")
//                        cell.typeReminder.setImage(replace, forState: .Normal)
//                        cell.typeReminder.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
//                        
//                    }
//                }
            }
            
            
        }
        
        let pfImageView = PFImageView()
        let userImage = PFUser.current()?.object(forKey: "userPhoto") as? PFFile
        pfImageView.file = userImage
        pfImageView.load(inBackground: {
            (image, error) in
            // do stuff here
        })

        
    }
    func setTitlesForCell(_ cell: ClassifiedListTableViewCell, indexPath: IndexPath) {
       
        //set indexrow
        let typeIndex = (indexPath as NSIndexPath).row
        //Figure out row details
        let typeDetails = commTypeArray[typeIndex]
        
        cell.details.text = typeDetails["fullName"] as? String
        cell.commID = typeDetails["nameId"] as! String
        cell.typeReminder.tag = typeIndex
        
        if let target = cell.typeReminder.target(forAction: #selector(CommunityNotifsViewController.selectionMade(_:)), withSender: self) {
            cell.typeReminder.removeTarget(target, action: #selector(CommunityNotifsViewController.selectionMade(_:)), for: UIControlEvents.touchUpInside)
        }
        
        cell.typeReminder.addTarget(self, action: #selector(CommunityNotifsViewController.selectionMade(_:)), for: UIControlEvents.touchUpInside)
        
        cell.info.tag = typeIndex
        cell.info.addTarget(self, action: #selector(CommunityNotifsViewController.infoTap(_:)), for: UIControlEvents.touchUpInside)
        
        if myCommTypesArray != nil {
            let key = typeDetails["nameId"] as! String
            if myCommTypesArray!.contains(key) {
                cell.typeReminder.alpha = 1.0
                cell.checkMark.isHidden = false
                cell.checkMark.layer.cornerRadius = cell.checkMark.frame.size.width / 2
                cell.checkMark.clipsToBounds = true
                cell.details.alpha = 1.0
            } else {
                cell.typeReminder.alpha = 0.5
                cell.checkMark.isHidden = true
                cell.details.alpha = 0.3
            }
        } else {
            cell.typeReminder.alpha = 0.5
            cell.checkMark.isHidden = true
            cell.details.alpha = 0.3
        }

        
    }

    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
       
        //let typeIndex = indexPath.row
        print("the real row number is \((indexPath as NSIndexPath).row)")
       
        
       
    }
    
    func infoTap(_ sender:UIButton) {
    
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let typeDetails = commTypeArray[(indexPath as NSIndexPath).row]
        //let buttonRow = sender.tag
        let name = typeDetails["fullName"]
        categoryName = name as! String
        categoryId = typeDetails["nameId"] as! String
        categoryObjectId = typeDetails.objectId!
        
        print("the category name \(name) the id \(categoryId)")
        if typeDetails["totalLikes"] != nil { categoryLikes = typeDetails["totalLikes"] as! Int} else { categoryLikes = 0}
        if typeDetails["totalDislikes"] != nil { categoryDislikes = typeDetails["totalDislikes"] as! Int}else { categoryDislikes = 0}

        if typeDetails["creator"] != nil { categoryCreator = typeDetails["creator"] as! String}else { categoryCreator = "anonymous"}

        if typeDetails["description"] != nil { categoryDescription = typeDetails["description"] as! String}else { categoryDescription = "description goes here"}

        if typeDetails["subscriber"] != nil { categorySubs = typeDetails["subscribers"] as! Int}else { categorySubs = 0}
        if typeDetails["winCount"] != nil { categoryWinCount = typeDetails["winCount"] as! Int}else { categoryWinCount = 0}
        
        if typeDetails["image"] != nil {
            let catImage = typeDetails["image"] as? PFFile
            catImage!.getDataInBackground { (data, error) -> Void in
                if error == nil {
                    if let downloadedImage = UIImage(data: data!) {
                        communityCatImage.image = downloadedImage
                        }
                    }
                }
        }
        
        

        
    
    }
    
    func selectionMade(_ sender:UIButton)  -> UITableViewCell {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        var cell : ClassifiedListTableViewCell!
        cell = tblContents.dequeueReusableCell(withIdentifier: "CellClassified") as! ClassifiedListTableViewCell
        let typeDetails = commTypeArray[(indexPath as NSIndexPath).row]
        let buttonRow = sender.tag
        print("this is the row we're on \(buttonRow)")
        print ("it should say this \(typeDetails["nameId"] as! String)")
        let key = typeDetails["nameId"] as! String
        
        if myCommTypesArray != nil {
            if myCommTypesArray!.contains(key) {
                cell.checkMark.isHidden = true
                cell.typeReminder.alpha = 0.5
                cell.details.alpha = 0.3
                
                

                //remove from array
                if let index = myCommTypesArray!.index(of: key) {
                    print("about to remove \(key)")
                    myCommTypesArray!.remove(at: index)
                }
                
            } else {
                cell.typeReminder.alpha = 1.0
                cell.checkMark.isHidden = false
                cell.checkMark.layer.cornerRadius = cell.checkMark.frame.size.width / 2
                cell.checkMark.clipsToBounds = true
                cell.details.alpha = 1.0
                myCommTypesArray!.append(key)
                print("this array should not be empty now \(myCommTypesArray)")
            }
        } else {
            cell.typeReminder.alpha = 1.0
            cell.checkMark.isHidden = false
            cell.checkMark.layer.cornerRadius = cell.checkMark.frame.size.width / 2
            cell.checkMark.clipsToBounds = true
            cell.details.alpha = 1.0
            myCommTypesArray = [String]()
            myCommTypesArray!.append(key)
            print("this array should not be empty now \(myCommTypesArray)")
        }
        
        if seenArrow == false {
        saveArrow.center.y = self.view.frame.height + 30
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 6, options: [], animations: {
        self.saveArrow.center.y = self.originalArrowY
        }, completion: nil)
        saveArrow.isHidden = false
        seenArrow = true
        }
        self.tblContents.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        return cell
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

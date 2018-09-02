//
//  MyWinsViewController.swift
//  classified
//
//  Created by Eman I on 4/4/16.

//
import UIKit
import Parse

class MyWinsViewController: UIViewController {
    
    var phoneArray = ["test"]
    @IBAction func tapProfile(_ sender: AnyObject) {
        fromLocation = "Mine"
        profSeg = 1
    }
    @IBOutlet var tblContents : UITableView!
    var arrAds : NSMutableArray! = NSMutableArray()
    var quoteList = ["Success is not final, failure is not fatal: it is the courage to continue that counts.",
                     "The starting point of all achievement is desire.",
                     "In order to succeed, we must first believe that we can.",
                     "Either you run the day or the day runs you.",
                     "Life is 10% what happens to you and 90% how you react to it.",
                     "You are never too old to set another goal or to dream a new dream.",
                     "It does not matter how slowly you go as long as you do not stop.",
                     "The secret of getting ahead is getting started.",
                     "Start where you are. Use what you have. Do what you can.",
                     "Don't watch the clock; do what it does. Keep going.",
                     "Problems are not stop signs, they are guidelines.",
                     "Either I will find a way, or I will make one.",
                     "Go for it now. The future is promised to no one.",
                     "Perseverance is failing 19 times and succeeding the 20th.",
                     "Be kind whenever possible. It is always possible.",
                     "Nothing is impossible, the word itself says 'I'm possible'!",
                     "Live life to the fullest, and focus on the positive.",
                     "Always turn a negative situation into a positive situation.",
                     "When someone does something good, applaud! You will make two people happy.",
                     "My dear friend, clear your mind of cant.",
                     "A good laugh is sunshine in the house.",
                     "In every day, there are 1,440 minutes. That means we have 1,440 chances to get a win!",
                     "Electricity is really just organized lightning.",
                     "Food is an important part of a balanced diet.",
                     "Do not take life too seriously. You will never get out of it alive.",
                     "The best way to predict the future is to create it.",
                     "To give anything less than your best, is to sacrifice the gift.",
                     "Nobody who ever gave his best regretted it.",
                     "It is not how much we have, but how much we enjoy, that makes happiness.",
                     "Be happy for this moment. This moment is your life.",
                     "Most folks are as happy as they make up their minds to be."]
    
    @IBOutlet var quote: UILabel!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var refresher: UIRefreshControl!
    var commWins : NSMutableArray! = NSMutableArray()
    var commDict:[String:[String]] = [String:[String]]()
    
    @IBOutlet var phoneQuestionButton: UIButton!
    @IBOutlet var findOutButton: UIButton!
    @IBAction func findOut(_ sender: AnyObject) {
    }
    
    
    func refresh() {
        
        createLocalWins()
        
        
        if mySavedWins == nil {
            print("setting up personal wins defaults")
            mySavedWins = [String:[String]]()
        } else {print("not nil")}
//        
//        let userQuery = PFUser.query()
//        userQuery!.whereKey("objectId", equalTo: currentUserId!)
        
        let ownWins = PFQuery(className: "Wins")
        ownWins.whereKey("authorId", equalTo: currentUserId!)
        
        
        if myPhoneArray != nil {phoneArray = myPhoneArray!}
        let phoneQuery = PFQuery(className: "Wins")
        phoneQuery.whereKey("phoneNumbers", containedIn: phoneArray)
        
        
        //let predicate = NSPredicate(format:"winAuthor == '\(currentUser)'")
        
        let getWinsQuery = PFQuery.orQuery(withSubqueries: [ownWins, phoneQuery])
        //getWinsQuery.whereKey("winAuthor", matchesQuery:userQuery!)
        getWinsQuery.order(byDescending: "createdAt")
        getWinsQuery.limit = 1000
        //getWinsQuery.cachePolicy = PFCachePolicy.CacheElseNetwork
        getWinsQuery.findObjectsInBackground() { (objects, error) -> Void in
            if let objects = objects {
                myWinsObjectArray = emptyPFArray
                for object in objects {
                    myWinsObjectArray.append(object)
                    let key = object.objectId! as String
                   
                    //if !(mySavedWins!.contains(object.objectId!)){
                    if mySavedWins![key] == nil {
                        mySavedWins![key] = [object["emoji"] as! String, object["feeling"] as! String]
                    }
                  //self.tblContents.reloadData()
                }
                self.tblContents.reloadData()
                if self.activityIndicator.isAnimating {self.activityIndicator.stopAnimating()}
                if self.refresher.isRefreshing { self.refresher.endRefreshing()}
            }
            
            //self.createProducts()
            UserDefaults.standard.set(mySavedWins, forKey: "mySavedWins")
            print("these are how many wins you have personally \(mySavedWins!.count)")
        }
        
        
    }
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if number is verified hide the question buttons
        myWinsObjectArray = emptyPFArray
        
        self.createLocalWins()
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        
        //self.createProducts()
        // Do any additional setup after loading the view.
        
        let background = CAGradientLayer().greenLayer()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)
       
        //updated the user defaults array of saved wins
        if mySavedWins == nil {
            print("setting up personal wins defaults")
            mySavedWins = [String:[String]]()
        } else {print("not nil")}
        
        let ownWins = PFQuery(className: "Wins")
        ownWins.whereKey("authorId", equalTo: currentUserId!)
        
        
        if myPhoneArray != nil {phoneArray = myPhoneArray!}
        let phoneQuery = PFQuery(className: "Wins")
        phoneQuery.whereKey("phoneNumbers", containedIn: phoneArray)


        //let predicate = NSPredicate(format:"winAuthor == '\(currentUser)'")
        
        let getWinsQuery = PFQuery.orQuery(withSubqueries: [ownWins, phoneQuery])
        //getWinsQuery.whereKey("winAuthor", matchesQuery:userQuery!)
        getWinsQuery.order(byDescending: "createdAt")
        getWinsQuery.limit = 1000
        //getWinsQuery.cachePolicy = PFCachePolicy.CacheElseNetwork
        getWinsQuery.findObjectsInBackground() { (objects, error) -> Void in
            if let objects = objects {
                for object in objects {
                    myWinsObjectArray.append(object)
                    let key = object.objectId! as String
                    //if !(mySavedWins!.contains(object.objectId!)){
                    if mySavedWins![key] == nil {
                        mySavedWins![key] = [object["emoji"] as! String, object["feeling"] as! String]
                    }
                }
                self.tblContents.reloadData()
                if self.activityIndicator.isAnimating {self.activityIndicator.stopAnimating()}
            }
            
        
            //mySavedWins = [String:[String]]()
            UserDefaults.standard.set(mySavedWins, forKey: "mySavedWins")
            print("these are how many wins you have personally \(mySavedWins!.count)")
            //self.createProducts()
        }
       
        refresher = UIRefreshControl()
        refresher.tintColor = UIColor.white
        refresher.addTarget(self, action: #selector(MyWinsViewController.refresh), for: UIControlEvents.valueChanged)
        self.tblContents.addSubview(refresher)
        if numTimesOnApp <= 3 && numberVerified != 1 {
        displayAlert("Are You On A Crew?", message:"Let's go ahead and find out")
        }
    }
    
    func displayAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            //self.dismissViewControllerAnimated(true, completion: nil)
            
            self.performSegue(withIdentifier: "phoneCheck", sender: self)
            
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func createLocalWins () {
        
        if notifsToBeSent == nil {
            print("its empty")
            notifsToBeSent = [String:[String]]()
        } else {
            print("no longer empyt")
            print("the count of notifstobesent\(notifsToBeSent!.count)")
        
        }
        
        let placeholderType = ["entrepreneur"]
        if myCommTypesArray == nil || (myCommTypesArray?.isEmpty)! {
            myCommTypesArray = placeholderType
        }
        
        
        let getCommWins = PFQuery(className: "Community")
        getCommWins.order(byDescending: "createdAt")
        getCommWins.limit = 1000
        getCommWins.whereKey("category", containedIn: myCommTypesArray!)
        getCommWins.whereKeyDoesNotExist("moreInfo")
        getCommWins.findObjectsInBackground() { (objects, error) -> Void in
            if let objects = objects {
                for object in objects {
                    let key = object.objectId! as String
                    
                    //print("the comm win\(key)")
                    //check to make sure these arent empty
                    
                    
                    if seenNotifs != nil {
                    if !(seenNotifs!.contains(key)) {
                        
                        // add the key to dictionary if it doesn't exist - updates if it does exit
                        notifsToBeSent![key] = [object["emoji"] as! String, object["details"] as! String]
                        self.commDict[key] = [object["emoji"] as! String, object["details"] as! String]
                        }
                    } else {
                        notifsToBeSent![key] = [object["emoji"] as! String, object["details"] as! String]
                    }
                    if noLikeArray != nil {
                        //print("these are how many you dont like \(noLikeArray!.count)")
                        if !(noLikeArray!.contains(key)) {
                            if notifsToBeSent![key] == nil {
                                notifsToBeSent![key] = [object["emoji"] as! String, object["details"] as! String]
                            }
                        }
                    } else {
                        notifsToBeSent![key] = [object["emoji"] as! String, object["details"] as! String]
                    }
                }
            }
            //print("the count of the ones added now\(self.commDict.count)")
            //if seenNotifs != nil {print("these are how many you've seen \(seenNotifs!.count)")}
            //if noLikeArray != nil {print("this is how many you dont like \(noLikeArray!.count)")}
            //print(self.commDict)
            //print("the count of the one in user defaults\(notifsToBeSent!.count)")
            
           
            UserDefaults.standard.set(notifsToBeSent, forKey: "notifsToBeSent")
            
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        controllerToStayOn = true
        if self.activityIndicator.isAnimating {self.activityIndicator.stopAnimating()}
        
        if numberVerified == 1 {
            phoneQuestionButton.isHidden = true
            findOutButton.isHidden = true
        }

        
        let randomNum = Int(arc4random_uniform(UInt32(quoteList.count)))
        quote.text = quoteList[randomNum]
        viewsFromOtherControllers += 1
        
        
         if deletedWin == true || addedWin == true {
            deletedWin = false
            addedWin = false
            
            if recentlyLoaded == false {
                print("recently loaded is true")
                activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
                activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                refresh()
            } else {
                print("recently loaded is false")
                recentlyLoaded = false
            }
            
        }
        recentlyLoaded = false
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func createProducts() {
        arrAds.add(["title":"Pumped!","date":"20th August","author":"San Jose","price":"$15","image":"favorite-pic1"])
        arrAds.add(["title":"Cheery","date":"19th August","author":"San Diego, California","price":"$750","image":"favorite-pic2"])
        arrAds.add(["title":"Sexy","date":"15th August","author":"Vista & Carlsbad, California","price":"$1250","image":"favorite-pic3"])
    }
    
    
    func tableView(_ tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return myWinsObjectArray.count
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView!) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView!, cellForRowAtIndexPath indexPath: IndexPath!) -> UITableViewCell! {
        var cell : ClassifiedListTableViewCell!
        cell = tblContents.dequeueReusableCell(withIdentifier: "CellClassified") as! ClassifiedListTableViewCell
        //let adDic : NSDictionary = arrAds.objectAtIndex(indexPath.row) as! [String : String]
        
        //pick index
        let winIndex = indexPath.row
        
        //Figure out the right one
        let winDetails = myWinsObjectArray[winIndex]
        
        
        cell.adTitleLbl.text = winDetails["feeling"] as? String
        let emojiString = winDetails["emoji"] as? String
        
        
        
        let index = emojiString!.characters.index(emojiString!.startIndex, offsetBy: 0)
        cell.myEmoji.text = "\(emojiString![index])"
        
        
        
        if winDetails["image"] != nil {
            let winImage = winDetails["image"] as! PFFile
            winImage.getDataInBackground { (data, error) -> Void in
                if error == nil {
                    if let downloadedImage = UIImage(data: data!) {
                        cell.adImgView.image = downloadedImage
                    }
                } else {
                    cell.adImgView.image = UIImage(named: "Relaxed.jpeg")
                }
            }
        } else {
            let originalEmoji = emojiString
            let sliced = String(originalEmoji!.characters.dropFirst())
            cell.adImgView.image = UIImage(named:"\(sliced).jpeg")
        }
        cell.adImgView.layer.cornerRadius = cell.adImgView.frame.size.width / 2
        cell.adImgView.clipsToBounds = true
        cell.layer.borderWidth = 0.0
        
        
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        //pick reward
        let winIndex = (indexPath as NSIndexPath).row
        
        //Figure out the right answer
        currentWinSelected = myWinsObjectArray[winIndex]
        fromLocation = "Mine"
        myOwnWin = true
        
         tblContents.deselectRow(at: indexPath, animated: true)
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

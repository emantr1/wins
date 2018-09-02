//
//  PersonalCategoryViewController.swift
//  Wins
//
//  Created by Eman I on 5/11/16.
//  Copyright © 2016 Eman. All rights reserved.
//

import UIKit
import Parse

class PersonalCategoryViewController: UIViewController {

    
    var refresher: UIRefreshControl!
    @IBOutlet var tblContents : UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var arrAds : NSMutableArray! = NSMutableArray()
    //var cellblur = [Int]()
    
    
    func refresh() {
        
        
        let getCommQuery = PFQuery(className: "CommTypes")
        getCommQuery.order(byAscending: "nameId") // order by best score later
        getCommQuery.limit = 1000
        getCommQuery.whereKey("author", equalTo: currentUser!)
        //getWinsQuery.cachePolicy = PFCachePolicy.CacheElseNetwork
        getCommQuery.findObjectsInBackground() { (objects, error) -> Void in
            if let objects = objects {
                personalCommTypeArray = emptyPFArray
                for object in objects {
                    personalCommTypeArray.append(object)
                    
                }
            }
            self.tblContents.reloadData()
            self.refresher.endRefreshing()
            //self.createProducts()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        personalCommTypeArray = emptyPFArray
        //let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        
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
        getCommQuery.order(byAscending: "nameId") // order by best score later
        getCommQuery.limit = 1000
        getCommQuery.whereKey("author", equalTo: currentUser!)
        //getWinsQuery.cachePolicy = PFCachePolicy.CacheElseNetwork
        getCommQuery.findObjectsInBackground() { (objects, error) -> Void in
            if let objects = objects {
                for object in objects {
                    personalCommTypeArray.append(object)
                    
                }
            }
            self.tblContents.reloadData()
            self.activityIndicator.stopAnimating()
            //self.createProducts()
        }
        
        refresher = UIRefreshControl()
        refresher.tintColor = UIColor.white
        refresher.addTarget(self, action: #selector(PersonalCategoryViewController.refresh), for: UIControlEvents.valueChanged)
        self.tblContents.addSubview(refresher)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        controllerToStayOn = false
        
        viewsFromOtherControllers += 1
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    internal func tableView(_ tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 170.0
    }
    
    func tableView(_ tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return personalCommTypeArray.count
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
        let typeDetails = personalCommTypeArray[typeIndex]
        
        if typeDetails["image"] != nil {
            let commImage = typeDetails["image"] as! PFFile
            commImage.getDataInBackground { (data, error) -> Void in
                if error == nil {
                    if let downloadedImage = UIImage(data: data!) {
                        cell.typeReminder.setImage(downloadedImage, for: UIControlState())
                        cell.typeReminder.imageView?.contentMode = UIViewContentMode.scaleAspectFill
                        
                    }
                } else {
                    let replace = UIImage(named: "Relaxed.jpeg")
                    cell.typeReminder.setImage(replace, for: UIControlState())
                    cell.typeReminder.imageView?.contentMode = UIViewContentMode.scaleAspectFill
                    
                }
            }
        }
        
        
    }
    func setTitlesForCell(_ cell: ClassifiedListTableViewCell, indexPath: IndexPath) {
        
        //set indexrow
        let typeIndex = (indexPath as NSIndexPath).row
        //Figure out row details
        let typeDetails = personalCommTypeArray[typeIndex]
        
        if typeDetails["winCount"] != nil {
            let count = typeDetails["winCount"] as! NSNumber
            cell.info.setTitle("info:\(count)", for: UIControlState())
        }
        cell.details.text = typeDetails["fullName"] as? String
        cell.commID = typeDetails["nameId"] as! String
        cell.typeReminder.tag = typeIndex
        //cell.typeReminder.addTarget(self, action: #selector(PersonalCategoryViewController.selectionMade(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.info.tag = typeIndex
        cell.info.addTarget(self, action: #selector(PersonalCategoryViewController.infoTap(_:)), for: UIControlEvents.touchUpInside)
        
        cell.typeReminder.alpha = 1.0
        cell.details.alpha = 1.0
            
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        //let typeIndex = indexPath.row
        print("the real row number is \((indexPath as NSIndexPath).row)")
        
        
        
    }
    
    func infoTap(_ sender:UIButton) {
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let typeDetails = personalCommTypeArray[(indexPath as NSIndexPath).row]
        //let buttonRow = sender.tag
        let name = typeDetails["fullName"]
        categoryName = name as! String
        personalCategoryId = typeDetails["nameId"] as! String
        personalCategoryObjectId = typeDetails.objectId!
        print("the category name \(name) the id \(personalCategoryId)")
        if typeDetails["totalLikes"] != nil { categoryLikes = typeDetails["totalLikes"] as! Int} else { categoryLikes = 0}
        if typeDetails["totalDislikes"] != nil { categoryDislikes = typeDetails["totalDislikes"] as! Int}else { categoryDislikes = 0}
        
        if typeDetails["creator"] != nil { categoryCreator = typeDetails["creator"] as! String}else { categoryCreator = "anonymous"}
        
        if typeDetails["description"] != nil { categoryDescription = typeDetails["description"] as! String}else { categoryDescription = "description goes here"}
        
        if typeDetails["subscriber"] != nil { categorySubs = typeDetails["subscribers"] as! Int}else { categorySubs = 0}
        if typeDetails["author"] != nil { categoryPFAuthor = typeDetails["author"] as! PFUser}
        if typeDetails["winCount"] != nil { categoryWinCount = typeDetails["winCount"] as! Int}else { categoryWinCount = 0}
        
        if typeDetails["image"] != nil {
            let catImage = typeDetails["image"] as? PFFile
            catImage!.getDataInBackground { (data, error) -> Void in
                if error == nil {
                    if let downloadedImage = UIImage(data: data!) {
                        personalCatImage.image = downloadedImage
                    }
                }
            }
        }
        
    }
    
    func selectionMade(_ sender:UIButton)  -> UITableViewCell {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        var cell : ClassifiedListTableViewCell!
        cell = tblContents.dequeueReusableCell(withIdentifier: "CellClassified") as! ClassifiedListTableViewCell
        let typeDetails = personalCommTypeArray[(indexPath as NSIndexPath).row]
        let buttonRow = sender.tag
        print("this is the row we're on \(buttonRow)")
        print ("it should say this \(typeDetails["nameId"] as! String)")
        
        
        
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

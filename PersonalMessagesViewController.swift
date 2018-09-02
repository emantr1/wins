//
//  PersonalMessagesViewController.swift
//  Wins
//
//  Created by Eman I on 5/20/16.
//  Copyright © 2016 Eman. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PersonalMessagesViewController: UIViewController {
    
    
    
    var refresher: UIRefreshControl!
    @IBOutlet var tblContents : UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var arrAds : NSMutableArray! = NSMutableArray()
    var messageCommId = [String]()
    let searchController = UISearchController(searchResultsController: nil)
    var filteredMessages = [PFObject]()
    
    
    func filterContentForSearchText (_ searchText: String, scope: String = "All") {
        filteredMessages = personalCommMessagesArray.filter{message in
            return (message["details"] as AnyObject).lowercased.contains(searchText.lowercased())
        }
        tblContents.reloadData()
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
        
        
        let getMessagesQuery = PFQuery(className: "Community")
        getMessagesQuery.order(byDescending: "score") // order by best score later
        getMessagesQuery.limit = 1000
        getMessagesQuery.whereKey("category", containedIn: messageCommId)
        getMessagesQuery.findObjectsInBackground() { (objects, error) -> Void in
            if let objects = objects {
                personalCommMessagesArray = emptyPFArray
                for object in objects {
                    personalCommMessagesArray.append(object)
                    
                }
            }
            self.tblContents.reloadData()
            self.refresher.endRefreshing()
            //self.createProducts()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        personalCommMessagesArray = emptyPFArray
        messageCommId.append(personalCategoryId)
        //let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.center = (self.view.center)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tblContents.tableHeaderView = searchController.searchBar
        searchController.searchBar.sizeToFit()
        searchController.searchBar.keyboardAppearance = .dark
        searchController.searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor.white
        for subView in self.searchController.searchBar.subviews {
            for subsubView in subView.subviews {
                if let textField = subsubView as? UITextField {
                    textField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Search", comment: ""), attributes:[NSForegroundColorAttributeName: UIColor.white])
                    
                    textField.textColor = UIColor.white
                }
            }
        }
        
        // Do any additional setup after loading the view.
        let background = CAGradientLayer().blueLayer()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)
        
        // if storyboard id = personal then messageCommId = x
        
        let getMessagesQuery = PFQuery(className: "Community")
        getMessagesQuery.order(byDescending: "score") // order by best score later
        getMessagesQuery.limit = 1000
        getMessagesQuery.whereKey("category", containedIn: messageCommId)
        getMessagesQuery.findObjectsInBackground() { (objects, error) -> Void in
            if let objects = objects {
                for object in objects {
                    personalCommMessagesArray.append(object)
                    
                }
            }
            self.tblContents.reloadData()
            self.activityIndicator.stopAnimating()
            //self.createProducts()
        }
        
        refresher = UIRefreshControl()
        refresher.tintColor = UIColor.white
        refresher.addTarget(self, action: #selector(MessagesViewController.refresh), for: UIControlEvents.valueChanged)
        self.tblContents.addSubview(refresher)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        controllerToStayOn = true
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
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredMessages.count
        }
        
        return personalCommMessagesArray.count
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
        //setImageForCell(cell, indexPath: indexPath)
        setTitlesForCell(cell, indexPath: indexPath)
        return cell
    }
    
    func setImageForCell(_ cell: ClassifiedListTableViewCell, indexPath: IndexPath) {
        
        //set indexrow
        let typeIndex = (indexPath as NSIndexPath).row
        //Figure out row details
        let typeDetails = personalCommMessagesArray[typeIndex]
        
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
        var typeDetails: PFObject
        if searchController.isActive && searchController.searchBar.text != "" {
            typeDetails =  filteredMessages[typeIndex]
        } else {
            typeDetails = personalCommMessagesArray[typeIndex]
        }
        
        
        cell.details.text = typeDetails["details"] as? String
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        //let typeIndex = indexPath.row
        print("the real row number is \((indexPath as NSIndexPath).row)")
        var typeDetails: PFObject
        if searchController.isActive && searchController.searchBar.text != "" {
            typeDetails =  filteredMessages[(indexPath as NSIndexPath).row]
        } else {
            typeDetails = personalCommMessagesArray[(indexPath as NSIndexPath).row]
        }
        
        specificMessageText = (typeDetails["details"] as? String)!
        if typeDetails["author"] != nil {
            specificMessageAuthor = "by \((typeDetails["author"] as? String)!)"
            
        } else {
            specificMessageAuthor = ""
        }
        
        fromPersonal = true
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

extension PersonalMessagesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

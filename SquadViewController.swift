//
// SquadViewController.swift
//
//
//  Created by Eman Igbinosa 4/1/2016.
//
//

import UIKit
import Parse

class SquadViewController: UIViewController {
    
    @IBOutlet var tblContents : UITableView!
    var arrAds : NSMutableArray! = NSMutableArray()
    

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var team = [String]()
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        // Do any additional setup after loading the view.
        let background = CAGradientLayer().greenLayer()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)
        
        
        
        let winsQ = PFQuery(className: "Wins")
        winsQ.getObjectInBackground(withId: currentWinSelected.objectId!) {
            (win: PFObject?, error: NSError?) -> Void in
            if error == nil && win != nil {
                if win!["squad"] != nil {
                    self.team = win!["squad"] as! [String]
                    self.getCreator()
                }
            } else {
                if error != nil {
                    print(error)
                }
            }
            //self.tblContents.reloadData()
            self.activityIndicator.stopAnimating()
            
            }
        }
    
    
    func getCreator () {
        
        winCreator = currentWinSelected["winAuthor"] as? PFUser
        let userQuery = PFUser.query()
        userQuery!.getObjectInBackground(withId: winCreator!.objectId!) {
            (user: PFObject?, error: NSError?) -> Void in
            if error == nil && user != nil {
                var creator = ""
                if user!["firstName"] != nil {
                     creator = user!["firstName"] as! String
                } else {
                  creator = user!["username"] as! String
                }
                self.team.append(creator)
                self.tblContents.reloadData()
            } else {
                if error != nil {
                    print(error)}
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return team.count
        
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView!) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView!, cellForRowAtIndexPath indexPath: IndexPath!) -> UITableViewCell! {
        var cell : ClassifiedListTableViewCell!
        cell = tblContents.dequeueReusableCell(withIdentifier: "CellClassified") as! ClassifiedListTableViewCell
        //let adDic : NSDictionary = arrAds.objectAtIndex(indexPath.row) as! [String : String]
        
        //pick member
        let memberIndex = indexPath.row
        
        if team.count != 0 {
        cell.adTitleLbl.text = team[memberIndex]
        }
   
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

//
//  MessageDetailViewController.swift
//  Wins
//
//  Created by Eman I on 5/18/16.
//  Copyright © 2016 Eman. All rights reserved.
//

import UIKit

class MessageDetailViewController: UIViewController {

   
    @IBOutlet var backgroundLabel: UILabel!
    @IBOutlet var author: UILabel!
    @IBOutlet var messageText: UILabel!
    @IBOutlet var categoryPic: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        backgroundLabel.layer.borderColor = UIColor.white.cgColor
        backgroundLabel.layer.borderWidth = 2.0
        let background = CAGradientLayer().blueLayer()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)

        messageText.text = specificMessageText
        if specificMessageText.characters.count > 300 {
            messageText.font = UIFont(name:"HelveticaNeue", size: 14)
        }
        
        if fromPersonal == true {
            categoryPic.image = personalCatImage.image
        } else {
        categoryPic.image = communityCatImage.image
        }
        author.text = specificMessageAuthor
        

        // Do any additional setup after loading the view.
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

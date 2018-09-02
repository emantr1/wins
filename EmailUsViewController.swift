//
//  EmailUsViewController.swift
//  Wins
//
//  Created by Eman I on 5/17/16.
//  Copyright © 2016 Eman. All rights reserved.
//

import UIKit

class EmailUsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let background = CAGradientLayer().greenLayer()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okThanks(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
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

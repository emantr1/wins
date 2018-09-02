//
//  EmojiViewController.swift
//  classified
//
//  Created by Eman I on 4/8/16.
//  Copyright © 2016 Eman
//

import UIKit

class EmojiViewController: UIViewController {

    @IBOutlet var nextButton: UIButton!
    @IBAction func backToFeeling(_ sender: AnyObject) {
        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController!.view.layer.add(transition, forKey: nil)
        self.navigationController?.popViewController(animated: false)
    }
    @IBOutlet var emojiLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isHidden = true
        // Do any additional setup after loading the view.
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(EmojiViewController.respond(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }

    func checkNext () {
        if emojiLabel.text != "Emojis" {
            nextButton.isHidden = false
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(EmojiViewController.respond(_:)))
            swipeLeft.direction = .left
            view.addGestureRecognizer(swipeLeft)

        } else {
            nextButton.isHidden = true
        }
    }
    
    @IBAction func tapForDetails(_ sender: AnyObject) {
        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController!.view.layer.add(transition, forKey: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        controllerToStayOn = true
        
        if currentWinEmoji != "" {
            emojiLabel.text = currentWinEmoji
        }
        self.tabBarController?.tabBar.isHidden = true
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(EmojiViewController.checkNext), userInfo: nil, repeats: true)
    }
    
    func respond(_ gesture: UIGestureRecognizer)  {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.left:
                
                self.performSegue(withIdentifier: "emojiToDetail", sender: self)
                
                
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

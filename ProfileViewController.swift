//
//  ProfileViewController.swift
//  classified
//
//  Created by Eman I on 4/5/16.
//  Copyright © 2016 Eman
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var categoryButton: UIButton!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var username: UILabel!
    @IBOutlet var email: UILabel!
    @IBOutlet var count: UILabel!
    @IBOutlet var addImageButton: UIButton!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBAction func categoryTap(_ sender: AnyObject) {
    }

    @IBAction func addImage(_ sender: AnyObject) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        
        self.present(image, animated: true, completion: nil)
        activityIndicator.stopAnimating()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        //let newImage = UIImageView(image: UIImage(named: "Smiling.jpeg"))
    
        
        self.dismiss(animated: true, completion: nil)
        
        profileImage.image = image
        
        let userQuery = PFUser.query()
        userQuery!.getObjectInBackground(withId: currentUserId!) {
            (user: PFObject?, error: NSError?) -> Void in
            if error == nil && user != nil {
                let imageData = UIImageJPEGRepresentation(self.profileImage.image!, 0.5)
                let imageFile = PFFile(name:"image.png", data: imageData!)
                user!["profileImage"] = imageFile
                user!.saveInBackground()
            } else {
                if error != nil {print(error)}
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        profileImage.layer.borderColor = UIColor(red: 241/255.0, green: 175/255.0, blue: 65/255.0, alpha: 1.0).cgColor
        profileImage.layer.borderWidth = 2.0
        
        
        let str: String! = self.restorationIdentifier
        
        if str == "myProfile" {
            self.categoryButton.isHidden = true
        }
       
        if winCreator?.objectId != currentUserId {
            
            addImageButton.isHidden = true
        }
        
        var iDToUse = winCreator?.objectId
        if profSeg == 1 {
            iDToUse = currentUserId
            profSeg = 0
        }
        
        let userQuery = PFUser.query()
        userQuery!.getObjectInBackground(withId: iDToUse!) {
            (user: PFObject?, error: NSError?) -> Void in
            if error == nil && user != nil {
                
                if user!["firstName"] != nil {
                    self.username.text = user!["firstName"] as? String
                } else {
                self.username.text = "\(user!["username"])"
                }
                
                if str == "myProfile" {
                    if user!["email"] != nil {
                        self.email.text = "\(user!["email"])"
                    }
                }
                if user!["winCount"] != nil {
                self.count.text = "\(user!["winCount"]) Wins - 0 Losses"
                } else { self.count.text = "0 Wins - O Losses" }
                
                if user!["customCategories"] != nil {
                    self.categoryButton.isHidden = false
                    print("they gots some cats")
                }
                
                if user!["profileImage"] != nil {
                    let profImage = user!["profileImage"] as! PFFile
                    profImage.getDataInBackground { (data, error) -> Void in
                        if error == nil {
                            if let downloadedImage = UIImage(data: data!) {
                                self.profileImage.image = downloadedImage
                            }
                        } else {
                            self.profileImage.image = UIImage(named: "Relaxed.jpeg")
                        }
                    }
                }
                
            } else {
                if error != nil {print(error)}
                }
            }
        // Do any additional setup after loading the view.
        
        let background = CAGradientLayer().greenLayer()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ProfileViewController.respond(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnTapped (_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        controllerToStayOn = false
        viewsFromOtherControllers += 1
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

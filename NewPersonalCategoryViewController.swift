//
//  NewPersonalCategoryViewController.swift
//  Wins
//
//  Created by Eman I on 5/20/16.
//  Copyright © 2016 Eman. All rights reserved.
//

import UIKit
import Parse

class NewPersonalCategoryViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    @IBAction func changePublicSubmissions(_ sender: AnyObject) {
        
        var submission = true
        if publicSubmissions.isOn {
            submission = true
        } else { submission = false}
        
        
        
        let adjustPublic = PFQuery(className:"CommTypes")
        adjustPublic.whereKey("nameId", equalTo: personalCategoryId)
        adjustPublic.getFirstObjectInBackground(block: { (object:PFObject?, error:NSError?) -> Void in
            
            if error != nil {
                print(error)
            } else if let info = object {
                info["submissionOn"] = submission
                info.saveInBackground()
            }
        })
        

    }
    @IBOutlet var publicSubmissions: UISwitch!
    @IBOutlet var hideMessages: UISwitch!
    @IBAction func changeHideMessages(_ sender: AnyObject) {
        
        var messagesOn = true
        if hideMessages.isOn {
            messagesOn = true
        } else { messagesOn = false}
        
        
        
        let adjustPublic = PFQuery(className:"CommTypes")
        adjustPublic.whereKey("nameId", equalTo: personalCategoryId)
        adjustPublic.getFirstObjectInBackground(block: { (object:PFObject?, error:NSError?) -> Void in
            
            if error != nil {
                print(error)
            } else if let info = object {
                info["messagesOn"] = messagesOn
                info.saveInBackground()
            }
        })
    }
    @IBOutlet var categoryPicture: UIImageView!
    @IBAction func goToMessages(_ sender: AnyObject) {
        
    }
    @IBOutlet var messagesCount: UIButton!
    @IBOutlet var imagedAdded: UIButton!
    @IBOutlet var categoryTView: UITextView!
    var emptyImageView: UIImageView!
    @IBOutlet var categoryCancel: UIButton!
    @IBAction func cancelCategory(_ sender: AnyObject) {
        categoryTView.resignFirstResponder()
        categoryScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        categoryCancel.isHidden = true
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    @IBOutlet var categoryScrollView: UIScrollView!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var catDescription: UILabel!
    var categoryImageUpload: UIImageView!
    @IBOutlet var cancelMessageButton: UIButton!
    @IBAction func cancelMessage(_ sender: AnyObject) {
        textView.resignFirstResponder()
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        cancelMessageButton.isHidden = true
    }
    @IBOutlet var newCategoryTutImage: UIImageView!
    @IBOutlet var author: UILabel!
    @IBAction func okButtonTap(_ sender: AnyObject) {
        
        Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(NewCategoryViewController.introTut(_:)), userInfo: true, repeats: false)
        
        tutCountCategory = 1
        
        UserDefaults.standard.set(tutCountCategory, forKey: "tutCountCategory")
    }
    
    @IBOutlet var dislikes: UILabel!
    @IBOutlet var likes: UILabel!
    @IBOutlet var rating: UILabel!
    @IBOutlet var catTitle: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var textField: UITextField!
    @IBOutlet var submitButton: UIButton!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let limitLength = 20
    var storyboardId = ""
    var newWinCat = [String]()
    var rateScore = 0.0
    var messageLength = 200
    
    @IBAction func addCatImage(_ sender: AnyObject) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 100)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(NewCategoryViewController.getPhoto), userInfo: nil, repeats: false)
    }
    
    @IBAction func categorySubmission(_ sender: AnyObject) {
        
        if categoryTView.text.isEmpty || (textField.text?.isEmpty)! {
            displayAlert("Nothing There?", message:"Make sure to fill out both fields if you want to add a category")
        } else {
            
            
            var name = currentUser?.username
            if currentUser!["firstName"] != nil { name = currentUser!["firstName"] as? String}
            //print("this is the username \(name)")
            
            let newName = textField.text
            let shortenedName = newName!.replacingOccurrences(of: " ", with: "")
            let newId = shortenedName + currentUserId!
            print("this is the new id \(newId)")
            
            let addCat = PFObject(className:"CommTypes")
            addCat["fullName"] = newName
            addCat["nameId"] = "\(shortenedName)\(currentUserId!)"
            addCat["author"] = currentUser
            addCat["description"] = categoryTView.text
            addCat["public"] = false
            if name != nil {addCat["creator"] = name}
            
            if categoryImageUpload != nil {
                
                let imageData = UIImageJPEGRepresentation(categoryImageUpload.image!, 0.5)
                let imageFile = PFFile(name:"image.png", data: imageData!)
                addCat["image"] = imageFile
                
                categoryImageUpload = emptyImageView
                let imageSize: Int = imageData!.count
                print("size of image in KB: \(imageSize)  1024.0")
                print("there was an image and we added it")
            }
            
            categoryTView.resignFirstResponder()
            
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
                UIView.setAnimationTransition(UIViewAnimationTransition.flipFromLeft, for: self.navigationController!.view, cache: false)
            })
            self.navigationController?.popToRootViewController(animated: false)
            
            addCat.saveInBackground {
                (success: Bool, error: NSError?) -> Void in
                
                if (success) {
                    print("saved the new message")
                    
                }
                else {
                    // There was a problem, check error.description
                    print("failed this time \(error)")
                }
                
            }
            addToCategoryCount()
            displayAlert("Cool Stuff", message:"Category Added, Check your profile for a new edit icon where you can add messages to this category")
        }
        
    }
    @IBAction func submitClicked(_ sender: AnyObject) {
        
        if textView.text.isEmpty {
            displayAlert("Nothing There?", message:"Make sure to write something if you want to add")
        } else {
            
            
            var name = currentUser?.username
            if currentUser!["firstName"] != nil { name = currentUser!["firstName"] as? String}
            //print("this is the username \(name)")
            
            newWinCat.append(personalCategoryId)
            let addWin = PFObject(className:"Community")
            addWin["details"] = textView.text
            addWin["category"] = newWinCat
            addWin["emoji"] = "🤓"
            addWin["moreInfo"] = "pending approval"
            addWin["authorId"] = currentUserId
            if name != nil {addWin["author"] = name}
            
            textView.resignFirstResponder()
            
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
                UIView.setAnimationTransition(UIViewAnimationTransition.flipFromLeft, for: self.navigationController!.view, cache: false)
            })
            self.navigationController?.popViewController(animated: false)
            
            addWin.saveInBackground {
                (success: Bool, error: NSError?) -> Void in
                
                if (success) {
                    print("saved the new message")
                    personalCategoryId = ""
                    
                }
                else {
                    // There was a problem, check error.description
                    print("failed this time \(error)")
                }
                
            }
            getTotalCount()
            
            
            displayAlertMe("Cool", message:"Message Added")
                
        }
        
    }
    
    func getTotalCount() {
        var number = 0
        
        let commQuery = PFQuery(className: "Community")
        commQuery.whereKey("category", containedIn: newWinCat)
        commQuery.findObjectsInBackground() { (objects, error) -> Void in
            if let objects = objects {
                for _ in objects {
                    number += 1
                }
                self.addTotal(number)
            }
        }
        
    }
    
    func addTotal (_ number: Int) {
        
        let addTotal = PFQuery(className:"CommTypes")
        //print("this is category \(personalCategoryObjectId)")
        addTotal.getObjectInBackground(withId: personalCategoryObjectId) {
            (category: PFObject?, error: NSError?) -> Void in
            if error == nil && category != nil {
                category?["winCount"] = number + 1
                
            } else {
                if error != nil {print(error)}
            }
            if category != nil {category!.saveInBackground()}
            personalCategoryObjectId = ""
        }
    }
    func displayAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK, Cool", style: .default, handler: { (action) -> Void in
            //self.dismissViewControllerAnimated(true, completion: nil)
            
            
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayAlertMe(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK, Cool", style: .default, handler: { (action) -> Void in
            //self.dismissViewControllerAnimated(true, completion: nil)
            
            
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        storyboardId = self.restorationIdentifier!
        if storyboardId == "addMessagePersonal" {
            submitButton.layer.cornerRadius = 10.0
            catDescription.clipsToBounds = true
            catDescription.layer.cornerRadius = 10.0
            catDescription.layer.borderColor = UIColor.white.cgColor
            catDescription.layer.borderWidth = 2.0
            
            let imageQuery = PFQuery(className: "CommTypes")
            imageQuery.whereKey("nameId", equalTo: personalCategoryId)
            imageQuery.getFirstObjectInBackground(block: { (object:PFObject?, error:NSError?) -> Void in
                
                if error == nil && object != nil {
                    
                    
                    if object!["messagesOn"] != nil && object!["messagesOn"] as! Bool == true {
                        
                        //naming it "hideMessages" was confusing - my bad
                        self.hideMessages.isOn = true
                    } else {
                        self.hideMessages.isOn = false
                    }
                    if object!["submissionOn"] != nil && object!["submissionOn"] as! Bool == true {
                        self.publicSubmissions.isOn = true
                    } else {
                        self.publicSubmissions.isOn = false
                    }
                    
                    
                    
                    if object!["image"] != nil {
                        let catImage = object!["image"] as? PFFile
                        catImage!.getDataInBackground { (data, error) -> Void in
                            if error == nil {
                                if let downloadedImage = UIImage(data: data!) {
                                    self.categoryPicture.image = downloadedImage
                                }
                            }
                        }
                    }
                    
                }
                
            })
            
            
            messageLength = 300
            self.textView.delegate = self
            catTitle.text = "\(categoryName)"
            catDescription.text = categoryDescription
            author.text = author.text! + " \(categoryCreator)"
            dislikes.text = dislikes.text! + "\(categoryDislikes)"
            likes.text = likes.text! + "\(categoryLikes)"
            messagesCount.setTitle("\(categoryWinCount) messages", for: UIControlState())
            if numTimesOnApp < 4 {messagesCount.setTitle("\(categoryWinCount) messages (tap to view)", for: UIControlState())}
            print("this is category like \(categoryLikes) and dislikes \(categoryDislikes)")
            if categoryLikes != 0 {
                let dLikes = Double(categoryLikes)
                let dDislikes = Double(categoryDislikes)
                
                rateScore = (dLikes / (dLikes + dDislikes))*100
                
                self.rating.text = self.rating.text! + " \(Int(rateScore))"
            } else {
                self.rating.text = self.rating.text! + "0"
            }
            cancelMessageButton.isHidden = true
            
            
        } else {
            messageLength = 150
            self.textField.delegate = self
            self.categoryTView.delegate = self
            categoryCancel.isHidden = true
            //categorySubmitButton.layer.cornerRadius = 10.0
            
            newCategoryTutImage.isHidden = true
            
            
        }
        
        let background = CAGradientLayer().blueLayer()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        controllerToStayOn = true
        
    }
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        return numberOfChars < messageLength;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        //scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()  //if desired
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if storyboardId == "addMessagePersonal" {
            scrollView.setContentOffset(CGPoint(x: 0, y: 250), animated: true)
            cancelMessageButton.isHidden = false
        } else {
            categoryScrollView.setContentOffset(CGPoint(x: 0, y: 200), animated: true)
            categoryCancel.isHidden = false
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        if storyboardId == "addMessagePersonal" {
            textView.resignFirstResponder()
        } else {
            textField.resignFirstResponder()
            //textView.resignFirstResponder()
        }
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func getPhoto () {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        
        self.present(image, animated: true, completion: nil)
        activityIndicator.stopAnimating()
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.dismiss(animated: true, completion: nil)
        let newImage = UIImageView(image: UIImage(named: "Smiling.jpeg"))
        categoryImageUpload = newImage
        
        categoryImageUpload.image = image
        imagedAdded.setTitle("Added ✓", for: UIControlState())
        
    }
    
    func addToCategoryCount() {
        
        let userQuery = PFUser.query()
        userQuery!.getObjectInBackground(withId: currentUserId!) {
            (user: PFObject?, error: NSError?) -> Void in
            if error == nil && user != nil {
                user?.incrementKey("customCategories", byAmount: 1)
            } else {
                if error != nil {print(error)}
            }
            user?.saveInBackground()
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

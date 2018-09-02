//
//  MoreDetailViewController.swift
//  classified
//
//Created by Eman Igbinosa 4/1/2016.
//

import UIKit

class MoreDetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {

    @IBOutlet var textField: UITextView!
    @IBAction func okButton(_ sender: AnyObject) {
        Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(MoreDetailViewController.introTut(_:)), userInfo: true, repeats: false)
        button.isHidden = true
        
        tutCountMore = 0
        tutCountFinal = 1
        UserDefaults.standard.set(tutCountMore, forKey: "tutCountMore")
    }
    let button   = UIButton(type: UIButtonType.system) as UIButton
    @IBOutlet var blueLine: UILabel!
    @IBOutlet var tutImage: UIImageView!
    @IBOutlet var introTwo: UILabel!
    @IBOutlet var introOne: UILabel!
    @IBOutlet var fadedBackground: UILabel!
    @IBOutlet var okCool: UIButton!
    @IBAction func tapNext(_ sender: AnyObject) {
        if textField.hasText {
            currentWinDetails = textField.text!
        }
        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController!.view.layer.add(transition, forKey: nil)
    }
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    @IBAction func tapBack(_ sender: AnyObject) {
        if textField.hasText {
            currentWinDetails = textField.text!
        }
        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController!.view.layer.add(transition, forKey: nil)
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBOutlet var uploadedImage: UIImageView!
    @IBAction func addImage(_ sender: AnyObject) {
        
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(MoreDetailViewController.getPhoto), userInfo: nil, repeats: false)
    }
    
    func getPhoto () {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        
        self.present(image, animated: true, completion: nil)
        activityIndicator.stopAnimating()
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        return numberOfChars < 2222;
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        let newImage = UIImageView(image: UIImage(named: "Smiling.jpeg"))
        imageToUpload = newImage
        uploadedImage.isHidden = false
        
        
        
        self.dismiss(animated: true, completion: nil)
        
        uploadedImage.image = image
        imageToUpload.image = image
    }

    func introTut (_ state: Timer) {
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFromTop
        self.navigationController!.view.layer.add(transition, forKey: nil)
        
        
        blueLine.isHidden = state.userInfo as! Bool
        introTwo.isHidden = state.userInfo as! Bool
        introOne.isHidden = state.userInfo as! Bool
        tutImage.isHidden = state.userInfo as! Bool
        fadedBackground.isHidden = state.userInfo as! Bool
        okCool.isHidden = state.userInfo as! Bool
        
        let screenSize: CGRect = UIScreen.main.bounds
        if  screenSize.height < 500 {
            blueLine.isHidden = true
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        blueLine.isHidden = true
        introTwo.isHidden = true
        introOne.isHidden = true
        tutImage.isHidden = true
        fadedBackground.isHidden = true
        okCool.isHidden = true
        okCool.layer.cornerRadius = 3.0
        okCool.clipsToBounds = true
        okCool.layer.borderColor = UIColor(red: 25/255.0, green: 169/255.0, blue: 255/255.0, alpha: 1.0).cgColor
        okCool.layer.borderWidth = 2.0
        
        let screenSize: CGRect = UIScreen.main.bounds
        print("this is the screen size \(screenSize.height)")
        print("this is okbutton height \(okCool.center.y)")
        if  screenSize.height < 500 {
            okCool.center = view.center
            print("this is okbutton height changed \(okCool.center.y)")
            
            button.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
            button.layer.cornerRadius = 3.0
            button.clipsToBounds = true
            button.layer.borderWidth = 2.0
            button.layer.borderColor = UIColor(red: 25/255.0, green: 169/255.0, blue: 255/255.0, alpha: 1.0).cgColor
            button.backgroundColor = UIColor.clear
            button.setTitleColor(UIColor(red: 25/255.0, green: 169/255.0, blue: 255/255.0, alpha: 1.0), for: UIControlState())
            button.setTitle("Ok Cool", for: UIControlState())
            button.addTarget(self, action: #selector(MoreDetailViewController.buttonAction(_:)), for: UIControlEvents.touchUpInside)
            self.view.addSubview(button)
            button.center = view.center
            if tutCountMore == 1 {
                button.isHidden = false
                blueLine.isHidden = true
            } else {
                button.isHidden = true
            }
        }
        
        self.textField.delegate = self
        uploadedImage.isHidden = true
        uploadedImage.layer.borderColor = UIColor.white.cgColor
        uploadedImage.layer.borderWidth = 3.0
        uploadedImage.clipsToBounds = true
        uploadedImage.layer.cornerRadius = 8.0
        // Do any additional setup after loading the view.
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(MoreDetailViewController.respond(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(MoreDetailViewController.respond(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)

        
        if tutCountMore == 1 {
        let state = false
        
        //some check to make sure user defaults needs to show tut
        Timer.scheduledTimer(timeInterval: TimeInterval(1.0), target: self, selector: #selector(MoreDetailViewController.introTut(_:)), userInfo: state, repeats: false)
        }
    }

    func buttonAction(_ sender:UIButton!)
    {
        Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(MoreDetailViewController.introTut(_:)), userInfo: true, repeats: false)
        
        tutCountMore = 0
        tutCountFinal = 1
        UserDefaults.standard.set(tutCountMore, forKey: "tutCountMore")
        print("Button tapped")
        sender.isHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        textField.resignFirstResponder()
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    override func viewDidAppear(_ animated: Bool) {
        controllerToStayOn = true
        
        if textField.hasText == false && currentWinDetails != "" {
            textField.text = currentWinDetails
        }
        self.tabBarController?.tabBar.isHidden = true
        
        if imageToUpload != nil {
            uploadedImage.isHidden = false
            uploadedImage.image = imageToUpload.image
        }
    }
    
    func respond(_ gesture: UIGestureRecognizer)  {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.left:
                
                self.performSegue(withIdentifier: "detailToFinal", sender: self)
                
                
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

//
//  PhoneLoginViewController.swift
//  classified
//
//  Created by Eman I on 4/23/16.
//  Copyright © 2016 Eman
//

import UIKit
import Parse
import DigitsKit
import Bolts
import Crashlytics


class PhoneLoginViewController: UIViewController {

    let countryCodes: [String: String] = ["BD": "880", "BE": "32", "BF": "226", "BG": "359", "BA": "387", "BB": "1246", "WF": "681", "BL": "590", "BM": "1441", "BN": "673", "BO": "591", "BH": "973", "BI": "257", "BJ": "229", "BT": "975", "JM": "1876", "BV": "", "BW": "267", "WS": "685", "BQ": "599", "BR": "55", "BS": "1242", "JE": "441534", "BY": "375", "BZ": "501", "RU": "7", "RW": "250", "RS": "381", "TL": "670", "RE": "262", "TM": "993", "TJ": "992", "RO": "40", "TK": "690", "GW": "245", "GU": "1671", "GT": "502", "GS": "", "GR": "30", "GQ": "240", "GP": "590", "JP": "81", "GY": "592", "GG": "441481", "GF": "594", "GE": "995", "GD": "1473", "GB": "44", "GA": "241", "SV": "503", "GN": "224", "GM": "220", "GL": "299", "GI": "350", "GH": "233", "OM": "968", "TN": "216", "JO": "962", "HR": "385", "HT": "509", "HU": "36", "HK": "852", "HN": "504", "HM": " ", "VE": "58", "PR": "1787 and 1939", "PS": "970", "PW": "680", "PT": "351", "SJ": "47", "PY": "595", "IQ": "964", "PA": "507", "PF": "689", "PG": "675", "PE": "51", "PK": "92", "PH": "63", "PN": "870", "PL": "48", "PM": "508", "ZM": "260", "EH": "212", "EE": "372", "EG": "20", "ZA": "27", "EC": "593", "IT": "39", "VN": "84", "SB": "677", "ET": "251", "SO": "252", "ZW": "263", "SA": "966", "ES": "34", "ER": "291", "ME": "382", "MD": "373", "MG": "261", "MF": "590", "MA": "212", "MC": "377", "UZ": "998", "MM": "95", "ML": "223", "MO": "853", "MN": "976", "MH": "692", "MK": "389", "MU": "230", "MT": "356", "MW": "265", "MV": "960", "MQ": "596", "MP": "1670", "MS": "1664", "MR": "222", "IM": "441624", "UG": "256", "TZ": "255", "MY": "60", "MX": "52", "IL": "972", "FR": "33", "IO": "246", "SH": "290", "FI": "358", "FJ": "679", "FK": "500", "FM": "691", "FO": "298", "NI": "505", "NL": "31", "NO": "47", "NA": "264", "VU": "678", "NC": "687", "NE": "227", "NF": "672", "NG": "234", "NZ": "64", "NP": "977", "NR": "674", "NU": "683", "CK": "682", "XK": "", "CI": "225", "CH": "41", "CO": "57", "CN": "86", "CM": "237", "CL": "56", "CC": "61", "CA": "1", "CG": "242", "CF": "236", "CD": "243", "CZ": "420", "CY": "357", "CX": "61", "CR": "506", "CW": "599", "CV": "238", "CU": "53", "SZ": "268", "SY": "963", "SX": "599", "KG": "996", "KE": "254", "SS": "211", "SR": "597", "KI": "686", "KH": "855", "KN": "1869", "KM": "269", "ST": "239", "SK": "421", "KR": "82", "SI": "386", "KP": "850", "KW": "965", "SN": "221", "SM": "378", "SL": "232", "SC": "248", "KZ": "7", "KY": "1345", "SG": "65", "SE": "46", "SD": "249", "DO": "1809 and 1829", "DM": "1767", "DJ": "253", "DK": "45", "VG": "1284", "DE": "49", "YE": "967", "DZ": "213", "US": "1", "UY": "598", "YT": "262", "UM": "1", "LB": "961", "LC": "1758", "LA": "856", "TV": "688", "TW": "886", "TT": "1868", "TR": "90", "LK": "94", "LI": "423", "LV": "371", "TO": "676", "LT": "370", "LU": "352", "LR": "231", "LS": "266", "TH": "66", "TF": "", "TG": "228", "TD": "235", "TC": "1649", "LY": "218", "VA": "379", "VC": "1784", "AE": "971", "AD": "376", "AG": "1268", "AF": "93", "AI": "1264", "VI": "1340", "IS": "354", "IR": "98", "AM": "374", "AL": "355", "AO": "244", "AQ": "", "AS": "1684", "AR": "54", "AU": "61", "AT": "43", "AW": "297", "IN": "91", "AX": "35818", "AZ": "994", "IE": "353", "ID": "62", "UA": "380", "QA": "974", "MZ": "258"]

    var parsePhoneArray = [String]()
    @IBOutlet var button: UIButton!
    @IBAction func phoneButton(_ sender: AnyObject) {
        // Create a Digits appearance with Cannonball colors.
        let configuration = DGTAuthenticationConfiguration(accountFields: .defaultOptionMask)
        
        
        
        configuration?.appearance = DGTAppearance()
        //configuration.appearance.backgroundColor = UIColor(red: 25/255.0, green: 169/255.0, blue: 255/255.0, alpha: 1.0)
        configuration?.appearance.backgroundColor = UIColor(patternImage: UIImage(named: "postbg.jpg")!)
        configuration?.appearance.accentColor = UIColor.white
        
       
        
        // Start the Digits authentication flow with the custom appearance.
        Digits.sharedInstance().authenticate(with: nil, configuration:configuration!) { (session, error) in
            if session != nil {
                // Navigate to the main app screen to select a theme.
               
                
                //self.dismissViewControllerAnimated(true, completion: nil)
                let phone = session!.phoneNumber
                let stringArray = phone?.components(
                    separatedBy: CharacterSet.decimalDigits.inverted)
                let phoneClean = stringArray?.joined(separator: "")
                print ("this is new string \(phoneClean)")
                self.parsePhoneArray.append(phoneClean!)
                
                //get number without Country code
                let locale = Locale.current
                if let country = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as? String {
                    print("this is the country \(country)")
                    
                    if self.countryCodes[country] != nil {
                        let value = self.countryCodes[country]
                        let codeLength = value!.characters.count
                    print("this is country code length \(codeLength)")
                    
                    let shortenedPhone = phoneClean?.substring(from: (phoneClean?.characters.index((phoneClean?.startIndex)!, offsetBy: codeLength))!)
                        print("this is the new phone short \(shortenedPhone)")
                        self.parsePhoneArray.append(shortenedPhone!)
                        print("this is paresephonearray \(self.parsePhoneArray)")

                        self.addToParse()
                    }
                } else {
                    
                    print("this is paresephonearray \(self.parsePhoneArray)")
                    self.addToParse()
                }
                
                
                // Tie crashes to a Digits user ID in Crashlytics.
                Crashlytics.sharedInstance().setUserIdentifier(session?.userID)
                
                // Log Answers Custom Event.
                Answers.logLogin(withMethod: "Digits", success: true, customAttributes: ["User ID": session?.userID])
            } else {
                // Log Answers Custom Event.
                Answers.logLogin(withMethod: "Digits", success: false, customAttributes: ["Error": error?.localizedDescription])
            }
        }
    }
    
    func addToParse () {
        
        let userQuery = PFUser.query()
        userQuery!.getObjectInBackground(withId: currentUserId!) {
            (user: PFObject?, error: NSError?) -> Void in
            if error == nil && user != nil {
                user!["phoneNumber"] = self.parsePhoneArray
                user!.saveInBackground()
                UserDefaults.standard.set(self.parsePhoneArray, forKey: "myPhoneArray")
                print("this is myphonearray \(myPhoneArray)")
                addedWin = true
            } else {
                if error != nil {print(error)}
            }
            numberVerified = 1
            UserDefaults.standard.set(numberVerified, forKey: "numberVerified")
            self.displayAlert("Verified", message: "You're good to go!")
        }
    }
    
    @IBAction func goBack(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func displayAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK, Cool", style: .default, handler: { (action) -> Void in
            //self.dismissViewControllerAnimated(true, completion: nil)
                addedWin = true
                self.dismiss(animated: true, completion: nil)
            
        }))
        self.present(alert, animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        controllerToStayOn = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        button.layer.cornerRadius = 14.0
        button.clipsToBounds = true
        // Do any additional setup after loading the view.
        
               
        /*let authButton = DGTAuthenticateButton(authenticationCompletion: { (session: DGTSession?, error: NSError?) in
            if (session != nil) {
                // TODO: associate the session userID with your user model
                // get the phone and add it to parse
                // in my wins use phone look up to fill out page
                let message = "Phone number: \(session!.phoneNumber)"
                let alertController = UIAlertController(title: "You are logged in!", message: message, preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: .None))
                self.presentViewController(alertController, animated: true, completion: .None)
            } else {
                NSLog("Authentication error: %@", error!.localizedDescription)
            }
        })
        authButton.center = self.view.center
        self.view.addSubview(authButton)*/

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

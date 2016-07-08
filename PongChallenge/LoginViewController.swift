//
//  LoginViewController.swift
//  PongChallenge
//
//  Created by Matthew Olson on 7/8/16.
//  Copyright © 2016 Molson. All rights reserved.
//

import UIKit
import PhoneNumberKit
import Parse

class LoginViewController: UIViewController {
    
    let nameField = UITextField(frame: CGRectMake(20, 170, UIScreen.mainScreen().bounds.width-40, 40))
    let phoneField = PhoneNumberTextField()
    let passwordField = UITextField(frame: CGRectMake(20, 250, UIScreen.mainScreen().bounds.width-40, 40))
    let signUpButton = UIButton(frame: CGRectMake(20, 300, UIScreen.mainScreen().bounds.width-40, 40))
    let signInButton = UIButton(frame: CGRectMake(20, 300, UIScreen.mainScreen().bounds.width-40, 40))
    var imageView = UIImageView(frame: CGRectMake(UIScreen.mainScreen().bounds.width/2-55, 60, 110, 110))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        let options = ["Sign Up", "Sign In"]
        let sc = UISegmentedControl(items: options)
        sc.frame = CGRectMake(20, 20, UIScreen.mainScreen().bounds.width-40, 40)
        sc.selectedSegmentIndex = 0
        sc.backgroundColor = UIColor.whiteColor()
        sc.tintColor = UIColor.redColor()
        sc.addTarget(self, action: #selector(changedSC), forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(sc)
        
        nameField.placeholder = "Full Name"
        nameField.borderStyle = UITextBorderStyle.RoundedRect
        nameField.autocorrectionType = UITextAutocorrectionType.No
        self.view.addSubview(nameField)
        
        phoneField.frame = CGRectMake(20, 210, UIScreen.mainScreen().bounds.width-40, 40)
        phoneField.placeholder = "Mobile Number"
        phoneField.borderStyle = UITextBorderStyle.RoundedRect
        self.view.addSubview(phoneField)
        
        passwordField.placeholder = "Password"
        passwordField.borderStyle = UITextBorderStyle.RoundedRect
        passwordField.secureTextEntry = true
        self.view.addSubview(passwordField)
        
        signUpButton.setTitle("Sign Up", forState: UIControlState.Normal)
        signUpButton.backgroundColor = UIColor.redColor()
        signUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signUpButton.addTarget(self, action: #selector(signUpPressed), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(signUpButton)
        
        signInButton.setTitle("Sign In", forState: UIControlState.Normal)
        signInButton.backgroundColor = UIColor.redColor()
        signInButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signInButton.addTarget(self, action: #selector(signInPressed), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    func signUpPressed(){
        
        if phoneField.isValidNumber && phoneField.currentRegion == "US"{
            var phoneNumber = phoneField.text!.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("")
            
            if phoneNumber.characters.count == 10 {
                phoneNumber = "1" + phoneNumber
            }
            
            let random = arc4random_uniform(899999) + 100000;
            
            let user = PFUser()
            user.username = phoneNumber
            user.password = passwordField.text
            user["name"] = nameField.text
            user["random"] = Double(random)
            user["isVerfied"] = false
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    let alert = UIAlertController(title: "Error signing up", message: error.userInfo["error"] as! NSString as String, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    PFCloud.callFunctionInBackground("smsLoginVerification", withParameters: ["phonenumber":phoneNumber, "messagebody":"Verification Code: " + String(random)])
                    let verificationViewController : VerificationViewController = VerificationViewController()
                    self.presentViewController(verificationViewController, animated: true, completion: nil)
                }
            }
            
        } else {
            let alert = UIAlertController(title: "Error", message: "Must enter valid US Number", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func signInPressed () {
        if phoneField.isValidNumber && phoneField.currentRegion == "US"{
            var phoneNumber = phoneField.text!.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("")
            
            if phoneNumber.characters.count == 10 {
                phoneNumber = "1" + phoneNumber
            }
            
            PFUser.logInWithUsernameInBackground(phoneNumber, password:passwordField.text!) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    let tabBar = UITabBarController()
                    tabBar.setViewControllers([ChallengesViewController(), UIViewController(), UIViewController()], animated: true)
                    self.presentViewController(tabBar, animated: true, completion: nil) // TODO
                } else {
                    let alert = UIAlertController(title: "Error logging in", message: error!.userInfo["error"] as! NSString as String, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }
            }
            
        }
    }
    
    func changedSC(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.view.addSubview(nameField)
            self.view.addSubview(signUpButton)
            signInButton.removeFromSuperview()
            imageView.frame = CGRectMake(UIScreen.mainScreen().bounds.width/2-55, 60, 110, 110)
        } else {
            nameField.removeFromSuperview()
            signUpButton.removeFromSuperview()
            self.view.addSubview(signInButton)
            imageView.frame = CGRectMake(UIScreen.mainScreen().bounds.width/2-55, 80, 110, 110)
        }
        
    }
    
}

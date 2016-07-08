//
//  VerificationViewController.swift
//  PongChallenge
//
//  Created by Matthew Olson on 7/8/16.
//  Copyright © 2016 Molson. All rights reserved.
//

import UIKit
import Parse

class VerificationViewController: UIViewController {
    
    let label = UILabel(frame: CGRectMake(0, 40, UIScreen.mainScreen().bounds.width, 40))
    let verificationField = UITextField(frame: CGRectMake(20, 80, UIScreen.mainScreen().bounds.width-40, 40))
    let verifyButton = UIButton(frame: CGRectMake(20, 120, UIScreen.mainScreen().bounds.width-40, 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        label.textAlignment = NSTextAlignment.Center
        label.text = "Wait for SMS verification code"
        self.view.addSubview(label)
        
        verificationField.keyboardType = UIKeyboardType.NumberPad
        verificationField.borderStyle = UITextBorderStyle.RoundedRect
        self.verificationField.placeholder = "Verification Code"
        self.view.addSubview(verificationField)
        
        verifyButton.setTitle("Sign Up", forState: UIControlState.Normal)
        verifyButton.backgroundColor = UIColor.redColor()
        verifyButton.addTarget(self, action: #selector(verifyPressed), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(verifyButton)
        
    }
    
    func verifyPressed(){
        let user = PFUser.currentUser()
        if String(user!["random"]) == verificationField.text {
            user!["isVerified"] = true
            user?.saveInBackground()
            
            let tabBar = UITabBarController()
            tabBar.setViewControllers([ChallengesViewController(), UIViewController(), UIViewController()], animated: true)
            self.presentViewController(tabBar, animated: true, completion: nil) // TODO
        } else {
            let alert = UIAlertController(title: "Verification code does not match", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
}

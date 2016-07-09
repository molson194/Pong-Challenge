//
//  NewChallengeViewController.swift
//  PongChallenge
//
//  Created by Matthew Olson on 7/8/16.
//  Copyright © 2016 Molson. All rights reserved.
//

import UIKit
import Parse

class NewChallengeViewController: UIViewController {
    
    let sc = UISegmentedControl(items: ["10 Cup", "21 Cup"])
    let player1 = UIButton(frame: CGRectMake(20, 130, UIScreen.mainScreen().bounds.width-40, 40))
    let player2 = UIButton(frame: CGRectMake(20, 175, UIScreen.mainScreen().bounds.width-40, 40))
    let player3 = UIButton(frame: CGRectMake(20, 220, UIScreen.mainScreen().bounds.width-40, 40))
    let player4 = UIButton(frame: CGRectMake(20, 290, UIScreen.mainScreen().bounds.width-40, 40))
    let player5 = UIButton(frame: CGRectMake(20, 335, UIScreen.mainScreen().bounds.width-40, 40))
    let player6 = UIButton(frame: CGRectMake(20, 380, UIScreen.mainScreen().bounds.width-40, 40))
    var pongTeam : [String] = [String](count:6, repeatedValue: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 64))
        
        navigationBar.barTintColor = UIColor.redColor()
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let navigationItem = UINavigationItem()
        navigationItem.title = "New Challenge"
        let leftButton =  UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(goBack))
        leftButton.tintColor = UIColor.whiteColor()
        let rightButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(goDone))
        rightButton.tintColor = UIColor.whiteColor()
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
        
        navigationBar.items = [navigationItem]
        self.view.addSubview(navigationBar)
        
        sc.frame = CGRectMake(20, 70, UIScreen.mainScreen().bounds.width-40, 40)
        sc.selectedSegmentIndex = 0
        sc.backgroundColor = UIColor.whiteColor()
        sc.tintColor = UIColor.redColor()
        sc.addTarget(self, action: #selector(changedSC), forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(sc)
        
        player1.setTitle(PFUser.currentUser()?.objectForKey("name") as? String, forState: UIControlState.Normal)
        player1.backgroundColor = UIColor.redColor()
        player1.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        pongTeam.removeAtIndex(0)
        pongTeam.insert((PFUser.currentUser()?.username)!, atIndex: 0)
        self.view.addSubview(player1)
        
        player2.setTitle("Player 2", forState: UIControlState.Normal)
        player2.backgroundColor = UIColor.redColor()
        player2.tag = 2
        player2.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        player2.addTarget(self, action: #selector(addPlayer), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(player2)
        
        player3.setTitle("Player 3", forState: UIControlState.Normal)
        player3.backgroundColor = UIColor.redColor()
        player3.tag = 3
        player3.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        player3.addTarget(self, action: #selector(addPlayer), forControlEvents: UIControlEvents.TouchUpInside)
        
        let vs = UILabel(frame: CGRectMake(0, 265, UIScreen.mainScreen().bounds.width, 20))
        vs.textAlignment = NSTextAlignment.Center
        vs.text = "------------vs-------------"
        self.view.addSubview(vs)
        
        player4.setTitle("Player 4", forState: UIControlState.Normal)
        player4.backgroundColor = UIColor.redColor()
        player4.tag = 4
        player4.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        player4.addTarget(self, action: #selector(addPlayer), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(player4)
        
        player5.setTitle("Player 5", forState: UIControlState.Normal)
        player5.backgroundColor = UIColor.redColor()
        player5.tag = 5
        player5.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        player5.addTarget(self, action: #selector(addPlayer), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(player5)
        
        player6.setTitle("Player 6", forState: UIControlState.Normal)
        player6.backgroundColor = UIColor.redColor()
        player6.tag = 6
        player6.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        player6.addTarget(self, action: #selector(addPlayer), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func goBack() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func resetTeam(array: [String]) {
        pongTeam = array
    }
    
    func goDone() {
        let challenge = PFObject(className:"Challenge")
        if (sc.selectedSegmentIndex == 0) {
            pongTeam.removeAtIndex(5)
            pongTeam.removeAtIndex(2)
            challenge["style"] = true;
        } else {
            challenge["style"] = false;
        }
        
        challenge["members"] = pongTeam
        challenge["hasWinnerLeft"] = false
        challenge["hasWinnerRight"] = false
        challenge["cupDiff"] = 0
        challenge.saveInBackgroundWithBlock { (success, error) in
            if error == nil {
                // TODO text all people
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func changedSC(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            self.view.addSubview(player3)
            self.view.addSubview(player6)
            
        } else {
            player3.removeFromSuperview()
            player6.removeFromSuperview()
        }
    }
    
    func addPlayer(sender: UIButton) {
        let addPlayerView = AddPlayerViewController()
        addPlayerView.setPrevious(sender, array: pongTeam, vc : self)
        self.presentViewController(addPlayerView, animated: true, completion: nil)
        
    }
    

}

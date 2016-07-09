//
//  ChallengesViewController.swift
//  PongChallenge
//
//  Created by Matthew Olson on 7/8/16.
//  Copyright © 2016 Molson. All rights reserved.
//

import UIKit
import ParseUI

class ChallengesViewController: PFQueryTableViewController {
    
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.parseClassName = "Challenge"
        self.objectsPerPage = 20
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 64))
        
        navigationBar.barTintColor = UIColor.redColor()
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let navigationItem = UINavigationItem()
        navigationItem.title = "Open Challenges"
        let rightButton = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(create))
        rightButton.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = rightButton
        
        navigationBar.items = [navigationItem]
        self.tableView.tableHeaderView = navigationBar
    
    }
    
    func create() {
        self.presentViewController(NewChallengeViewController(), animated: true, completion: nil)
    }
    
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "Challenge")
        query.whereKey("members", containsString: PFUser.currentUser()?.username)
        query.orderByDescending("createdAt")
        
        return query
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TODO
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        let challenge = self.objects![indexPath.row]
        let players = challenge["members"] as! [String]
        
        let player1 = UIButton(frame: CGRectMake(0, 5, UIScreen.mainScreen().bounds.width/2, 20))
        player1.setTitle(players[0], forState: UIControlState.Normal)
        player1.setTitleColor(UIColor.blackColor(), forState: .Normal)
        cell.contentView.addSubview(player1)
        
        let player2 = UIButton(frame: CGRectMake(0, 30, UIScreen.mainScreen().bounds.width/2, 20))
        player2.setTitle(players[1], forState: UIControlState.Normal)
        player2.setTitleColor(UIColor.blackColor(), forState: .Normal)
        cell.contentView.addSubview(player2)
        
        let player3 : UIButton
        let player4 : UIButton
        
        if challenge["style"] as! Bool {
            player3 = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.width/2, 5, UIScreen.mainScreen().bounds.width/2, 20))
            player4 = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.width/2, 30, UIScreen.mainScreen().bounds.width/2, 20))
        } else {
            player3 = UIButton(frame: CGRectMake(0, 55, UIScreen.mainScreen().bounds.width/2, 20))
            player4 = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.width/2, 5, UIScreen.mainScreen().bounds.width/2, 20))
            
            let player5 = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.width/2, 30, UIScreen.mainScreen().bounds.width/2, 20))
            player5.setTitle(players[4], forState: UIControlState.Normal)
            player5.setTitleColor(UIColor.blackColor(), forState: .Normal)
            cell.contentView.addSubview(player5)

            let player6 = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.width/2, 55, UIScreen.mainScreen().bounds.width/2, 20))
            player6.setTitle(players[5], forState: UIControlState.Normal)
            player6.setTitleColor(UIColor.blackColor(), forState: .Normal)
            cell.contentView.addSubview(player6)
        }
        
        player3.setTitle(players[2], forState: UIControlState.Normal)
        player3.setTitleColor(UIColor.blackColor(), forState: .Normal)
        cell.contentView.addSubview(player3)
        
        player4.setTitle(players[3], forState: UIControlState.Normal)
        player4.setTitleColor(UIColor.blackColor(), forState: .Normal)
        cell.contentView.addSubview(player4)
        
        return cell
    }
    
}

//
//  FeedViewController.swift
//  Gram
//
//  Created by Sumedha Mehta on 6/20/16.
//  Copyright © 2016 Sumedha Mehta. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var gramTitleLabel: UILabel!
    var postObjects:  [PFObject] = []
    var queryLimit = 3
    var queryAdd = 2
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    let HeaderViewIdentifier = "TableViewHeaderView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleLabel = gramTitleLabel
        self.navigationItem.titleView = titleLabel
        
        //FOR THE INFINITE SCROLL -->
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        //FOR THE PULL TO REFRESH
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        tableView.dataSource = self
        
        //initial load
        tableView.delegate = self
        getQuery(queryLimit)
        self.tableView.reloadData()
        
        //FOR THE TABLEVIEW AND DATA
        getQuery(queryLimit)
        //NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(FeedViewController.onTimer), userInfo: nil, repeats: true)
        onTimer()
        self.tableView.reloadData()
    

        // STICKY LABEL
        tableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        let query = PFQuery(className:"Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = queryLimit
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    self.postObjects = objects
                }
            }
            self.tableView.reloadData()
        }
        refreshControl.endRefreshing()

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapLogout(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return postObjects.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! PostCellTableViewCell
        let image = postObjects[indexPath.section]
        let user = postObjects[indexPath.section]["author"] as! PFUser
        print(user)
        let username = user.username! as String
        print(username)
        var instagramPost: PFObject! {
            didSet {
                cell.postedImg.file = instagramPost["media"] as? PFFile
                cell.postedImg.loadInBackground()
            }
        }
        instagramPost = image
        //cell.userLabel.text = String(username)
        
        cell.profPic.layer.cornerRadius = 20;
        cell.profPic.layer.masksToBounds = true
        var instagramPP: PFObject! {
            didSet {
                if (instagramPP["ProfilePic"] as? PFFile) != nil {
                    cell.profPic.file = instagramPP["ProfilePic"] as?PFFile
                    cell.profPic.loadInBackground()
                }
                else {
                    cell.profPic.image = UIImage(named: "Image-5")
                }
            }
        }
        instagramPP = user
        let caption = postObjects[indexPath.section]["caption"]
        let likeCount = postObjects[indexPath.section]["likesCount"] as! Int
        cell.captionLabel.text = caption as! String
        cell.likesCountLabel.text = String(likeCount)
        cell.objId = postObjects[indexPath.section].objectId!
        cell.currentCount = likeCount
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(HeaderViewIdentifier)! as UITableViewHeaderFooterView
        header.textLabel!.text = postObjects[section]["author"].username
        header.textLabel!.textColor = UIColor.orangeColor()
        return header
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func onTimer() {
        getQuery(queryLimit)
        self.tableView.reloadData()
    }
    
    func getQuery(limit: Int) {
        let query = PFQuery(className:"Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = limit
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) messages.")
                // Do something with the found objects
                if let objects = objects {
                    self.postObjects = objects
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        self.tableView.reloadData()
        }
        self.isMoreDataLoading = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "detailsSegue") {
            let viewC = segue.destinationViewController as! ImageDetailViewController
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            let post = postObjects[(indexPath!.row)]
            let caption = postObjects[indexPath!.row]["caption"] as! String
            let user = postObjects[indexPath!.row]["author"]
            let username = user.username as String!
            let likeCount = postObjects[indexPath!.row]["likesCount"] as! Int
            let date = postObjects[indexPath!.row]["timestamp"] as! String
            viewC.postThing = post
            viewC.nameText = String(username)
            viewC.captionText = caption
            print(likeCount)
            viewC.likeCount = likeCount
            viewC.dateText = date
        }
        else {
            let viewC = segue.destinationViewController as! LoginViewController
            print("whatup")
        }
        
        
        
        
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
            if (!self.isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollViewContentThreshold = scrollViewContentHeight - tableView.bounds.size.height
            if scrollView.contentOffset.y < scrollViewContentThreshold && tableView.dragging {
                //data is currently loading
                self.isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()

                //data stops loading in getQuery
                queryLimit = queryLimit + queryAdd
                getQuery(queryLimit)
            }
            // ... Code to load more results ...
            
        }
    }


}




//class singlePost: FeedViewController {
//    var postImage:
//    
//}



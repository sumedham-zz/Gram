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
    var postObjects:  [PFObject] = []
    var queryLimit = 3
    var queryAdd = 2
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(FeedViewController.onTimer), userInfo: nil, repeats: true)
        self.tableView.reloadData()
    

        // Do any additional setup after loading the view.
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postObjects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! PostCellTableViewCell
        let image = postObjects[indexPath.row]
        let caption = postObjects[indexPath.row]["caption"]
        let user = postObjects[indexPath.row]["author"]
        let username = user.username
        var instagramPost: PFObject! {
            didSet {
                cell.postedImg.file = instagramPost["media"] as? PFFile
                cell.postedImg.loadInBackground()
            }
        }
        instagramPost = image
        
        cell.postedCaptionLabel.text = caption as! String
        
        
        cell.userLabel.text = username
        return cell
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
        }
        self.isMoreDataLoading = false
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



//
//  MyGramViewController.swift
//  Gram
//
//  Created by Sumedha Mehta on 6/20/16.
//  Copyright © 2016 Sumedha Mehta. All rights reserved.
//

import UIKit
import Parse
import ParseUI


class MyGramViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var postObjects:  [PFObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
         NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: #selector(FeedViewController.onTimer), userInfo: nil, repeats: true)
        getQuery(20)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postObjects.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("myPostCell", forIndexPath: indexPath) as! MyPersonalCollectionViewCell
        let image = postObjects[indexPath.row]
        let caption = postObjects[indexPath.row]["caption"]
        let user = postObjects[indexPath.row]["author"]
        let username = user.username
        var instagramPost: PFObject! {
            didSet {
                cell.myImage.file = instagramPost["media"] as? PFFile
                cell.myImage.loadInBackground()
            }
        }
        instagramPost = image
        
        return cell

        
        
    }
    
    
    func getQuery(limit: Int) {
        let query = PFQuery(className:"Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.whereKey("author", equalTo: PFUser.currentUser()!)
        query.limit = limit
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    self.postObjects = objects
                    print(self.postObjects)
                }
            } else {
               print("Error: \(error!) \(error!.userInfo)")
            }
            self.collectionView.reloadData()
        }
    }
    
    func onTimer() {
        getQuery(20)
        self.collectionView.reloadData()
    }
    
}







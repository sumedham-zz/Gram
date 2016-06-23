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
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var setPicButton: UIButton!
    
    var postObjects:  [PFObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
         NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(FeedViewController.onTimer), userInfo: nil, repeats: true)
        getQuery(20)
        profileNameLabel.text = PFUser.currentUser()?.username
        
        
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
    
    @IBAction func onTapImage(sender: AnyObject) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        
        let choosePicture = UIAlertAction(title: "Choose Picture From Album", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("choosePic")
            let vc = UIImagePickerController()
            //vc.delegate  = self
            vc.allowsEditing = true
            vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(vc, animated: true, completion: nil)
            
        })
        let takePicture = UIAlertAction(title: "Take Picture", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("fileSaved")
        })
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        // 4
        optionMenu.addAction(choosePicture)
        optionMenu.addAction(takePicture)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.presentViewController(optionMenu, animated: true, completion: nil)
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
    
    
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        profileImage.image = editedImage
        let user = PFUser.currentUser()
        let post = PFObject(className: "Post")
        post["Profile Pic"] = Post.getPFFileFromImage(profileImage.image)
        
        
        
        // Do something with the images (based on your use case)
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
        if(profileImage.image != nil) {
            setPicButton.hidden = true
        }
    }

    
    
    
}







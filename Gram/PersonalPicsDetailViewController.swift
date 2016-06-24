//
//  PersonalPicsDetailViewController.swift
//  Gram
//
//  Created by Sumedha Mehta on 6/24/16.
//  Copyright © 2016 Sumedha Mehta. All rights reserved.
//

import UIKit
import ParseUI
import Parse

class PersonalPicsDetailViewController: UIViewController {
    
    @IBOutlet weak var postImage: PFImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profilePicImage: PFImageView!
    var Post: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePicImage.layer.cornerRadius = 20;
        profilePicImage.layer.masksToBounds = true
        print(Post)
        let person = Post!["author"]
        usernameLabel.text = person.username
        likeCountLabel.text = String(Post!["likesCount"])
        captionLabel.text = String(Post!["caption"])
        var instagramPost: PFObject! {
            didSet {
                postImage.file = instagramPost["media"] as? PFFile
                postImage.loadInBackground()
            }
        }
        instagramPost = Post
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        
        
        var instagramPP: PFObject! {
            didSet {
                if (instagramPP["ProfilePic"] as? PFFile) != nil {
                    profilePicImage.file = instagramPP["ProfilePic"] as?PFFile
                    profilePicImage.loadInBackground()
                }
                else {
                    profilePicImage.image = UIImage(named: "Image-5")
                }
            }
        }
        instagramPP = PFUser.currentUser()
        
        
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
    @IBAction func onTapBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

//
//  ImageDetailViewController.swift
//  Gram
//
//  Created by Sumedha Mehta on 6/23/16.
//  Copyright © 2016 Sumedha Mehta. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ImageDetailViewController: UIViewController {
    @IBOutlet weak var postImage: PFImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeNumberLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    var nameText: String?
    var captionText: String?
    var likeCount: Int?
    var postThing: PFObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = nameText
        captionLabel.text = captionText
        likeNumberLabel.text = String(likeCount!)
        var instagramPost: PFObject! {
            didSet {
                postImage.file = instagramPost["media"] as? PFFile
                postImage.loadInBackground()
            }
        }
        instagramPost = postThing

        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onTapBack(sender: AnyObject) {
        shouldPerformSegueWithIdentifier("goBackToFeed", sender: nil)
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

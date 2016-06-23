//
//  PostCellTableViewCell.swift
//  Gram
//
//  Created by Sumedha Mehta on 6/21/16.
//  Copyright © 2016 Sumedha Mehta. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PostCellTableViewCell: UITableViewCell {

    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var postedCaptionLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var postedImg: PFImageView!
    var currentCount: Int = 0
    var objId: String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeButtonPressed(sender: AnyObject) {
        currentCount = currentCount + 1
        var query = PFQuery(className:"Post")
        query.getObjectInBackgroundWithId(objId) {
            (object, error) -> Void in
            if error != nil {
                print(error)
            } else {
                object!["likesCount"] = self.currentCount as Int    // this is where error is occuring
                object!.saveInBackground()
            }
        }
        
        
        
    }
    
    
    

}

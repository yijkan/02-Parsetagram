//
//  PostTableViewCell.swift
//  Parsetagram
//
//  Created by Yijin Kang on 6/20/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit
import ParseUI

/**
 * Cell for table in Posts view (Parsetagram)
 */

class PostTableViewCell : UITableViewCell {
    
    @IBOutlet weak var postImageView: PFImageView!
    @IBOutlet weak var postImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var captionLabel: UILabel!
    
    var post:Post! {
        didSet { /** set the caption and  **/
            if let caption = self.post.cap {
                self.captionLabel.text = caption
            } else {
                self.captionLabel.hidden = true
            }
            
            var presized:Bool = false
            let imageViewWidth = self.postImageView.frame.size.width
            if let ratio = post.heightToWidth {
                self.postImageHeightConstraint.constant = imageViewWidth * ratio
                print("resized")
                presized = true
            }
            
            self.postImageView.file = post.image
//            self.postImageView.clipsToBounds = true
//            self.postImageView.contentMode = .ScaleAspectFit

            self.postImageView.loadInBackground { (image:UIImage?, error:NSError?) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else {
                    if let image = image {

                        // resizes the imageView to the size of the image
                        if !presized {
                            let imageHeight = image.size.height
                            let imageWidth = image.size.width
                            self.postImageHeightConstraint.constant = imageViewWidth * imageHeight / imageWidth
                            let query = PFQuery(className: "Post")
                            query.getObjectInBackgroundWithId(self.post.id) {
                                (post: PFObject?, error: NSError?) -> Void in
                                    if let error = error {
                                        print(error.localizedDescription)
                                    } else if let post = post {
                                        post["ratio"] = imageHeight / imageWidth 
                                        post.saveInBackground()
                                    }
                                 }
                        }
                    }
                }
            }
        }
    }
}
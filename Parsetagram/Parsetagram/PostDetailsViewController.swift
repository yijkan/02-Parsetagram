//
//  PostDetailsViewController.swift
//  Parsetagram
//
//  Created by Yijin Kang on 6/21/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit
import ParseUI

class PostDetailsViewController : UIViewController {
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var postImageView: PFImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var postImageHeightConstraint: NSLayoutConstraint!
    
    var post:Post!
    var imageViewWidth:CGFloat!
    var timestampPrefix:String = " on " // top of the view reads "[username] on [timestamp]"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authorLabel.text = post.author.username
        timestampLabel.text = timestampPrefix + post.timestamp
        
        if let cap = post.cap {
            captionLabel.text = cap
        } else {
            captionLabel.hidden = true // hide captionLabel if there is no caption. allow the image to reach the bottom of the screen
        }
        
        var presized:Bool = false
        if let ratio = post.heightToWidth { // resize imageView with saved ratio if available
            self.postImageHeightConstraint.constant = imageViewWidth * ratio
            presized = true
        }

        postImageView.file = post.image
        postImageView.clipsToBounds = true
        postImageView.contentMode = .ScaleAspectFit
        
        self.postImageView.loadInBackground { (image:UIImage?, error:NSError?) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                if let image = image {
                    if !presized {
                        // resizes the imageView to the size of the image if it hasn't been already
                        let imageHeight = image.size.height
                        let imageWidth = image.size.width
                    
                        self.postImageHeightConstraint.constant = self.imageViewWidth * imageHeight / imageWidth
                    }
                }
            }
        }
    }
    
}

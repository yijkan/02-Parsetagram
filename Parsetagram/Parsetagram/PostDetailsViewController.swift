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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authorLabel.text = post.author.username
        timestampLabel.text = " on " + post.timestamp
        
        if let cap = post.cap {
            captionLabel.text = cap
        } else {
            captionLabel.hidden = true
        }
        
        var presized:Bool = false
        if let ratio = post.heightToWidth {
            self.postImageHeightConstraint.constant = imageViewWidth * ratio
            presized = true
            print("presized detail view with ratio \(ratio), imageViewWidth \(imageViewWidth)")
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
                        // resizes the imageView to the size of the image
                        let imageHeight = image.size.height
                        let imageWidth = image.size.width
                    
                        self.postImageHeightConstraint.constant = self.imageViewWidth * imageHeight / imageWidth
                        print("resized detail view")
                    }
                }
            }
        }
    }
    
}

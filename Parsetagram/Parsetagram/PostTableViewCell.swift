//
//  PostTableViewCell.swift
//  Parsetagram
//
//  Created by Yijin Kang on 6/20/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit
import ParseUI

class PostTableViewCell : UITableViewCell {
    
    @IBOutlet weak var postImageView: PFImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    var post:Post! {
        didSet {
            postImageView.clipsToBounds = true
            postImageView.contentMode = .ScaleAspectFit
            
            self.postImageView.file = post.image
            self.postImageView.loadInBackground()
            
            if let caption = post.cap {
                self.captionLabel.text = caption
            } else {
                self.captionLabel.hidden = true
            }
        }
    }
}
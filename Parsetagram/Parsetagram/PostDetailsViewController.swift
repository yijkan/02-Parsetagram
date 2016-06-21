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
    var post:Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postImageView.clipsToBounds = true
        postImageView.contentMode = .ScaleAspectFit
        postImageView.file = post.image
        self.postImageView.loadInBackground()
        
        // TODO trying to resize
        postImageView.frame = CGRectMake(postImageView.frame.origin.x, postImageView.frame.origin.y, postImageView.image!.size.width, postImageView.image!.size.width)
        
        authorLabel.text = post.author.username
        print(post.author.username)
        timestampLabel.text = " on " + post.timestamp
        print(post.timestamp)
        if let cap = post.cap {
            captionLabel.text = cap
            print(cap)
        } else {
            captionLabel.hidden = true
        }
    }
}

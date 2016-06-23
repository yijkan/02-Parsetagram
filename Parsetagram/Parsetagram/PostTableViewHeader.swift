//
//  PostTableViewHeader.swift
//  Parsetagram
//
//  Created by Yijin Kang on 6/21/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit
import Parse

class PostTableViewHeaderView : UITableViewHeaderFooterView {
   
//    @IBOutlet weak var headerContentView: UIView!
    @IBOutlet weak var authorLabel: UILabel!
    
    var post:Post! {
        didSet {
            print("set header's post")
            authorLabel.text = post.author.username
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "PostTableViewHeaderView", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }

}

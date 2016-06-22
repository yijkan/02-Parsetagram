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
    var post:Post! {
        didSet {
            print("set header's post")
            let authorName = UILabel()
            authorName.text = post.author.username
            self.addSubview(authorName)
        }
    }

}

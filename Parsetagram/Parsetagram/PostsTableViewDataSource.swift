//
//  PostsTableViewDataSource.swift
//  Parsetagram
//
//  Created by Yijin Kang on 6/21/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit
import Parse

class PostsTableViewDataSource {
    class func headerView(tableView: UITableView, section: Int, posts: [PFObject]!) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("header") as! PostTableViewHeader
        let post = Post.PFObject2Post(posts[section])
        //        headerView.addConstraints([
        //            NSLayoutConstraint(
        //                item: headerView,
        //                attribute: .Leading,
        //                relatedBy: .Equal,
        //                toItem: headerView,
        //                attribute: .Leading,
        //                multiplier: 1.0,
        //                constant: 0),
        //            NSLayoutConstraint(
        //                item: headerView,
        //                attribute: .Trailing,
        //                relatedBy: .Equal,
        //                toItem: headerView,
        //                attribute: .Trailing,
        //                multiplier: 1.0,
        //                constant: 0)
        //
        //            ])
        // headerView.backgroundColor
        let authorLabel = UILabel()
        authorLabel.text = post.author.username
        headerView.addSubview(authorLabel)
        
        return headerView
    }
    
    class func cellForIndexPath(tableView: UITableView, indexPath: NSIndexPath, posts: [PFObject]!) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("post", forIndexPath: indexPath) as! PostTableViewCell
        cell.post = Post.PFObject2Post(posts[indexPath.section])
        return cell
    }
}

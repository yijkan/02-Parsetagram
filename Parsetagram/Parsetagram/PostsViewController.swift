//
//  PostsViewController.swift
//  Parsetagram
//
//  Created by Yijin Kang on 6/20/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit
import Parse

class PostsViewController: UIViewController {
    
    var posts:[PFObject]!
    @IBOutlet weak var postsTableView: UITableView!
    
    func queryPosts() {
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.includeKey("username")
        query.limit = 20
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("no errors querying")
                if let objects = objects {
                    print("retrieved posts")
                    self.posts = objects
                    self.postsTableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        postsTableView.dataSource = self
        postsTableView.delegate = self
        postsTableView.registerClass(PostTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "header")

        
        queryPosts()
    }

}

extension PostsViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let posts = posts {
            return min(posts.count, 20)
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("header") as! PostTableViewHeader
        headerView.post = Post.PFObject2Post(posts[section])
        return headerView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("post", forIndexPath: indexPath) as! PostTableViewCell
        cell.post = Post.PFObject2Post(posts[indexPath.row])
        return cell
    }
}

extension PostsViewController : UITableViewDelegate {
    
}
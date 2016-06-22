//
//  PostsViewController.swift
//  Parsetagram
//
//  Created by Yijin Kang on 6/20/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit
import Parse

class PostsViewController: UIViewController, UIScrollViewDelegate {
    
    var posts:[PFObject]!
    @IBOutlet weak var postsTableView: UITableView!
    var refreshControl:UIRefreshControl!
    var loadCount = 1
    var isLoadingMore:Bool = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    func queryPosts() {
        print("querying")
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.includeKey("username")
        query.limit = 2 * loadCount // TODO change this back
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                if let objects = objects {
                    self.posts = objects
                    self.postsTableView.reloadData()
                }
            }
        }
        self.refreshControl.endRefreshing()
        isLoadingMore = false
        self.loadingMoreView!.stopAnimating()
    }
    
    override func viewDidLoad() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        postsTableView.insertSubview(refreshControl, atIndex: 0)
        
        postsTableView.dataSource = self
        postsTableView.delegate = self
        postsTableView.registerClass(PostTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "header")
        // TODO this breaks everything Dx (don't display correctly)
//        postsTableView.estimatedRowHeight = 100
//        postsTableView.rowHeight = UITableViewAutomaticDimension
        
        let frame = CGRectMake(0, postsTableView.contentSize.height, postsTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        postsTableView.addSubview(loadingMoreView!)
        
        var insets = postsTableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        postsTableView.contentInset = insets
        
        queryPosts()
    }
    
    func refreshAction(refreshControl: UIRefreshControl) {
        loadCount = 1
        queryPosts()
    }

    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isLoadingMore) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = postsTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - postsTableView.bounds.size.height
            
            if (scrollView.contentOffset.y > scrollOffsetThreshold && postsTableView.dragging) {
                isLoadingMore = true
            
                let frame = CGRectMake(0, postsTableView.contentSize.height, postsTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // TODO Code to load more results ...
                loadCount += 1
                queryPosts()
            }
            
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "postDetails" {
            if let cell = sender as? PostTableViewCell {
                let indexPath = postsTableView.indexPathForCell(cell)
                let vc = segue.destinationViewController as! PostDetailsViewController
                vc.post = Post.PFObject2Post(posts[indexPath!.section])
            }
            
        }
    }
}

extension PostsViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let posts = posts {
            return posts.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("header") as! PostTableViewHeader
        var post = Post.PFObject2Post(posts[section])
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
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("post", forIndexPath: indexPath) as! PostTableViewCell
        cell.post = Post.PFObject2Post(posts[indexPath.section])
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
}

extension PostsViewController : UITableViewDelegate {
    
}


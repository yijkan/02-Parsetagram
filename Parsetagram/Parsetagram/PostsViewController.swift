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
        let postsResult = utilQuery(loadCount, completion: { () in
            self.refreshControl.endRefreshing()
            self.isLoadingMore = false
            self.loadingMoreView!.stopAnimating()
        })
        
        if postsResult != nil {
            self.postsTableView.reloadData()
        }
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

    
    /***** For Infinite Scroll *****/
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
        if segue.identifier == "postDetails" { // view post details
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
        return PostsTableViewDataSource.headerView(tableView, section: section, posts: posts)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return PostsTableViewDataSource.cellForIndexPath(tableView, indexPath: indexPath, posts: posts)
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
}

extension PostsViewController : UITableViewDelegate {
    
}


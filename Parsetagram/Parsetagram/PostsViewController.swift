//
//  PostsViewController.swift
//  Parsetagram
//
//  Created by Yijin Kang on 6/20/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit
import MBProgressHUD
import Parse

class PostsViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var networkErrorView: UIView!
    
    var posts:[PFObject] = []
    @IBOutlet weak var postsTableView: UITableView!
    var refreshControl:UIRefreshControl!
    var loadCount = 0
    var isLoadingMore:Bool = false
    var loadingMoreView:InfiniteScrollActivityView?
    

    
    func queryPosts(useHUD:Bool) {
        if useHUD {
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        }
        utilQuery(loadCount, loadAll: true, success: { (posts:[PFObject]) in
            fadeOut(self.networkErrorView)
            self.posts = self.posts + posts
            self.postsTableView.reloadData()
        }, failure: { () in
            fadeIn(self.networkErrorView)
        }, completion: { () in
            if useHUD {
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
            self.refreshControl.endRefreshing()
            self.isLoadingMore = false
            self.loadingMoreView!.stopAnimating()
        })
        
    }
    
    override func viewDidLoad() {        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        postsTableView.insertSubview(refreshControl, atIndex: 0)
        
        postsTableView.dataSource = self
        postsTableView.delegate = self
        
        let headerNib = UINib(nibName: "PostTableViewHeader", bundle: nil)
        
        postsTableView.registerNib(headerNib, forHeaderFooterViewReuseIdentifier: "header")
        postsTableView.registerClass(PostTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "header")
        
        postsTableView.estimatedRowHeight = 200
        postsTableView.rowHeight = UITableViewAutomaticDimension
        
        /***** For Infinite Scroll *****/
        let frame = CGRectMake(0, postsTableView.contentSize.height, postsTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        postsTableView.addSubview(loadingMoreView!)
        
        var insets = postsTableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        postsTableView.contentInset = insets
        
        queryPosts(true)
    }
    
    func refreshAction(refreshControl: UIRefreshControl) {
        loadCount = 0
        queryPosts(false)
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
                
                loadCount += 1
                queryPosts(false)
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
                vc.imageViewWidth = view.frame.size.width - 40.0
            }
            
        }
    }
}

extension PostsViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("header") as! PostTableViewHeader
        let post = Post.PFObject2Post(posts[section])
        headerView.authorLabel.text = post.author.username
        return headerView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("post", forIndexPath: indexPath) as! PostTableViewCell
        cell.imageViewWidth = view.frame.size.width - 40.0
        cell.post = Post.PFObject2Post(posts[indexPath.section])
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension PostsViewController : UITableViewDelegate {
    
}


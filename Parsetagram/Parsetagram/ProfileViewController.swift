//
//  ProfileViewController.swift
//  Parsetagram
//
//  Created by Yijin Kang on 6/20/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class ProfileViewController: UIViewController, UIScrollViewDelegate {
    
    var posts:[PFObject]!
    @IBOutlet weak var postsTableView: UITableView!
    var refreshControl:UIRefreshControl!
    var loadCount = 1
    var isLoadingMore:Bool = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        postsTableView.dataSource = self
        postsTableView.delegate = self

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        postsTableView.insertSubview(refreshControl, atIndex: 0)

        postsTableView.estimatedRowHeight = 200
        postsTableView.rowHeight = UITableViewAutomaticDimension

        /***** For Infinite Scroll Indicator *****/
        let frame = CGRectMake(0, postsTableView.contentSize.height, postsTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        postsTableView.addSubview(loadingMoreView!)
        
        var insets = postsTableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        postsTableView.contentInset = insets
        
        queryPosts()
    }

    @IBAction func tappedLogout(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        performSegueWithIdentifier("logout", sender: sender)
    }
    
    func queryPosts() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        utilQuery(loadCount, loadAll: false, success: { (posts:[PFObject]) in
            self.posts = posts
            self.postsTableView.reloadData()
        }, completion: { () in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.refreshControl.endRefreshing()
            self.isLoadingMore = false
            self.loadingMoreView!.stopAnimating()
        })
        
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
                
                // loading indicator
                let frame = CGRectMake(0, postsTableView.contentSize.height, postsTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                loadCount += 1
                queryPosts()
            }
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logout" {
//            (segue as! CustomSegue).animationType = .SwipeDown
            let vc = segue.destinationViewController as! LoginViewController
            vc.presentedAsModal = true
        }
    }
    
}

extension ProfileViewController : UITableViewDataSource {    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let posts = posts {
            return posts.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("post", forIndexPath: indexPath) as! PostTableViewCell
        cell.post = Post.PFObject2Post(posts[indexPath.row])
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension ProfileViewController : UITableViewDelegate {
    
}


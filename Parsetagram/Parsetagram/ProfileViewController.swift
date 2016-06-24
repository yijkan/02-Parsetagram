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
    
    var oldUser:PFUser!
    var posts:[PFObject] = []
    @IBOutlet weak var postsTableView: UITableView!
    var refreshControl:UIRefreshControl!
    var loadCount = 0
    var isLoadingMore:Bool = false
    var loadingMoreView:InfiniteScrollActivityView?
    @IBOutlet weak var networkErrorView:UIView!
    
    override func viewDidLoad() {
        oldUser = PFUser.currentUser()
        self.navigationItem.title = oldUser.username
        
        postsTableView.dataSource = self
        postsTableView.delegate = self

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        // ??? this would look nice but there's a white gap
//        refreshControl.backgroundColor = bgColor     
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
        
        queryPosts(true)
    }

    override func viewWillAppear(animated:Bool) {
        if PFUser.currentUser() != oldUser { // new user has logged in 
            self.navigationItem.title = PFUser.currentUser()!.username
            queryPosts(true)
            oldUser = PFUser.currentUser()
        }
    }
    
    @IBAction func tappedLogout(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
        performSegueWithIdentifier("logout", sender: sender)
    }
    
    func queryPosts(useHUD:Bool) {
        if useHUD {
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        }
        utilQuery(loadCount, loadAll: false, success: { (posts:[PFObject]) in
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
                
                // loading indicator
                let frame = CGRectMake(0, postsTableView.contentSize.height, postsTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                loadCount += 1
                queryPosts(false)
            }
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logout" {
//            (segue as! CustomSegue).animationType = .SwipeDown
            let vc = segue.destinationViewController as! LoginViewController
            vc.presentedAsModal = true
        } else if segue.identifier == "details" {
            if let cell = sender as? PostTableViewCell {
                let indexPath = postsTableView.indexPathForCell(cell)
                let vc = segue.destinationViewController as! PostDetailsViewController
                vc.post = Post.PFObject2Post(posts[indexPath!.section])
                vc.imageViewWidth = view.frame.size.width - 40.0
            }
        }
    }
    
}

extension ProfileViewController : UITableViewDataSource {    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("post", forIndexPath: indexPath) as! PostTableViewCell
        cell.imageViewWidth = view.frame.size.width - 40.0
        cell.post = Post.PFObject2Post(posts[indexPath.row])
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension ProfileViewController : UITableViewDelegate {
    
}


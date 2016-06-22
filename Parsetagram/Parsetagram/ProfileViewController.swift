//
//  ProfileViewController.swift
//  Parsetagram
//
//  Created by Yijin Kang on 6/20/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {
    
    var posts:[PFObject]!
    var loadCount = 1
    var isLoadingMore = false
    var refreshControl:UIRefreshControl!
    
    @IBOutlet weak var postsTableView: UITableView!
    
    override func viewDidLoad() {
        postsTableView.dataSource = self
        postsTableView.registerClass(PostTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "header")

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        postsTableView.insertSubview(refreshControl, atIndex: 0)
        
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
        let postsResult = utilQuery(loadCount, completion: { () in
            self.refreshControl.endRefreshing()
            self.isLoadingMore = false
            // for infinite scroll
//            self.loadingMoreView!.stopAnimating()
        })
        if postsResult != nil{
            self.postsTableView.reloadData()
        } else {
            
        }
    }
    
    func refreshAction(refreshControl: UIRefreshControl) {
        loadCount = 1
        queryPosts()
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
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return posts.count
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
}



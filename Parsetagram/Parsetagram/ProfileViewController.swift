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
    var isLoadingMore:Bool = false
    var loadingMoreView:InfiniteScrollActivityView?
    var refreshControl:UIRefreshControl!
    
    @IBOutlet weak var postsTableView: UITableView!
    
    override func viewDidLoad() {
        postsTableView.dataSource = self

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
        utilQuery(loadCount, loadAll: false, success: { (posts:[PFObject]) in
            self.posts = posts
            self.postsTableView.reloadData()
        })
        
        self.refreshControl.endRefreshing()
        // TODO for infinite scroll
        //                    self.isLoadingMore = false
        //                    self.loadingMoreView!.stopAnimating()
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



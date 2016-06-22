//
//  util.swift
//  Parsetagram
//
//  Created by Yijin Kang on 6/21/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit
import Parse

func utilQuery(loadCount: Int, loadAll: Bool, success: ([PFObject]) -> Void) {
    var query:PFQuery!
    
    // TODO not working. could filter the array after loading but that sounds like a bad idea
    if !loadAll {
        let predicate = NSPredicate(format:"author.username = %@", PFUser.currentUser()!.username!)
        query = PFQuery(className: "Post", predicate: predicate)
    } else {
        query = PFQuery(className: "Post")
    }
    
    query.orderByDescending("createdAt")
    query.includeKey("author")
    query.includeKey("username")
    // query.skip = 10 is also possible. look up if you can append the array
    query.limit = 2 * loadCount // TODO change this back
    query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) in
        if let error = error {
            print("Error: \(error.localizedDescription)")
        } else {
            if let posts = objects {
                success(posts)
            }
        }
    }
}
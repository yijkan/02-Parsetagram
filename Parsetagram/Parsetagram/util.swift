//
//  util.swift
//  Parsetagram
//
//  Created by Yijin Kang on 6/21/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit
import Parse

func utilQuery(loadCount: Int, loadAll: Bool, success: ([PFObject]) -> Void, completion: () -> Void) {
    var query:PFQuery!
    
    if !loadAll {
        let predicate = NSPredicate(format:"author = %@", PFUser.currentUser()!)
        query = PFQuery(className: "Post", predicate: predicate)
    } else {
        query = PFQuery(className: "Post")
    }
    
    query.orderByDescending("createdAt")
    query.includeKey("author")
    query.includeKey("username")
    // query.skip = 10 is also possible. look up if you can append the array
    query.limit = 2 * loadCount // !!! change this back to 20 
    query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) in
        completion()
        
        if let error = error {
            print("Error: \(error.localizedDescription)")
        } else {
            if let posts = objects {
                success(posts)
            }
        }
    }
}


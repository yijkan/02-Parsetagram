//
//  util.swift
//  Parsetagram
//
//  Created by Yijin Kang on 6/21/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit
import Parse

func utilQuery(loadCount: Int, completion: () -> Void) -> [PFObject]? {
    var posts: [PFObject]!
    let query = PFQuery(className: "Post")
    query.orderByDescending("createdAt")
    query.includeKey("author")
    query.includeKey("username")
    query.limit = 2 * loadCount // TODO change this back
    query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) in
        if let error = error {
            print("Error: \(error.localizedDescription)")
            posts = nil
        } else {
            posts = objects
        }
    }
    completion()
    return posts
}

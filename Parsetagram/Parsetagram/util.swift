//
//  util.swift
//  Parsetagram
//
//  Created by Yijin Kang on 6/21/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit
import Parse

// this function is copied from https://coderwall.com/p/6rfitq/ios-ui-colors-with-hex-values-in-swfit
func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
    let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
    let blue = CGFloat(rgbValue & 0xFF)/256.0
    
    return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
}

let blackColor = UIColor.blackColor()
let whiteColor = UIColor.whiteColor()
let bgColor:UIColor! = UIColorFromHex(0xeee9d8)
let tintColor:UIColor! = UIColorFromHex(0x953800)

func utilQuery(loadCount: Int, loadAll: Bool, success: ([PFObject]) -> Void, failure: () -> Void,completion: () -> Void) {
    var query:PFQuery!
    
    let loadNum:Int = 20
    
    if !loadAll {
        let predicate = NSPredicate(format:"author = %@", PFUser.currentUser()!)
        query = PFQuery(className: "Post", predicate: predicate)
    } else {
        query = PFQuery(className: "Post")
    }
    
    query.orderByDescending("createdAt")
    query.includeKey("author")
    query.includeKey("username")
    query.skip = loadNum * loadCount
    query.limit = loadNum
    query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) in
        if let error = error {
            print("Error: \(error.localizedDescription)")
            failure()
        } else {
            if let posts = objects {
                success(posts)
            } else {
                print("Error: nothing loaded")
            }
        }
        
        completion()
    }
}

func fadeIn(view:UIView) {
    view.alpha = 0.0
    UIView.animateWithDuration(0.3, animations: { () in
        view.alpha = 0.75
    })
}

func fadeOut(view:UIView) {
    if view.alpha > 0.0 {
        UIView.animateWithDuration(0.3, animations: { () in
            view.alpha = 0.0
        })
    }
}


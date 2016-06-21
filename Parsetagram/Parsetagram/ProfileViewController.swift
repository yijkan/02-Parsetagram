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

    @IBAction func tappedLogout(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
            // PFUser.currentUser() will now be nil
        }
        performSegueWithIdentifier("logout", sender: sender)
        
        // TODO crashes and still shows tab bar :c
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logout" {
//            (segue as! CustomSegue).animationType = .SwipeDown
            let vc = segue.destinationViewController as! LoginViewController
            vc.presentedAsModal = true
        }
    }
}

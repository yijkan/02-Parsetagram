//
//  LoginViewController.swift
//  Parsetagram
//
//  Created by Yijin Kang on 6/20/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    var presentedAsModal: Bool = false
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    @IBAction func didTapSignIn(sender: AnyObject) {
        let username = usernameLabel.text ?? ""
        let password = passwordLabel.text ?? ""
        
        PFUser.logInWithUsernameInBackground(username, password: password) { (user:PFUser?, error:NSError?) -> Void in
            if let error = error {
                print("User login failed.")
                print(error.localizedDescription)
            } else {
                print("User logged in successfully")
                if self.presentedAsModal {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    self.performSegueWithIdentifier("login", sender: sender)
                }

            }
        }
        
    }

    @IBAction func didTapSignUp(sender: AnyObject) {
        let newUser = PFUser()
        
        newUser.username = usernameLabel.text
        newUser.password = passwordLabel.text
        
        print("tapped signup")
        
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if let error = error {
                print(error.localizedDescription)
                if error.code == 202 {
                    // TODO username is taken
                }
            } else {
                print("User Registered successfully")
                // manually segue to logged in view
//                self.dismissViewControllerAnimated(true, completion: nil)
                self.performSegueWithIdentifier("login", sender: sender)
            }
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue is CustomSegue {
            (segue as! CustomSegue).animationType = .SwipeDown
        }
    }
    
//    func segueForUnwindingToViewController(toViewController: UIViewController,
//                                           fromViewController: UIViewController, identifier: String) -> UIStoryboardSegue {
//        let segue = CustomUnwindSegue(identifier: identifier, source: fromViewController, destination: toViewController)
//        segue.animationType = .SwipeDown
//        return segue
//    }
}

//
//  LoginViewController.swift
//  Parsetagram
//
//  Created by Yijin Kang on 6/20/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit
import MBProgressHUD
import Parse

class LoginViewController: UIViewController {

    var presentedAsModal: Bool = false
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var signUpBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo
        let keyboardFrame = userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
        let keyboardHeight = keyboardFrame!.size.height
        
        signUpBottomConstraint.constant = keyboardHeight + 20
        view.layoutIfNeeded()
    }
    
    func keyboardWillHide(notification: NSNotification) {
        signUpBottomConstraint.constant = 100
        
        view.layoutIfNeeded()
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func didTapSignIn(sender: AnyObject) {
        view.endEditing(true)
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let username = usernameLabel.text ?? ""
        let password = passwordLabel.text ?? ""
        
        PFUser.logInWithUsernameInBackground(username, password: password) { (user:PFUser?, error:NSError?) -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            if let error = error {
                print("User login failed with error \(error.localizedDescription)")
                //TODO handle errors
            } else {
                if self.presentedAsModal {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    self.performSegueWithIdentifier("login", sender: sender)
                }

            }
        }
        
    }

    @IBAction func didTapSignUp(sender: AnyObject) {
        view.endEditing(true)
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let newUser = PFUser()
        
        newUser.username = usernameLabel.text
        newUser.password = passwordLabel.text
        
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            if let error = error {
                print(error.localizedDescription)
                if error.code == 202 {
                    // TODO username is taken
                }
            } else {
                // ??? maybe change segue
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
    
}
//
//  AddCaptionViewController.swift
//  Parsetagram
//
//  Created by Yijin Kang on 6/21/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit
import MBProgressHUD

class AddCaptionViewController: UIViewController, UITextViewDelegate {
    /*** we get the image that the user selected in NewViewController ***/
    var selectedImage: UIImage!
    
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var captionText: UITextView!
    var captionPlaceholderText: String! = "Add a caption"
    
    @IBOutlet weak var captionTextBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedImageView.clipsToBounds = true // don't let image show beyond imageView
        selectedImageView.contentMode = .ScaleAspectFit // fit the image in the imageView
        selectedImageView.image = selectedImage // set the image we got
        
        captionText.delegate = self
        captionText.textColor = UIColor.lightGrayColor()
        captionText.text = captionPlaceholderText
        captionText.layer.cornerRadius = 5
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(onKeyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(onKeyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /*** to adjust autolayout constraints as keyboard shows/hides ***/
    func onKeyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo
        let keyboardFrame = userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
        let keyboardHeight = keyboardFrame!.size.height
        
        let tabViewController = UITabBarController()
        let tabBarHeight = tabViewController.tabBar.frame.size.height
        
        captionTextBottomConstraint.constant = keyboardHeight - tabBarHeight + 8
        view.layoutIfNeeded()
    }
    
    func onKeyboardWillHide(notification: NSNotification) {
        captionTextBottomConstraint.constant = 8
        view.layoutIfNeeded()
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    /*** fakes placeholder text for the textView ***/
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty || textView.text == "" {
            textView.textColor = UIColor.lightGrayColor()
            captionText.text = captionPlaceholderText
        }
    }
    
    @IBAction func tappedPostButton(sender: AnyObject) {
        view.endEditing(true)
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        var caption:String?
        if captionText.textColor == UIColor.lightGrayColor() {
            caption = nil
        } else {
            caption = captionText.text
        }
        
        /*** post the image and segue to homepage ***/
        Post.postImage(selectedImage, withCaption: caption) { (success: Bool, error: NSError?) in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                self.performSegueWithIdentifier("posted", sender: sender)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "posted" {
            (segue as! CustomSegue).animationType = .SwipeDown
        }
    }
    
    
}

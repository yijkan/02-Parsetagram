//
//  AddCaptionViewController.swift
//  Parsetagram
//
//  Created by Yijin Kang on 6/21/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit
import MBProgressHUD

class AddCaptionViewController: UIViewController {

    var selectedImage: UIImage!
    
    @IBOutlet weak var selectedImageView: UIImageView!
    
    @IBOutlet weak var captionField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedImageView.clipsToBounds = true
        selectedImageView.contentMode = .ScaleAspectFit
        selectedImageView.image = selectedImage
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    @IBAction func tappedPostButton(sender: AnyObject) {
        view.endEditing(true)
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        Post.postImage(selectedImage, withCaption: captionField.text) { (success: Bool, error: NSError?) in
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

//
//  AddCaptionViewController.swift
//  Parsetagram
//
//  Created by Yijin Kang on 6/21/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit

class AddCaptionViewController: UIViewController {

    var selectedImage: UIImage!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    @IBOutlet weak var captionField: UITextField!
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        selectedImageView.image = selectedImage
        selectedImageView.contentMode = .Redraw
        
    }
    
    @IBAction func tappedPostButton(sender: AnyObject) {
        
        Post.postImage(selectedImage, withCaption: captionField.text) { (success: Bool, error: NSError?) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("successfully posted image")
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

//
//  NewViewController.swift
//  Parsetagram
//
//  Created by Yijin Kang on 6/20/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit
import Parse

class NewViewController: UIViewController {
    
    var selectedImage:UIImage!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var rollView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraView.layer.cornerRadius = 5
        cameraView.layer.borderColor = UIColor.darkGrayColor().CGColor
        cameraView.layer.borderWidth = 1
        
        rollView.layer.cornerRadius = 5
        rollView.layer.borderColor = UIColor.darkGrayColor().CGColor
        rollView.layer.borderWidth = 1
    }

    @IBAction func tappedCameraButton(sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true // !!! if allowing editing
        vc.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func tappedCameraRollButton(sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true // !!! if allowing editing
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    // Post.postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?)
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "selectedImage" {
            let vc = segue.destinationViewController as! AddCaptionViewController
            vc.selectedImage = selectedImage
        }
    }
}

extension NewViewController : UINavigationControllerDelegate {

}

extension NewViewController : UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage //!!! if allowing editing
        
        // Do something with the images (based on your use case)
        selectedImage = editedImage //!!! if allowing editing
//        selectedImage = originalImage //!!! if not allowing editing
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: {
            self.performSegueWithIdentifier("selectedImage", sender: nil)
        })
    }
    
    /* UIImagePickerControllerDelegate
     @available(iOS 2.0, *)
     optional public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
     @available(iOS 2.0, *)
     optional public func imagePickerControllerDidCancel(picker: UIImagePickerController)
     */
}
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tappedCameraButton(sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func tappedCameraRollButton(sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    // Post.postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?)
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "selectedImage" {
            let vc = segue.destinationViewController as! AddCaptionViewController
            vc.selectedImage = sender as! UIImage
        }
    }
}

extension NewViewController : UINavigationControllerDelegate {
    /* UINavigationControllerDelegate
     
     @available(iOS 2.0, *)
     optional public func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool)
     @available(iOS 2.0, *)
     optional public func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool)
     
     @available(iOS 7.0, *)
     optional public func navigationControllerSupportedInterfaceOrientations(navigationController: UINavigationController) -> UIInterfaceOrientationMask
     @available(iOS 7.0, *)
     optional public func navigationControllerPreferredInterfaceOrientationForPresentation(navigationController: UINavigationController) -> UIInterfaceOrientation
     
     @available(iOS 7.0, *)
     optional public func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
     
     @available(iOS 7.0, *)
     optional public func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
     */
}

extension NewViewController : UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        selectedImage = editedImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: {
            self.performSegueWithIdentifier("selectedImage", sender: editedImage)
        })
    }
    
    /* UIImagePickerControllerDelegate
     @available(iOS 2.0, *)
     optional public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
     @available(iOS 2.0, *)
     optional public func imagePickerControllerDidCancel(picker: UIImagePickerController)
     */
}
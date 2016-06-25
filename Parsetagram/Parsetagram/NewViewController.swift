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
    
    // string constants
    let selectedImageSegue = "selectedImage"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraView.layer.cornerRadius = 5
        cameraView.layer.borderColor = UIColor.darkGrayColor().CGColor
        cameraView.layer.borderWidth = 1
        
        rollView.layer.cornerRadius = 5
        rollView.layer.borderColor = UIColor.darkGrayColor().CGColor
        rollView.layer.borderWidth = 1
    }

    /*** open camera ***/
    @IBAction func tappedCameraButton(sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true // !!! if allowing editing
        vc.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    /*** open camera roll ***/
    @IBAction func tappedCameraRollButton(sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true // !!! if allowing editing
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == selectedImageSegue { // once we've selected an image, pass it to AddCaption
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
        /*** Get the image captured by the UIImagePickerController ***/
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage //!!! if allowing editing
        
        /*** save the image we want ***/
        selectedImage = editedImage //!!! if allowing editing
//        selectedImage = originalImage //!!! if not allowing editing
        
        /*** dismiss UIImagePickerController and segue to AddCaption ***/
        dismissViewControllerAnimated(true, completion: {
            self.performSegueWithIdentifier(self.selectedImageSegue, sender: nil)
        })
    }
}
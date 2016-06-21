//
//  Post.swift
//  Parsetagram
//
//  Created by Yijin Kang on 6/20/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit
import AFNetworking
import Parse

class Post: NSObject {
    var image: PFFile!
    var cap: String?
    var author: PFUser!
    
    init(image: PFFile, cap: String?, author: PFUser) {
        self.image = image
        self.cap = cap
        self.author = author
    }
    
    class func resizeImage(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
    class func postImage(image: UIImage?, withCaption caption: String?,
                         withCompletion completion:PFBooleanResultBlock?) {
//        let image = resizeImage(image!, newSize: CGSize(width:100, height:100)) // TODO
        // Create Parse object PFObject
        let post = PFObject(className: "Post")
        
        // Add relevant fields to the object
        post["media"] = getPFFileFromImage(image) // PFFile column type
        post["author"] = PFUser.currentUser() // Pointer column type that points to PFUser
        post["caption"] = caption
        post["likesCount"] = 0
        post["commentsCount"] = 0
        
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackgroundWithBlock(completion)
    }
    
    class func PFObject2Post(object: PFObject) -> Post {
        let image = object["media"] as! PFFile
        let cap = object["caption"] as? String
        let author = object["author"] as! PFUser
        
        return Post(image: image, cap: cap, author: author)
    }
    
}

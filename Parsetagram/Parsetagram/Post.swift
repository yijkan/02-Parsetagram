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
import ParseUI

class Post: NSObject {
    var id:String!
    var image: PFFile!
    var timestamp: String!
    var cap: String?
    var author: PFUser!
    var heightToWidth: CGFloat?
    
    init(id: String, image: PFFile, cap: String?, author: PFUser) {
        self.id = id
        self.image = image
        self.timestamp = "timestamp"
        self.cap = cap
        self.author = author
    }
    
    init(id: String, image: PFFile, timestamp:String, cap: String?, author: PFUser) {
        self.id = id
        self.image = image
        self.timestamp = timestamp
        self.cap = cap
        self.author = author
    }
    
    init(id: String, image: PFFile, timestamp:String, cap: String?, author: PFUser, heightToWidth ratio: CGFloat?) {
        self.id = id
        self.image = image
        self.timestamp = timestamp
        self.cap = cap
        self.author = author
        self.heightToWidth = ratio
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
        // ??? If I want to resize the image
//        let image = resizeImage(image!, newSize: CGSize(width:100, height:100))         
        
        // Create Parse object PFObject
        let post = PFObject(className: "Post")
        
        // Add relevant fields to the object
        post["media"] = getPFFileFromImage(image) // PFFile column type
        post["author"] = PFUser.currentUser() // Pointer column type that points to PFUser
        post["caption"] = caption
        post["ratio"] = image!.size.height / image!.size.width
        post["likesCount"] = 0
        post["commentsCount"] = 0
        
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackgroundWithBlock(completion)
    }
    
    class func PFObject2Post(object: PFObject) -> Post {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        let timeFormatter = NSDateFormatter()
        timeFormatter.timeStyle = .ShortStyle
        
        let id = object.objectId
        let image = object["media"] as! PFFile
        let date = object.createdAt
        let timestamp = dateFormatter.stringFromDate(date!) + " at " + timeFormatter.stringFromDate(date!)
        let cap = object["caption"] as? String
        let author = object["author"] as! PFUser
        let ratio = object["ratio"] as? CGFloat
        
        if let ratio = ratio {
            return Post(id: id!, image: image, timestamp: timestamp, cap: cap, author: author, heightToWidth: ratio)
        } else {
            return Post(id: id!, image: image, timestamp: timestamp, cap: cap, author: author)
        }
    }
}

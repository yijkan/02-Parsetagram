//
//  PostTableViewHeader.swift
//  Parsetagram
//
//  Created by Yijin Kang on 6/21/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit
import Parse

/*** Not sure how to get this working, so it's just here for now ***/
class PostTableViewHeader : UITableViewHeaderFooterView {
   
    @IBOutlet var headerContentView: UIView!
    @IBOutlet weak var authorLabel: UILabel!
        
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "PostTableViewHeader", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }

}

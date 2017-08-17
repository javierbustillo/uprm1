//
//  Post.swift
//  uprm1
//
//  Created by Javier Bustillo on 8/17/17.
//  Copyright © 2017 Javier Bustillo. All rights reserved.
//

import UIKit
import Parse

class Post: NSObject {
    
    var post: String?
    var steps: Int?
    
    init(post: String, steps: Int){
        self.post = post
        self.steps = 0
    }
    
    func poster(){
        let post = PFObject(className: "Post")
        
        post.setObject(self.post!, forKey: "post")
        post.setObject(steps!, forKey: "steps")
        
        post.saveInBackground { (success: Bool, error: Error?) in
            if(success){
                print("posted!")
            }
            else{
                print("failure")
            }
        }
    
    }
    

}

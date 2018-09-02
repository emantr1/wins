//
//  Features.swift
//  Wins
//
//  Created by Eman I on 5/29/16.
//  Copyright © 2016 Eman. All rights reserved.
//

import UIKit
import Parse

class Feature {
    
    //Mark Public API
    var title = ""
    var description = ""
    var numberOfMembers = 0
    var numberOfPosts = 0
    var featuredImage: UIImage!
    
    
    init (title: String, description: String, featuredImage: UIImage!) {
        self.title = title
        self.description = description
        self.featuredImage = featuredImage
        numberOfMembers = 1
        numberOfPosts = 1
    }
    
    static func createFeatures() -> [Feature] {
        print("the global array count \(globalfeatureArray.count)")
        return globalfeatureArray
//        return [
//            Feature(title:"title 1", description: "stuff that goes into number 1", featuredImage: UIImage(named:"Smiling.jpg")!),
//            Feature(title:"title 2", description: "stuff that goes into number 2", featuredImage: UIImage(named:"Cool.jpg")!),
//            Feature(title:"title 3", description: "stuff that goes into number 3", featuredImage: UIImage(named:"Fire.jpg")!),
//            Feature(title:"title 4", description: "stuff that goes into number 4", featuredImage: UIImage(named:"Heart.jpg")!),
//            Feature(title:"title 5", description: "stuff that goes into number 5 ", featuredImage: UIImage(named:"getpro.jpg")!),
//
//        ]
    }
}

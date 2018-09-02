//
//  FeaturesCollectionViewCell.swift
//  Wins
//
//  Created by Eman I on 5/29/16.
//  Copyright © 2016 Eman. All rights reserved.
//

import UIKit 

class FeaturesCollectionViewCell: UICollectionViewCell {
    
    
    var feature: Feature! {
        didSet{
            updateUI()
        }
    }
    
    @IBOutlet var featuredImage: UIImageView!
    @IBOutlet var featureText: UILabel!
    

    fileprivate func updateUI() {
        featureText?.text! = feature.description 
        featuredImage?.image! = feature.featuredImage
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
    }
    
}

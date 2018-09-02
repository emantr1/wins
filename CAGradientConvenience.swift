//
//  CAGradientConvenience.swift
//  classified
//
//  Created by Eman I on 4/11/16.
//  Copyright © 2016 Eman
//

import UIKit

extension CAGradientLayer {
    
    //sunrise
    func orangeLayer() -> CAGradientLayer {
        let topColor = UIColor(red: 47/255.0, green: 212/255.0, blue: 192/255.0, alpha: 1.0)
        let bottomColor = UIColor(red: 241/255.0, green: 175/255.0, blue: 65/255.0, alpha: 1.0)
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]?
        
        return gradientLayer

    }
    
    func whiteLayer() -> CAGradientLayer {
        let topColor = UIColor(red: 25/255.0, green: 169/255.0, blue: 255/255.0, alpha: 1.0)
        let bottomColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 0.35]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]?
        
        return gradientLayer
        
    }
    //name it ocean
    func greenLayer() -> CAGradientLayer {
        let topColor = UIColor(red: 25/255.0, green: 169/255.0, blue: 255/255.0, alpha: 1.0)
        let bottomColor = UIColor(red: 126/255.0, green: 255/255.0, blue: 242/255.0, alpha: 1.0)
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 0.7]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]?
        
        return gradientLayer
        
    }

    func blueLayer() -> CAGradientLayer {
        let topColor = UIColor(red: 25/255.0, green: 169/255.0, blue: 255/255.0, alpha: 1.0)
        let bottomColor = UIColor(red: 126/255.0, green: 255/255.0, blue: 242/255.0, alpha: 1.0)
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]?
        
        return gradientLayer
        
    }
    //sunset
    func redLayer() -> CAGradientLayer {
        let topColor = UIColor(red: 47/255.0, green: 212/255.0, blue: 192/255.0, alpha: 1.0)
        let bottomColor = UIColor(red: 236/255.0, green: 100/255.0, blue: 92/255.0, alpha: 1.0)
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]?
        
        return gradientLayer
        
    }

}

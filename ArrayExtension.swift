//
//  ArrayExtension.swift
//  Wins
//
//  Created by Eman I on 5/1/16.
//  Copyright © 2016 Eman. All rights reserved.
//

import Foundation
import UIKit

extension Array {
    func customSwap<T>(_ a: inout T, b: inout T){
        let temp = a
        a = b
        b = temp
    }
    
    mutating func shuffle () {
        if count < 2 { return }
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            customSwap(&self[i], b: &self[j])
        }
    }
}

//
//  Extensions.swift
//  MoodTracker
//
//  Created by Alex Wayne on 11/6/22.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat){
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: a / 255)
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat){
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: 1)
    }
    
    convenience init(gray: CGFloat){
        self.init(red: gray / 255, green: gray / 255, blue: gray / 255, alpha: 1)
    }
    
    convenience init(gray: CGFloat, alpha: CGFloat){
        self.init(red: gray / 255, green: gray / 255, blue: gray / 255, alpha: alpha / 255)
    }
}

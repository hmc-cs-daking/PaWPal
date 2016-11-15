//
//  UIColor+initWithHex.swift
//  PaWPal
//
//  Created by Tiffany Fong on 11/11/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import Foundation
import UIKit

// This extension allows for UIColors to be initialized with hexadecimal RGB values

extension UIColor {
    
    /*
     *  Usage: 
     *      let red = UIColor(red: 0xFF, green: 0x00, blue: 0x00)
     *      let blue = UIColor(0, 0, 225)
     */
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    /*
     *  Usage:
     *      let red = UIColor(netHex: 0xFF0000)
     */
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    // light orange color used in our PaWPal color scheme
    public class func tangerineColor() -> UIColor {
        return UIColor(netHex: 0xFE9225)
    }
}
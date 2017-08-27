//
//  UIColor+Extension.swift
//  Tripografy
//
//  Created by Gökhan Gültekin on 10/02/16.
//  Copyright © 2016 Peakode. All rights reserved.
//

import Foundation
import UIKit
// asd
extension UIColor {
    
    public class func colorFromHexString(_ hexString: String) -> UIColor {
        
        let colorString = hexString.replacingOccurrences(of: "#", with: "").uppercased()
        
        let alpha, red, blue, green: Float
        alpha = 1.0
        red = self.colorComponentsFrom(colorString as NSString, start: 0, length: 2)
        green = self.colorComponentsFrom(colorString as NSString, start: 2, length: 2)
        blue = self.colorComponentsFrom(colorString as NSString, start: 4, length: 2)
        return UIColor(colorLiteralRed: red, green: green, blue: blue, alpha: alpha)
    }
    
    static func color(red theRed:Int , blue theBlue:Int , green theGreen:Int , alpha theAlpha:CGFloat)->UIColor
    {
        let redComponent:CGFloat = CGFloat(CGFloat(theRed) / 255.00)
        let greenComponent:CGFloat = CGFloat(CGFloat(theGreen) / 255.00)
        let blueComponent:CGFloat = CGFloat(CGFloat(theBlue) / 255.00)
        
        let theColor = UIColor(red: redComponent, green: greenComponent, blue: blueComponent, alpha: CGFloat(theAlpha))
        
        return theColor
    }
    
    
    fileprivate class func colorComponentsFrom(_ string: NSString, start: Int, length: Int) -> Float {
        NSMakeRange(start, length)
        let subString = string.substring(with: NSMakeRange(start, length))
        var hexValue: UInt32 = 0
        Scanner(string: subString).scanHexInt32(&hexValue)
        return Float(hexValue) / 255.0
    }
    /*
     turuncu FD6D47
     kırmızı E64250
     sarı FDB74F
     navigation FDB74F
     */
    
    static func uOrangeColor() -> UIColor {
        return colorFromHexString("#FD6D47")
    }
    
    static func uActiveTextColor() -> UIColor {
        return colorFromHexString("#656565")
    }
    
    static func uYellowColor() -> UIColor {
        return colorFromHexString("#FDB74F")
    }
    
    static func uBlackColor() -> UIColor {
        return colorFromHexString("#2E2E2E")
    }
    
    static func uRedColor() -> UIColor {
        return colorFromHexString("#E64250")
    }
    static func uGreyColor() -> UIColor {
        return colorFromHexString("#E8E8E8")
    }
    
    static func uBlankInput() -> UIColor {
        return colorFromHexString("#FAD8DB")
    }
    
    static func uNavBarGrayColor() -> UIColor {
        return colorFromHexString("#F2F2F2");
    }
    
    static func uNavBarActiveColor() -> UIColor {
        return colorFromHexString("#EAEAEA");
    }
    
    static func uGrayColor() -> UIColor {
        return colorFromHexString("#9B9B9B");
    }
    
    static func uTwitterBlue() -> UIColor {
        return colorFromHexString("70c1fa")
    }
    
    static func uFacebookBlue() -> UIColor {
        return colorFromHexString("0e52f2")
    }
}

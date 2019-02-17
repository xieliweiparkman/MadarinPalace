//
//  AppColorAndFont.swift
//  MadarinPalace
//
//  Created by Xie Liwei on 12/02/2019.
//  Copyright © 2019 Xie Liwei. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func appRedColor() -> UIColor {
        return UIColor(red: 247/255.0, green: 50/255.0, blue: 69/255.0, alpha: 1)
    }
    
    class func appGreenColor() -> UIColor {
        return UIColor(red: 62.0/255.0, green: 187.0/255.0, blue: 0/255.0, alpha: 1)
    }
    class func appBlackColor() -> UIColor {
        return UIColor(red: 31.0/255.0, green: 25.0/255.0, blue: 22/255.0, alpha: 1)
    }
    class func appOrangeColor() -> UIColor {
        return UIColor(red: 236/255.0, green: 191/255.0, blue: 97/255.0, alpha: 1)
    }
    class func appLightBlackColor() -> UIColor {
        return UIColor(red: 48/255.0, green:46.0/255.0, blue: 46.0/255.0, alpha: 1)
    }
    class func appGreyBackgroundColor() -> UIColor {
        return UIColor(red: 238/255.0, green:241.0/255.0, blue: 264.0/255.0, alpha: 1)
    }
    
    class func appLabelGreyColor() -> UIColor {
        return UIColor(red: 68/255.0, green:66.0/255.0, blue: 66.0/255.0, alpha: 1)
    }
}
extension UIFont {
    static func appRegularFont(size: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Regular", size: size)!
    }
    
    static func appMediumFont(size: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Medium", size: size)!
    }
    
    static func appBoldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Bold", size: size)!
    }
    static func appSemiBoldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-SemiBold", size: size)!
    }
    
    static func appLightFont(size: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Light", size: size)!
    }
}

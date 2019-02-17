//
//  Util.swift
//  Ainoya-Tampere
//
//  Created by Xie Liwei on 20/09/2018.
//  Copyright © 2018 Xie Liwei. All rights reserved.
//

import Foundation
import SystemConfiguration

final class AppUtilities {
    static let sharedInstance = AppUtilities()
    
    private init() {}
    //MARK: Validate TextFields
    static func isTextNotEmpty(_ text: String?) -> Bool {
        return text != nil ? !(text!.isEmpty) : false
    }
    
    static func isUsernameValid(_ username: String?) -> Bool {
        let usernameRegEx = "^(?=.{5,30}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$"
        return NSPredicate(format:"SELF MATCHES %@", usernameRegEx).evaluate(with: username)
    }
    
    static func isZipValid(_ zip: String?) -> Bool {
        return zip != nil ? zip!.count == 5 : false
    }
    
    static func isPasswordValid(_ password: String?) -> Bool {
        return password != nil ? password!.count >= 6 : false
    }
    
    static func isNameValid(_ name: String?) -> Bool {
        if name == nil { return false }
        if name == "" { return false }
        let cleanName = name!.trimmingCharacters(in: .whitespacesAndNewlines)
        return cleanName.components(separatedBy: " ").count > 1 ? true : false
    }
    
    static func isPhoneNumberValid(_ number: String?) -> Bool {
        return number != nil ? number!.count == 9 : false
    }
    
    static func isCodeValid(_ code: String?) -> Bool {
        return code != nil ? code!.count == 6 : false
    }
    
    static func isAddressValid(_ address: String?) -> Bool {
        return address != nil ? address! != "" : false
    }
    
    lazy var priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.formatterBehavior = .behavior10_4
        
        return formatter
    }()
    
}


open class Reachability {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
}

//
//  UserDefaultManager.swift
//  Ainoya-Tampere
//
//  Created by Xie Liwei on 20/09/2018.
//  Copyright © 2018 Xie Liwei. All rights reserved.
//

import Foundation
private enum UserDefaultsKey {
    case isLoggedIn
    case name
    case points
    case credits
    case email
    var key: String {
        switch self {
        case .isLoggedIn: return "isLoggedIn"
        case .name: return "name"
        case .points: return "points"
        case .credits: return "credits"
        case .email: return "email"
        }
    }
}

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private init() {}
    
    var isLoggedIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKey.isLoggedIn.key)
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.isLoggedIn.key)
        }
    }
    
    var name: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsKey.name.key) ?? ""
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.name.key)
        }
    }
    var email: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsKey.email.key) ?? ""
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.email.key)
        }
    }
    
    var points: Double {
        get {
            return UserDefaults.standard.double(forKey: UserDefaultsKey.points.key)
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.points.key)
        }
    }
    
    var credits: Double {
        get {
            return UserDefaults.standard.double(forKey: UserDefaultsKey.credits.key)
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.credits.key)
        }
    }
}

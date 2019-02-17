//
//  AppError.swift
//  Ainoya-Tampere
//
//  Created by Xie Liwei on 20/09/2018.
//  Copyright © 2018 Xie Liwei. All rights reserved.
//

import Foundation
import Firebase

enum AppError: Error {
    //General errors
    case networkError
    case unknownError
    //Login, sign up error
    case invalidNumber
    case invalidAddress
    case wrongPassword
    case invalidCode
    case invalidUsername
    case emailAlreadyInUse
    case weakPassword
    case userNotFound
    case invalidPhoneNumber
    case loginWithFBCancelled
    case loginWithFBError
    case usernameAlreadyTaken
    case authenticationFailed
}

extension AppError {
    var description: String {
        switch self {
        case .networkError:
            return "No internet connection"
        case .invalidNumber:
            return "Phone number format is invalid"
        case .wrongPassword:
            return "Wrong password"
        case .invalidUsername:
            return "Full name is required"
        case .invalidPhoneNumber:
            return "Phone number is invalid. Finish number is required!"
        case .invalidCode:
            return "A valid 6-digits code is required."
        case .invalidAddress:
            return "We need your address to deliver for you"
        case .emailAlreadyInUse:
            return "This email has already been taken"
        case .weakPassword:
            return "Passwords must contain at least 6 characters"
        case .userNotFound:
            return "Invalid email and password"
        case .loginWithFBCancelled, .loginWithFBError:
            return ""
        case .usernameAlreadyTaken:
            return "This username has already been taken"
        case .authenticationFailed:
            return "Authentication failed"
        case .unknownError:
            return "An error occurred. Please try again later."
        }
    }
    
    static func parseFirebaseError(_ error: Error) -> AppError {
        if let errorCode = AuthErrorCode(rawValue: (error._code)) {
            switch errorCode {
            case .networkError:
                return AppError.networkError
            case .invalidEmail:
                return AppError.invalidNumber
            case .wrongPassword:
                return AppError.wrongPassword
            case .emailAlreadyInUse:
                return AppError.emailAlreadyInUse
            case .weakPassword:
                return AppError.weakPassword
            case .userNotFound:
                return AppError.userNotFound
            default:
                return AppError.unknownError
            }
        } else {
            return AppError.unknownError
        }
    }
}

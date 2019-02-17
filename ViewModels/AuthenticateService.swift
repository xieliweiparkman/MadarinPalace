//
//  AuthenticateService.swift
//  Ainoya-Tampere
//
//  Created by Xie Liwei on 20/09/2018.
//  Copyright © 2018 Xie Liwei. All rights reserved.
//

import Foundation
import Firebase
import Bond
import ReactiveKit


protocol AuthenticateServiceProtocol {
    func requestFirebaseVerificationIDWithPhoneNumber(number: String) -> Signal<String, AppError>
    func loginToFirebaseWithVerificationIDAndVerificationCode(id: String, code: String)  -> Signal<Void, AppError>
    func logOut() -> Signal<Void, AppError>
    func setLogIn()
    func setLogOut()
}

struct AuthenticateService: AuthenticateServiceProtocol {
    fileprivate var rootRef: DatabaseReference

    init() {
        rootRef = Database.database().reference()
    }
    
    func requestFirebaseVerificationIDWithPhoneNumber(number: String) -> Signal<String, AppError> {
        return Signal { observer in
            let completedNumber = "+358\(number)"
            PhoneAuthProvider.provider().verifyPhoneNumber(completedNumber, uiDelegate: nil, completion: { (verificationID, error) in
                if error != nil {
                    observer.failed(AppError.authenticationFailed)
                    return
                }
                guard let verificationID = verificationID else {
                    observer.failed(AppError.authenticationFailed)
                    return
                }
                observer.next(verificationID)
                observer.completed()
            })
            return BlockDisposable {}
        }
    }
    
    func loginToFirebaseWithVerificationIDAndVerificationCode(id: String, code: String) -> Signal<Void, AppError> {
        return Signal { observer in
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: id, verificationCode: code)
            Auth.auth().signInAndRetrieveData(with: credential, completion: { (result, error) in
                if error != nil {
                    observer.failed(AppError.authenticationFailed)
                    return
                }
                if result?.user != nil {
                    observer.next()
                    observer.completed()
                } else {
                    observer.failed(AppError.unknownError)
                }
            })
            return BlockDisposable {}
        }
    }
    /// Log out
    func logOut() -> Signal<Void, AppError> {
        return Signal { observer in
            do {
                try Auth.auth().signOut()
                observer.next()
                observer.completed()
            } catch {
                observer.failed(.unknownError)
            }
            return BlockDisposable {}
        }
    }
    
    
    //Helper functions
    func setLogIn() {
        UserDefaultsManager.shared.isLoggedIn = true
    }
    
    func setLogOut() {
        UserDefaultsManager.shared.isLoggedIn = false
    }
    
    /// Indicates if user has already logged in
    ///
    /// - Returns: true if user has already logged in
    static func isLoggedIn() -> Bool {
        let user = Auth.auth().currentUser
        let isLoggedIn = UserDefaultsManager.shared.isLoggedIn
        return user != nil && isLoggedIn
    }
}

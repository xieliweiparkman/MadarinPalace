//
//  FirebaseService.swift
//  Ainoya-Tampere
//
//  Created by Xie Liwei on 17/12/2018.
//  Copyright © 2018 Xie Liwei. All rights reserved.
//

import Foundation
import Firebase
import Bond
import ReactiveKit

protocol FirebaseServiceProtocol {
    var userOrdersData: Observable<[String: Any]?> { get }
    func getUserInfo() -> Signal<Void, AppError>
    func setUserPhone(phone: String)
    func setName(name: String)
}

class FirebaseService: FirebaseServiceProtocol {
    fileprivate var userInfoDetailsRef: DatabaseReference!
    fileprivate var userOrdersRef: DatabaseReference!
    let userOrdersData = Observable<[String: Any]?>([:])
    static let shared = FirebaseService()
    
    func getUserInfo() -> Signal<Void, AppError> {
        return Signal { [weak self] observer in
            guard let currentUser = Auth.auth().currentUser else { fatalError("User NOT FOUND") }
            self?.userInfoDetailsRef = Database.database().reference().child("users").child(currentUser.uid)
            self?.userInfoDetailsRef.observe(.value, with: { (snapshot) in
                UserDetailsService.shared.setupUserDetials(userDetails: snapshot.value as? [String: Any])
                observer.next()
                observer.completed()
            })
            return BlockDisposable {}
        }
    }



    func setUserPhone(phone: String) {
        guard let currentUser = Auth.auth().currentUser else { return }
        Database.database().reference().child("users/\(currentUser.uid)/phone").setValue(phone)
    }
    
    func setName(name: String) {
        guard let currentUser = Auth.auth().currentUser else { return }
        Database.database().reference().child("users/\(currentUser.uid)/name").setValue(name)
    }

}

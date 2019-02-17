//
//  User.swift
//  Ainoya-Tampere
//
//  Created by Xie Liwei on 23/09/2018.
//  Copyright © 2018 Xie Liwei. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit

protocol UserDetailsServiceProtocol {
    var name: Observable<String> { get }
    var buffetTimes: Observable<Int> { get }
    var number: Observable<String> { get }
    func setupUserDetials(userDetails: [String: Any]?)
}
class UserDetailsService: UserDetailsServiceProtocol {
    
    let bag = DisposeBag()
    static let shared = UserDetailsService()

    let name = Observable<String>("")
    let buffetTimes = Observable<Int>(0)
    let number = Observable<String>("")

    func setupUserDetials(userDetails: [String: Any]?) {
        guard let userDetails = userDetails else { return }
        name.value = userDetails["name"] as? String ?? ""
        buffetTimes.value = userDetails["buffetTimes"] as? Int ?? 0
        number.value = userDetails["number"] as? String ?? ""
    }
}


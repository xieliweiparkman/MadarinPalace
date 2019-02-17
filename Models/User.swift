//
//  User.swift
//  MadarinPalace
//
//  Created by Xie Liwei on 16/02/2019.
//  Copyright © 2019 Xie Liwei. All rights reserved.
//

import Foundation
class User {
    var name: String?
    var phone: String?
    var buffetTimes: Int?
    var userId: String?
    
    init(name: String?, phone: String?, buffetTimes: Int, userId: String?) {
        self.name = name
        self.phone = phone
        self.buffetTimes = buffetTimes
        self.userId = userId
    }
}

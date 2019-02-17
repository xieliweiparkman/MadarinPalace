//
//  AppNotificationService.swift
//  Ainoya-Tampere
//
//  Created by Xie Liwei on 20/09/2018.
//  Copyright © 2018 Xie Liwei. All rights reserved.
//

import Foundation
import Firebase
import UserNotifications

protocol AppNotificationServiceProtocol {
    func setDeviceToken()
    func clearDeviceToken()
    func registerForPushNotification()
}

class AppNotificationService: AppNotificationServiceProtocol {
    static let shared = AppNotificationService()
    fileprivate var rootRef: DatabaseReference
    
    private init() {
        rootRef = Database.database().reference()
        registerForPushNotification()
    }
    
    func setDeviceToken() {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        guard let deviceToken = InstanceID.instanceID().token() else {return}
        rootRef.child("users/\(currentUser.uid)/deviceTokens/\(deviceToken)").setValue(true)
    }
    
    func clearDeviceToken() {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        guard let deviceToken = InstanceID.instanceID().token() else {return}
        rootRef.child("users/\(currentUser.uid)/deviceTokens/\(deviceToken)").setValue(false)
    }
    
    func registerForPushNotification() {
        // Notification
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(grant, error)  in
            if error == nil {
                if grant {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                } else {
                    //User didn't grant permission
                }
            } else {
                
                print("error: ", error ?? "")
            }
        })
    }
}

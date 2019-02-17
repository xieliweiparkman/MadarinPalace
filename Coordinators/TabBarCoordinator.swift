////
////  TabBarCoordinator.swift
////  Ainoya-Tampere
////
////  Created by Xie Liwei on 21/09/2018.
////  Copyright © 2018 Xie Liwei. All rights reserved.
////
//
import Foundation
import Firebase
import ReactiveKit
import Bond

enum TabBarTransition: Transition {
    case showSettings
    case logout
}

class TabBarCoordinator: NSObject, AppCoordinator {
    
    var rootViewController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    let coordinator = PublishSubject<StartAppTransition, NoError>()
    //MARK: Input
    let transition = SafePublishSubject<TabBarTransition>()
    
    override init() {
        let mainStoryboard = UIStoryboard(storyboardName: .Main)
        
        let couponVC: CouponViewController = mainStoryboard.instantiateViewController()
        let userId = Auth.auth().currentUser!.uid
        let couponVM = CouponViewModel(userId: userId)

        couponVC.viewModel = couponVM
        let couponNVC = UINavigationController(rootViewController: couponVC)
        couponNVC.isNavigationBarHidden = true
        rootViewController = couponNVC

        super.init()
        couponVM.coordinator.observeNext { transition in
            self.performTransition(transition: transition)
        }.dispose(in: bag)
    }
    
    deinit {
        print("DEINIT: LevelMainCoordinator")
    }
    
    func start() {
        
    }
    
    func performTransition(transition: TabBarTransition) {
        switch transition {
        case .showSettings:
            print("Show Settings")
//            let settingsCoordinate = SettingsCoordinator()
//            settingsCoordinate.start()
////            settingsCoordinate.coordinator.observeNext(with: { [weak self] (transition) in
////                self?.performTransition(transition: transition)
////            }).dispose(in: bag)
//            rootViewController.present(settingsCoordinate.rootViewController, animated: true, completion: nil)
//            childCoordinators.append(settingsCoordinate)
        case .logout:
            print("logout")
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            UserDefaults.standard.removeObject(forKey: "userQRCodeData")
            coordinator.next(.showIntroScreen())
        }
    }

}

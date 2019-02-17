////
////  StartAppCoordinator.swift
////  Ainoya-Tampere
////
////  Created by Xie Liwei on 20/09/2018.
////  Copyright © 2018 Xie Liwei. All rights reserved.
////
//
import Foundation
import ReactiveKit
import Firebase

enum StartAppTransition: Transition {
    case showIntroScreen()
    case showMainScreen(coordinator: Coordinator)
    case showLoadingScreen(coordinator: Coordinator)
}

final class StartAppCoordinator: AppCoordinator {
    fileprivate let bag = DisposeBag()
    
    var rootViewController: UIViewController
    
    var childCoordinators: [Coordinator] = []
    
    let window: UIWindow
    
    //MARK: Input
    let transition = SafePublishSubject<StartAppTransition>()
    //MARK: Output
    
    init(window: UIWindow) {
        self.window = window
        if AuthenticateService.isLoggedIn() {
            let loadingCoordinator = LoadingCoordinator()
            loadingCoordinator.start()
            rootViewController = loadingCoordinator.rootViewController
            loadingCoordinator.outputTransition.bind(to: transition)
            addChildCoordinator(loadingCoordinator)
        } else {
            let introCoordinator = IntroCoordinator()
            introCoordinator.start()
            rootViewController = introCoordinator.rootViewController
            introCoordinator.outputTransition.bind(to: transition)
            addChildCoordinator(introCoordinator)
        }
    }
    
    deinit {
        print("DEINIT AppCoordinator")
    }
    
    func start() {
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        transition
        .observeOn(.main)
        .observeNext { [weak self] (transition) in
            self?.performTransition(transition: transition)
        }.dispose(in: bag)
    }
    
    func performTransition(transition: StartAppTransition) {
        switch transition {
        case .showIntroScreen():
            print("Show intro screen")
            let introCoordinator = IntroCoordinator()
            introCoordinator.start()
            rootViewController = introCoordinator.rootViewController
            introCoordinator.outputTransition.bind(to: self.transition)
            
            if window.rootViewController == nil {
                window.rootViewController = rootViewController
                return
            }
            window.rootViewController = rootViewController
            
            addChildCoordinator(introCoordinator)
        case .showMainScreen(let coordinator):
            print("Show main view")
            let tabBarCoordinator = TabBarCoordinator()
            tabBarCoordinator.start()
            
            rootViewController = tabBarCoordinator.rootViewController

            if window.rootViewController == nil {
                window.rootViewController = rootViewController
                return
            }
            window.rootViewController = rootViewController
            tabBarCoordinator.coordinator.observeNext { (transition) in
                self.performTransition(transition: transition)
            }.dispose(in: bag)
            addChildCoordinator(tabBarCoordinator)
            removeChildCoordinator(coordinator)
        case .showLoadingScreen(let coordinator):
            let loadingCoordinator = LoadingCoordinator()
            loadingCoordinator.start()
            rootViewController = loadingCoordinator.rootViewController
            if window.rootViewController == nil {
                window.rootViewController = rootViewController
                return
            }
            window.rootViewController = rootViewController
            loadingCoordinator.outputTransition.bind(to: self.transition)
            addChildCoordinator(loadingCoordinator)
            removeChildCoordinator(coordinator)
        }
    }
}

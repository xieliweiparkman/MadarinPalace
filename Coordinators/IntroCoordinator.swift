////
////  IntroCoordinator.swift
////  Ainoya-Tampere
////
////  Created by Xie Liwei on 20/09/2018.
////  Copyright © 2018 Xie Liwei. All rights reserved.
////

import Foundation
import ReactiveKit
import Bond

enum IntroTransition: Transition {
    case showLoadingScreen
    case popViewController(animated: Bool)
}

final class IntroCoordinator: AppCoordinator {
    fileprivate let bag = DisposeBag()
    
    var rootViewController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    //MARK: Input
    let transition = SafePublishSubject<IntroTransition>()
    //MARK: Output
    let outputTransition = SafePublishSubject<StartAppTransition>()
    
    init() {
        rootViewController = UINavigationController()
        rootViewController.isNavigationBarHidden = true

        let authenticateService = AuthenticateService()
        let loginVM = LoginViewModel(authenticateService: authenticateService)
        loginVM.transition.observeNext(with: { [weak self] (transition) in
            self?.performTransition(transition: transition)
        }).dispose(in: bag)
        let introStoryboard = UIStoryboard(storyboardName: .Main)
        let loginVC: LoginViewController = introStoryboard.instantiateViewController()
        loginVC.viewModel = loginVM
        rootViewController.pushViewController(loginVC, animated: false)
    }
    
    deinit {
        debugPrint("DEINIT: IntroCoordinator")
    }
    
    func start() {
        transition.observeOn(.main).observeNext { [weak self] (transition) in
            self?.performTransition(transition: transition)
            }.dispose(in: bag)
    }
    
    func performTransition(transition: IntroTransition) {
        switch transition {
        case .popViewController(let animated):
            rootViewController.popViewController(animated: animated)
        case .showLoadingScreen:
            outputTransition.next(.showLoadingScreen(coordinator: self))
        }
        
    }
}

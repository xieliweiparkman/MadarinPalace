////
////  LoadingCoordinator.swift
////  Ainoya-Tampere
////
////  Created by Xie Liwei on 17/12/2018.
////  Copyright © 2018 Xie Liwei. All rights reserved.
////
//
import Foundation
import Bond
import ReactiveKit

enum LoadingTransition: Transition {
    case showMainScreen
}

class LoadingCoordinator: AppCoordinator {
    fileprivate let bag = DisposeBag()
    
    var rootViewController: UIViewController
    
    var childCoordinators: [Coordinator] = []
    
    //MARK: Input
    let transition = SafePublishSubject<LoadingTransition>()
    //MARK: Output
    let outputTransition = SafePublishSubject<StartAppTransition>()
    
    init() {
        let loadingViewModel = LoadingViewModel()
        let loadingVC: LoadingViewController = UIStoryboard(storyboardName: .Main).instantiateViewController()
        loadingVC.loadingViewModel = loadingViewModel
        rootViewController = loadingVC
        loadingViewModel.transition.bind(to: transition)
    }
    
    deinit {
        print("DEINIT LoadingCoordinator")
    }
    
    func start() {
        transition
        .observeOn(.main)
        .observeNext { [weak self] (transition) in
            self?.performTransition(transition: transition)
        }.dispose(in: bag)
    }
    
    func performTransition(transition: LoadingTransition) {
        switch transition {
        case .showMainScreen:
            self.outputTransition.next(.showMainScreen(coordinator: self))
        }
    }
}

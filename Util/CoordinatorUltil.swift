//
//  CoordinatorUltil.swift
//  Ainoya-Tampere
//
//  Created by Xie Liwei on 20/09/2018.
//  Copyright © 2018 Xie Liwei. All rights reserved.
//

import Foundation
import ReactiveKit
//MARK: Coordinator Protocol

//MARK: Transition
protocol Transition {}

//MARK: Coordinator
protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
}

extension Coordinator {
    public func addChildCoordinator(_ childCoordinator: Coordinator) {
        childCoordinators.append(childCoordinator)
    }
    
    public func removeChildCoordinator(_ childCoordinator: Coordinator) {
        childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
    }
}

//MARK: RootViewControllerProvider
protocol RootViewControllerProvider: class {
    associatedtype Root: UIViewController
    var rootViewController: Root { get }
    
    func start()
    
    associatedtype T: Transition
    func performTransition(transition: T)
}

//MARK: AppCoordinator
typealias AppCoordinator = Coordinator & RootViewControllerProvider

//MARK: CoordinatorViewModelProtocol
protocol CoordinatorViewModelProtocol {
    associatedtype T: Transition
    var transition: SafePublishSubject<T> { get }
}

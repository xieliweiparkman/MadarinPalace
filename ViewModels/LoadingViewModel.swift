//
//  LoadingViewModel.swift
//  MadarinPalace
//
//  Created by Xie Liwei on 13/02/2019.
//  Copyright © 2019 Xie Liwei. All rights reserved.
//
import Foundation
import ReactiveKit
import Bond

class LoadingViewModel {
    fileprivate let bag = DisposeBag()
    //MARK: Input
    
    //MARK: Output
    let didFinishLoading = SafePublishSubject<Void>()
    //MARK: Coordinator
    let transition = SafePublishSubject<LoadingTransition>()
    
    //MARK: Dependencies
    fileprivate let firebaseService: FirebaseServiceProtocol
    
    
    init(firebaseService: FirebaseServiceProtocol = FirebaseService.shared) {
        self.firebaseService = firebaseService
    }
    
    func setup() {
        //Load UserInfo, observing orders from Firebase
        firebaseService.getUserInfo()
        .doOn(next: { [weak self] _ in
            self?.didFinishLoading.next()
        })
        .delay(interval: 0.75)
        .observeNext { [weak self] _ in
            self?.transition.next(.showMainScreen)
        }.dispose(in: bag)
    }
    
    func showMainScreen() {
        self.transition.next(.showMainScreen)
    }
}

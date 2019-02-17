//
//  LoginViewModel.swift
//  MadarinPalace
//
//  Created by Xie Liwei on 13/02/2019.
//  Copyright © 2019 Xie Liwei. All rights reserved.
//

import Foundation
import ReactiveKit
import Bond

protocol LoginViewModelProtocol {
    //MARK: Input
    var phoneNumber: Observable<String> { get }
    var verifyCode: Observable<String> { get }
    var verificationID: Observable<String> { get }
    var didTapLoginWithPhoneNumberButton: SafePublishSubject<Void> { get }
    var didTapSendPhoneNumberButton: SafePublishSubject<Void> { get }
    
    var shouldShowInputCodeViewController: Observable<Bool> { get }
    var shouldEnableSendPhoneNumberButton: Observable<Bool> { get }
    var shouldEnableSendCodeButton: Observable<Bool> { get }

    //MARK: Output
    var transition: SafePublishSubject<IntroTransition> { get }

    var activity: SafePublishSubject<Bool> { get }
    var errors: SafePublishSubject<AppError> { get }
    
    //MARK: Property
    var validNumber: Observable<Bool> { get }
    var validCode: Observable<Bool> { get }
}

final class LoginViewModel: LoginViewModelProtocol {
    
    fileprivate let bag = DisposeBag()
    
    //MARK: Input
    let phoneNumber = Observable<String>("")
    let verifyCode = Observable<String>("")
    let verificationID = Observable<String>("")
    let shouldEnableSendCodeButton = Observable<Bool>(false)
    let shouldEnableSendPhoneNumberButton = Observable<Bool>(false)
    let shouldShowInputCodeViewController = Observable<Bool>(false)
    let didTapLoginWithPhoneNumberButton = SafePublishSubject<Void>()
    let didTapSendPhoneNumberButton = SafePublishSubject<Void>()
    
    //MARK: Output
    let activity = SafePublishSubject<Bool>()
    let errors = SafePublishSubject<AppError>()
    
    //MARK: Property
    let validNumber = Observable<Bool>(false)
    let validCode = Observable<Bool>(false)
    
    //MARK: Coordinator
    let transition = SafePublishSubject<IntroTransition>()
    
    //MARK: Dependencies
    fileprivate let authenticateService: AuthenticateServiceProtocol
    fileprivate let appNotificationService: AppNotificationServiceProtocol
    fileprivate let firebaseService: FirebaseServiceProtocol
    //MARK: Init
    init(authenticateService: AuthenticateServiceProtocol,
         appNotificationService: AppNotificationServiceProtocol = AppNotificationService.shared,
         firebaseService: FirebaseServiceProtocol = FirebaseService.shared) {
        self.authenticateService = authenticateService
        self.appNotificationService = appNotificationService
        self.firebaseService = firebaseService
        
        didTapSendPhoneNumberButton.observeNext {
            self.shouldEnableSendPhoneNumberButton.value = false
            self.sendPhoneNumberToFirebase()
        }.dispose(in: bag)
        
        didTapLoginWithPhoneNumberButton.observeNext {
            self.loginToFirebase()
        }.dispose(in: bag)
        phoneNumber.map { AppUtilities.isPhoneNumberValid($0)}.bind(to: validNumber)
        verifyCode.map { AppUtilities.isCodeValid($0)}.bind(to: validCode)
        
        validNumber.observeNext { valid in
            if valid {
                self.shouldEnableSendPhoneNumberButton.value = true
            } else {
                self.shouldEnableSendPhoneNumberButton.value = false
            }
        }.dispose(in: bag)
        
        validCode.observeNext { valid in
            if valid {
                self.shouldEnableSendCodeButton.value = true
            } else {
                self.shouldEnableSendCodeButton.value = false
            }
        }.dispose(in: bag)
    }
    
    fileprivate func sendPhoneNumberToFirebase() {
        guard validNumber.value else {
            errors.next(AppError.invalidNumber)
            return
        }
        authenticateService.requestFirebaseVerificationIDWithPhoneNumber(number: phoneNumber.value)
        .feedActivity(into: activity)
        .suppressAndFeedError(into: errors)
        .observeNext(with: { verificationID in
            self.shouldEnableSendPhoneNumberButton.value = true
            self.verificationID.value = verificationID
            self.shouldShowInputCodeViewController.next(true)
        }).dispose(in: bag)
    }
    
    fileprivate func loginToFirebase() {
        guard validNumber.value else {
            errors.next(AppError.invalidNumber)
            return
        }
        guard validCode.value else {
            errors.next(AppError.invalidCode)
            return
        }
        authenticateService.loginToFirebaseWithVerificationIDAndVerificationCode(id: verificationID.value, code: verifyCode.value)
        .feedActivity(into: activity)
        .suppressAndFeedError(into: errors)
        .doOn(next: { [weak self] _ in
        self?.firebaseService.setUserPhone(phone: self?.phoneNumber.value ?? "")
        self?.appNotificationService.setDeviceToken()
        })
        .observeNext(with: { [weak self] _ in
        self?.authenticateService.setLogIn()
        self?.transition.next(.showLoadingScreen)
        }).dispose(in: bag)
    }
    
}

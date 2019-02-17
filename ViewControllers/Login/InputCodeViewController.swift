//
//  InputCodeViewController.swift
//  MadarinPalace
//
//  Created by Xie Liwei on 13/02/2019.
//  Copyright © 2019 Xie Liwei. All rights reserved.
//

import UIKit
import ReactiveKit
import Bond

class InputCodeViewController: UIViewController {

    @IBOutlet weak var codeInputView: PMVerificationCodeInputView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var codeInputDesLabel: UILabel!
    @IBOutlet weak var editPhoneNumberButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var resendSMSButton: UIButton!
    @IBOutlet weak var loginButton: ProceedButton!
    
    var viewModel: LoginViewModelProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        bindViewModel()
    }
    func updateUI() {
        codeInputView.becomeFirstResponder()
        loginButton.layer.cornerRadius = 28
    }
    func bindViewModel() {
        viewModel.phoneNumber.observeNext { number in
            let attributedString = NSMutableAttributedString(string: "Enter the 6-digit code that was sent as an SMS to the number +358\(number)", attributes: [
                NSFontAttributeName: UIFont.appLightFont(size: 14)
                ])
            attributedString.addAttribute(NSFontAttributeName, value: UIFont.appBoldFont(size: 14), range: NSRange(location: 61, length: 13))
            self.codeInputDesLabel.attributedText = attributedString
        }.dispose(in: bag)

        codeInputView.textField.reactive.text.map { _ in self.codeInputView.textField.text ?? ""}.bind(to: viewModel.verifyCode)
        loginButton.reactive.tap.bind(to: viewModel.didTapLoginWithPhoneNumberButton)
        resendSMSButton.reactive.tap.bind(to: viewModel.didTapSendPhoneNumberButton)
        backButton.reactive.tap.observeNext {
            self.navigationController?.popViewController(animated: true)
        }.dispose(in: bag)
        
        editPhoneNumberButton.reactive.tap.observeNext {
            self.navigationController?.popViewController(animated: true)
        }.dispose(in: bag)
        
        viewModel.shouldEnableSendCodeButton.observeNext { (should) in
            if should {
                self.loginButton.isEnabled = true
                self.loginButton.showLoadingIndicator()
                self.viewModel.didTapLoginWithPhoneNumberButton.next()
            } else {
                self.loginButton.isEnabled = false
            }
        }.dispose(in: bag)
        
        viewModel.errors.doOn(next: { [weak self] (error) in
            self?.errorLabel.alpha = 0
        }).observeNext { [weak self] (error) in
            self?.errorLabel.alpha = 1
            self?.errorLabel.text = "Please check the code."
            self?.loginButton.hideLoadingIndicator()
            self?.loginButton.isEnabled = false
            self?.codeInputView.clear()
        }.dispose(in: bag)
    }

}

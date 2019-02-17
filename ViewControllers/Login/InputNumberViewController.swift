//
//  InputNumberViewController.swift
//  MadarinPalace
//
//  Created by Xie Liwei on 13/02/2019.
//  Copyright © 2019 Xie Liwei. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

class InputNumberViewController: UIViewController {

    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var sendPhoneNumberButton: ProceedButton!
    @IBOutlet weak var phoneNumberUnderLineView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    var viewModel: LoginViewModelProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    func updateUI() {
        sendPhoneNumberButton.layer.cornerRadius = 28
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        viewModel.shouldShowInputCodeViewController.value = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        numberTextField.becomeFirstResponder()
    }
    
    func bindViewModel() {
        sendPhoneNumberButton.reactive.tap.observeNext {
            self.sendPhoneNumberButton.showLoadingIndicator()
        }.dispose(in: bag)
        sendPhoneNumberButton.reactive.tap.bind(to: viewModel.didTapSendPhoneNumberButton)
        numberTextField.reactive.text.map { _ in self.numberTextField.text!}.bind(to: viewModel.phoneNumber)
        backButton.reactive.tap.observeNext {
            self.navigationController?.popViewController(animated: true)
        }.dispose(in: bag)
        
        
        viewModel.shouldEnableSendPhoneNumberButton.observeNext { (should) in
            if should {
                self.sendPhoneNumberButton.isEnabled = true
            } else {
                self.sendPhoneNumberButton.isEnabled = false
            }
        }.dispose(in: bag)
        
        viewModel.shouldShowInputCodeViewController.observeNext { should in
        if should {
            self.showInputCodeView()
        }
        }.dispose(in: bag)
        
        viewModel.errors.doOn(next: { [weak self] (error) in
            self?.phoneNumberUnderLineView.backgroundColor = UIColor.appGreenColor()
        }).observeNext { [weak self] (error) in
            self?.phoneNumberUnderLineView.backgroundColor = UIColor.appRedColor()
            self?.sendPhoneNumberButton.hideLoadingIndicator()
        }.dispose(in: bag)
    }
    
    func showInputCodeView() {
        if navigationController?.childViewControllers.last is InputNumberViewController {
            sendPhoneNumberButton.hideLoadingIndicator()
            let inputCodeVC: InputCodeViewController = UIStoryboard(storyboardName: .Main).instantiateViewController()
            inputCodeVC.viewModel = viewModel
            navigationController?.pushViewController(inputCodeVC, animated: true)
        }
    }
}

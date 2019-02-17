//
//  ViewController.swift
//  MadarinPalace
//
//  Created by Xie Liwei on 12/02/2019.
//  Copyright © 2019 Xie Liwei. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

class LoginViewController: UIViewController {

    @IBOutlet weak var phoneLoginView: UIView!
    @IBOutlet weak var loginWithPhoneButton: UIButton!
    
    var viewModel: LoginViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        loginWithPhoneButton.reactive.tap.observeNext {
            self.showInputNumberVC()
        }.dispose(in: bag)
    }
    
    func updateUI() {
        phoneLoginView.layer.cornerRadius = 4
    }
    
    func showInputNumberVC() {
        let inputNumberVC: InputNumberViewController = UIStoryboard(storyboardName: .Main).instantiateViewController()
        inputNumberVC.viewModel = viewModel
        navigationController?.pushViewController(inputNumberVC, animated: true)
    }
}


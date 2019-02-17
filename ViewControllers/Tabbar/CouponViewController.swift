//
//  CouponViewController.swift
//  MadarinPalace
//
//  Created by Xie Liwei on 13/02/2019.
//  Copyright © 2019 Xie Liwei. All rights reserved.
//

import UIKit
import Firebase
import DropDown
import EFQRCode

class CouponViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var stampsCollectionView: UICollectionView!
    @IBOutlet weak var barCodeImageView: UIImageView!
    @IBOutlet weak var couponsCollectionView: UICollectionView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var settingButton: UIButton!
    var dropDown: DropDown!
    var viewModel: CouponViewModelProtocol!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        stampsCollectionView.delegate = self
        stampsCollectionView.dataSource = self
        nameTextField.delegate = self
        bindViewModel()
        updateUI()
        addDropDownList()
        createQRCode()
    }
    
    func updateUI() {
        mainView.layer.cornerRadius = 8
        let blur = createBlurs()
        logoImageView.addSubview(blur)
        settingView.layer.cornerRadius = 25
        userImageView.layer.cornerRadius = userImageView.frame.size.width/2
    }
    
    func addDropDownList() {
        dropDown = DropDown()
        dropDown.anchorView = settingView
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y:(settingView.bounds.height))
        dropDown.cornerRadius = 8
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.dropDown.deselectRow(index)
            if index == Index(0) {
                self?.nameTextField.becomeFirstResponder()
            } else {
                self?.viewModel.didTapOnLogoutButton.next()
            }
        }
        dropDown.dataSource = ["Set Name","Logout"]
        let appearance = DropDown.appearance()
        appearance.cellHeight = 35
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = .darkGray
        dropDown.width = 100
    }
    
    func bindViewModel() {
        viewModel.barCodeImage.bind(to: barCodeImageView.reactive.image)
        viewModel.name.bind(to: nameTextField.reactive.text)
        viewModel.buffetTimes.observeNext { _ in
            self.stampsCollectionView.reloadData()
        }.dispose(in: bag)
        
        //OUTPUT
        settingButton.reactive.tap.observeNext { _ in
            self.dropDown.show()
        }.dispose(in: bag)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if AppUtilities.isNameValid(textField.text) {
            FirebaseService.shared.setName(name: textField.text!)
            textField.resignFirstResponder()
            return true
        } else {
            showNameInvalidAlert()
        }
        return false
    }
    
    func showNameInvalidAlert() {
        let alert = UIAlertController.init(title: NSLocalizedString("Oops", comment: ""), message: "Full name is required", preferredStyle: .alert)
        let ok = UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
            self.nameTextField.becomeFirstResponder()
        }
        alert.addAction(ok)
        alert.view.tintColor = UIColor.appGreenColor()
        present(alert, animated: true, completion: nil)
    }
    
    func createQRCode() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let user = UserDefaults.standard
        if let data = user.data(forKey: "userQRCodeData") {
            let image = UIImage(data: data)
            barCodeImageView.image = image
        } else {
            if let tryImage = EFQRCode.generate(
                content: userID,
                watermark: UIImage(named: "AppLogo")?.toCGImage()
                ) {
                print("Create QRCode image success: \(tryImage)")
                let image = UIImage(cgImage: tryImage)
                let imageData = UIImagePNGRepresentation(image)
                UserDefaults.standard.set(imageData, forKey: "userQRCodeData")
                barCodeImageView.image = UIImage(cgImage: tryImage)
            }
        }
    }
}

extension CouponViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == stampsCollectionView {
            return 10
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == stampsCollectionView {
            let cell: StampsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StampsCollectionViewCell", for: indexPath) as! StampsCollectionViewCell
            cell.layer.cornerRadius = 8
            if indexPath.row == 9 {
                cell.stampImageView.image = UIImage(named: "GiftIcon")
                cell.backgroundColor = UIColor.appOrangeColor()
            } else {
                if indexPath.row < viewModel.buffetTimes.value % 10 {
                    cell.stampImageView.image = UIImage(named: "StampEnabled")
                    cell.backgroundColor = UIColor.appGreenColor()
                } else {
                    cell.stampImageView.image = UIImage(named: "StampDisabled")
                    cell.backgroundColor = UIColor.appGreyBackgroundColor()
                }
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = appWidth / 5 - 16
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(20, 15, 15, 15)
    }
}

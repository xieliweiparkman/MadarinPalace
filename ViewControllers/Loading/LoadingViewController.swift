//
//  LoadingViewController.swift
//  MadarinPalace
//
//  Created by Xie Liwei on 13/02/2019.
//  Copyright © 2019 Xie Liwei. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet weak var loadingImageView: UIImageView!
    
    var loadingViewModel: LoadingViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        animateImageView()
        loadingViewModel.didFinishLoading.observeOn(.main).observeNext { [weak self] _ in
            self?.stopAnimation()
        }.dispose(in: bag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        animateImageView()
        loadingViewModel.setup()
    }
    
    func animateImageView() {
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.repeat], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.5, animations: { [weak self] _ in
                self?.loadingImageView.alpha = 0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.5, animations: { [weak self] _ in
                self?.loadingImageView.alpha = 1
            })
        }, completion: nil)
    }
    
    func stopAnimation() {
        loadingImageView.layer.removeAllAnimations()
    }
}

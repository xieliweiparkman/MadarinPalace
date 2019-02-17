//
//  TabBarViewController.swift
//  Ainoya-Tampere
//
//  Created by Xie Liwei on 21/09/2018.
//  Copyright © 2018 Xie Liwei. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor.appGreenColor()
        tabBar.backgroundColor = UIColor(red: 31/255.0, green: 31/255.0, blue: 31/255.0, alpha: 0.9)
        // Do any additional setup after loading the view.
    }
    

}

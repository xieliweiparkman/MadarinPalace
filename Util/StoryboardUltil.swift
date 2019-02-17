//
//  StoryboardUltil.swift
//  Ainoya-Tampere
//
//  Created by Xie Liwei on 20/09/2018.
//  Copyright © 2018 Xie Liwei. All rights reserved.
//

import Foundation
import UIKit
//MARK: Storyboard Enum
extension UIStoryboard {
    enum StoryboardName: String {
        case Main
    }
    
    convenience init(storyboardName: StoryboardName) {
        self.init(name: storyboardName.rawValue, bundle: nil)
    }
}

//MARK: Segue Injection
protocol Injectable {
    associatedtype T
    
    func inject(_: T)
}


//MARK: Storyboard instantiate
protocol StoryboardIdentifier {}

extension StoryboardIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIViewController: StoryboardIdentifier {}

extension UIStoryboard {
    final func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = instantiateViewController(withIdentifier: T.identifier) as? T else {
            fatalError("Could not get UIViewController with identifier: \(T.identifier)")
        }
        return viewController
    }
}

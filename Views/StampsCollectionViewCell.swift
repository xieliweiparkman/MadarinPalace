//
//  StampsCollectionViewCell.swift
//  MadarinPalace
//
//  Created by Xie Liwei on 16/02/2019.
//  Copyright © 2019 Xie Liwei. All rights reserved.
//

import UIKit

class StampsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var stampImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.layer.cornerRadius = 4
        
    }
}

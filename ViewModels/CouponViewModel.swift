//
//  CouponViewModel.swift
//  MadarinPalace
//
//  Created by Xie Liwei on 16/02/2019.
//  Copyright © 2019 Xie Liwei. All rights reserved.
//

import Foundation
import ReactiveKit
import Bond
import Firebase

protocol CouponViewModelProtocol {
    var buffetTimes: Observable<Int> { get }
    var barCodeImage: Observable<UIImage?> { get }
    var didTapOnLogoutButton: Observable<Void> { get }
    var name: Observable<String> { get }
    var coordinator: SafePublishSubject<TabBarTransition> { get }

    func generateBarcode(userId: String) -> UIImage?
}

class CouponViewModel: CouponViewModelProtocol {
    let buffetTimes = Observable<Int>(0)
    let barCodeImage = Observable<UIImage?>(UIImage())
    let didTapOnLogoutButton = Observable<Void>()
    let name = Observable<String>("Dear customer")
    let coordinator = SafePublishSubject<TabBarTransition>()
    fileprivate let userDetailsService = UserDetailsService.shared
    fileprivate let bag = DisposeBag()
    
    init(userId: String) {
        barCodeImage.value = generateBarcode(userId: userId)
        userDetailsService.buffetTimes.bind(to: buffetTimes)
        userDetailsService.name.bind(to: name)
        didTapOnLogoutButton.observeNext {            
            self.coordinator.next(.logout)
        }.dispose(in: bag)
    }
    
    func generateBarcode(userId: String) -> UIImage? {
        let data = userId.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setDefaults()
            //Margin
            filter.setValue(7.00, forKey: "inputQuietSpace")
            filter.setValue(data, forKey: "inputMessage")
            //Scaling
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.applying(transform) {
                let context:CIContext = CIContext.init(options: nil)
                let cgImage:CGImage = context.createCGImage(output, from: output.extent)!
                let rawImage:UIImage = UIImage.init(cgImage: cgImage)
                
                let cgimage: CGImage = (rawImage.cgImage)!
                let cropZone = CGRect(x: 0, y: 0, width: Int(rawImage.size.width), height: Int(rawImage.size.height))
                let cWidth: size_t  = size_t(cropZone.size.width)
                let cHeight: size_t  = size_t(cropZone.size.height)
                let bitsPerComponent: size_t = cgimage.bitsPerComponent
                let bytesPerRow = (cgimage.bytesPerRow) / (cgimage.width  * cWidth)
                
                let context2: CGContext = CGContext(data: nil, width: cWidth, height: cHeight, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: cgimage.bitmapInfo.rawValue)!
                
                context2.draw(cgimage, in: cropZone)
                
                let result: CGImage  = context2.makeImage()!
                let finalImage = UIImage(cgImage: result)
                
                return finalImage
            }
        }
        return nil
    }
}

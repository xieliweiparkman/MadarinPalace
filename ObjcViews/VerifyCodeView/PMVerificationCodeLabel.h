//
//  PMVertificationCodeLabel.h
//  ParkMan
//
//  Created by Xie Liwei on 11/06/2018.
//  Copyright © 2018 Teemu Poikela. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMVerificationCodeLabel : UILabel

@property (nonatomic, assign) NSInteger numberOfVerificationCode;
@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat cornerRadius;

@end

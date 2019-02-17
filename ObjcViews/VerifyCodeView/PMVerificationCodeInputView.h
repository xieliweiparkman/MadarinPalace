//
//  PMVerificationCodeInputView.h
//  ParkMan
//
//  Created by Xie Liwei on 11/06/2018.
//  Copyright © 2018 Teemu Poikela. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMVerificationCodeInputView;

typedef void(^textDidChangeBlock)(UITextField *textField);

@protocol PMVerificationCodeInputViewDelegate <NSObject>

- (void)verificationCodeInput:(PMVerificationCodeInputView *)view didCompleteInputWithCode:(NSString *)verificationCode;
- (void)verificationCodeInputIsEditing:(PMVerificationCodeInputView *)view;

@end

@interface PMVerificationCodeInputView : UIView <UITextInput>

@property (nonatomic, assign) IBInspectable NSInteger numberOfVerificationCode;
@property (nonatomic, copy) IBInspectable NSString *verificationCode;
@property (nonatomic, assign) IBInspectable CGFloat spacing;
@property (nonatomic, assign) IBInspectable CGFloat lineWidth;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, strong) IBInspectable UIFont *font;
@property (nonatomic, strong) IBInspectable UIColor *textColor;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, copy  ) textDidChangeBlock block;

@property (nonatomic, weak) id<PMVerificationCodeInputViewDelegate> delegate;

- (void)becomeFirstResponder;
- (void)clear;

@end

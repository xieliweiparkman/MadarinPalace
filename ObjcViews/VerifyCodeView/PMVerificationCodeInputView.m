//
//  PMVertificationCodeInputView.m
//  ParkMan
//
//  Created by Xie Liwei on 11/06/2018.
//  Copyright © 2018 Teemu Poikela. All rights reserved.
//

#import "PMVerificationCodeInputView.h"
#import "PMVerificationCodeLabel.h"

IB_DESIGNABLE
@interface PMVerificationCodeInputView()<UITextFieldDelegate>
@property (nonatomic, strong) PMVerificationCodeLabel *label;

@end

@implementation PMVerificationCodeInputView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.label.frame = self.bounds;
}


- (void)initialize{
    self.numberOfVerificationCode = 4;

    self.textField = [[UITextField alloc] initWithFrame:self.bounds];
    
    self.textField.hidden = YES;
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.textField.delegate = self;
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self insertSubview:self.textField atIndex:0];
    
    self.label= [[PMVerificationCodeLabel alloc] initWithFrame:self.bounds];
    [self addSubview:self.label];
    self.label.spacing = 10;
    self.label.numberOfVerificationCode = self.numberOfVerificationCode;
    self.label.font = self.textField.font;
    self.label.lineWidth = 1;
    self.label.borderColor = [UIColor blackColor];
    [self.label setNeedsLayout];
}

- (void)becomeFirstResponder {
    [self.textField becomeFirstResponder];
}

- (void)clear {
    self.textField.text = @"";
    self.label.text = @"";
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (string.length != 0) {
        if (textField.text.length < self.numberOfVerificationCode) {
            self.label.text = [textField.text stringByAppendingString:string];
            self.verificationCode = self.label.text;
            return YES;
        } else {
            return NO;
        }
    } else {
        if (range.length == 0) return NO;

        self.label.text = [textField.text substringToIndex:textField.text.length - 1];
        self.verificationCode = self.label.text;
        return YES;
    }
}

#pragma mark - Action
- (void)textFieldDidChange:(UITextField *)textField{
    if (self.block) {
        self.block(textField);
    }
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.textField becomeFirstResponder];
}

#pragma mark - Setters
- (void)setVerificationCode:(NSString *)verificationCode {
    _verificationCode = verificationCode;
    self.label.text = verificationCode;

    if (verificationCode.length == 4) {
        if ([self.delegate respondsToSelector:@selector(verificationCodeInput:didCompleteInputWithCode:)]) {
            [self.delegate verificationCodeInput:self didCompleteInputWithCode:verificationCode];
        }
    }
    else {
        if ([self.delegate respondsToSelector:@selector(verificationCodeInputIsEditing:)]) {
            [self.delegate verificationCodeInputIsEditing:self];
        }
    }
}

- (void)setNumberOfVerificationCode:(NSInteger)numberOfVerificationCode {
    _numberOfVerificationCode = numberOfVerificationCode;
    self.label.numberOfVerificationCode = numberOfVerificationCode;
}

- (void)setSpacing:(CGFloat)spacing{
    _spacing = spacing;
    self.label.spacing = spacing;
}

- (void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
    self.label.lineWidth = lineWidth;
}

- (void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    self.label.borderColor = borderColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    self.label.cornerRadius = cornerRadius;
}

-(void)setFont:(UIFont *)font{
    _font = font;
    self.label.font = font;
}

-(void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    self.label.textColor = textColor;
}

@synthesize beginningOfDocument;

@synthesize endOfDocument;

@synthesize hasText;

@synthesize inputDelegate;

@synthesize markedTextRange;

@synthesize markedTextStyle;

@end

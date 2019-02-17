//
//  ProceedButton.m
//  ParkMan
//
//  Created by Nguyen Luong on 4/24/18.
//  Copyright © 2018 Teemu Poikela. All rights reserved.
//

#import "ProceedButton.h"
@interface ProceedButton ()
@property (strong, nonatomic) UIView *loadingIndicatorContainer;
@property (strong, nonatomic) UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) UIImage *buttonImage;
@property (strong, nonatomic) NSString *buttonText;

@end

@implementation ProceedButton

- (instancetype)init {
    if (self = [super init]) {
        [self baseInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self baseInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit {
    
    UIColor *buttonGreenColor = [[UIColor colorWithRed:(62.0f / 255.0f) green:(187.0f / 255.0f) blue:0 alpha:1] colorWithAlphaComponent:0.9f];
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame),
                            CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    self.backgroundColor = buttonGreenColor;
    self.buttonImage = self.imageView.image;
    self.buttonText = self.titleLabel.text;
    
    self.layer.cornerRadius = CGRectGetWidth(self.frame) / 2;
    CGFloat imgInsetPadding = CGRectGetWidth(self.frame) / 4;
    self.tintColor = [UIColor whiteColor];
    self.imageEdgeInsets = UIEdgeInsetsMake(imgInsetPadding, imgInsetPadding,
                                            imgInsetPadding, imgInsetPadding);
    
    self.clipsToBounds = true;
    
    self.loadingIndicatorContainer = [[UIView alloc] initWithFrame:self.frame];
    self.loadingIndicatorContainer.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    self.loadingIndicatorContainer.backgroundColor = buttonGreenColor;
    
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.loadingIndicator.transform = CGAffineTransformMakeScale(0.75, 0.75);
    
    [self.loadingIndicatorContainer addSubview:self.loadingIndicator];
    [self addSubview:self.loadingIndicatorContainer];
    
    self.loadingIndicator.translatesAutoresizingMaskIntoConstraints = false;
    NSLayoutConstraint *xCenterConstraint = [NSLayoutConstraint constraintWithItem:self.loadingIndicatorContainer attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.loadingIndicator attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *yCenterConstraint = [NSLayoutConstraint constraintWithItem:self.loadingIndicatorContainer attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.loadingIndicator attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    [self.loadingIndicatorContainer addConstraints:@[xCenterConstraint, yCenterConstraint]];
    self.loadingIndicatorContainer.alpha = 0;
}

- (void)setEnabled:(BOOL)enabled {
    if (enabled) {
        self.backgroundColor = [[UIColor colorWithRed:(46.0f / 255.0f) green:(191.0f / 255.0f) blue:0 alpha:1] colorWithAlphaComponent:0.9f];
        [self setUserInteractionEnabled:true];
    }
    else {
        self.backgroundColor = [[UIColor colorWithRed:(204.0f / 255.0f) green:(204.0f / 255.0f) blue:(204.0f / 255.0f) alpha:1] colorWithAlphaComponent:0.9f];
        [self setUserInteractionEnabled:false];
    }
}

-(void)showLoadingIndicator{
    [self setImage: [UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self setTitle: @"" forState:UIControlStateNormal];
    self.loadingIndicatorContainer.alpha = 1;
    [self.loadingIndicator startAnimating];
}

-(void)hideLoadingIndicator{
    [self setImage: self.buttonImage forState:UIControlStateNormal];
    [self setTitle: self.buttonText forState:UIControlStateNormal];
    self.loadingIndicatorContainer.alpha = 0;
    [self.loadingIndicator stopAnimating];
}

@end

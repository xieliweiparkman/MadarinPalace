//
//  PMVerificationCodeLabel.m
//  ParkMan
//
//  Created by Xie Liwei on 11/06/2018.
//  Copyright © 2018 Teemu Poikela. All rights reserved.
//
#import "PMVerificationCodeLabel.h"

@implementation PMVerificationCodeLabel


- (void)setText:(NSString *)text{
    [super setText:text];
    [self setNeedsDisplay];
}

-(void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth ;
    [self setNeedsDisplay];
}

-(void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    [self setNeedsDisplay];
}

-(void)setSpacing:(CGFloat)spacing{
    _spacing = spacing;
    [self setNeedsDisplay];
}

-(void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    rect.size.width = rect.size.width > self.bounds.size.width ? self.bounds.size.width : rect.size.width;
    rect.size.height = rect.size.height > self.bounds.size.height ? self.bounds.size.height : rect.size.height;

    float width = (rect.size.width - (self.numberOfVerificationCode - 1) * self.spacing) / (float)self.numberOfVerificationCode;
    ;
    float height = rect.size.height;

    for (int i = 0; i < self.numberOfVerificationCode; i++) {
        CGRect tempRect = CGRectMake(i * (width + self.spacing) + self.lineWidth, CGRectGetMaxY(self.frame), width - self.lineWidth * 2, 2);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:tempRect cornerRadius:self.cornerRadius];
        CGContextAddPath(context, bezierPath.CGPath);
        CGContextStrokePath(context);
    }
    
    for (int i = 0; i < self.text.length; i++) {

        CGRect tempRect = CGRectMake(i * (width +self.spacing) +self.lineWidth, self.lineWidth, width - self.lineWidth * 2, height - self.lineWidth*2);
        NSString *charecterString = [NSString stringWithFormat:@"%c", [self.text characterAtIndex:i]];
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
        attributes[NSFontAttributeName] = self.font;
        attributes[NSForegroundColorAttributeName] = self.textColor;

        CGSize characterSize = [charecterString sizeWithAttributes:attributes];
        CGPoint vertificationCodeDrawStartPoint = CGPointMake(CGRectGetMidX(tempRect) - characterSize.width /2, CGRectGetMidY(tempRect) - characterSize.height /2);
        [charecterString drawAtPoint:vertificationCodeDrawStartPoint withAttributes:attributes];
    }
    
}

@end

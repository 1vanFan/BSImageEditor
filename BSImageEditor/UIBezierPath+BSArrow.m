//
//  UIBezierPath+BSArrow.m
//  WiseAPP
//
//  Created by 1vanFan on 2017/7/3.
//  Copyright © 2017年 SHYouChi. All rights reserved.
//

//  参考 github : NHArrowView

#import "UIBezierPath+BSArrow.h"

#define kArrowPointCount 7

@implementation UIBezierPath (BSArrow)

+ (UIBezierPath *)bezierPathWithArrowFromPoint:(CGPoint)tailPoint
                                       toPoint:(CGPoint)tipPoint
                                     lineWidth:(CGFloat)lineWidth {
    CGFloat width = lineWidth * LineWidthScale;
    
    return [self bezierPathWithArrowFromPoint:tailPoint
                                      toPoint:tipPoint
                                    tailWidth:width *1.5
                                    headWidth:width *3
                                   headLength:width *3];
}

+ (UIBezierPath *)bezierPathWithArrowFromPoint:(CGPoint)tailPoint
                                       toPoint:(CGPoint)tipPoint
                                     tailWidth:(CGFloat)tailWidth
                                     headWidth:(CGFloat)headWidth
                                    headLength:(CGFloat)headLength {
    CGFloat length = hypotf(tipPoint.x - tailPoint.x, tipPoint.y - tailPoint.y);
    
    CGPoint points[kArrowPointCount];
    [self getAxisAlignedArrowPoints:points
                          forLength:length
                          tailWidth:tailWidth
                          headWidth:headWidth
                         headLength:headLength];
    
    CGAffineTransform transform = [self transformForTailPoint:tailPoint
                                                     tipPoint:tipPoint
                                                       length:length];
    
    CGMutablePathRef cgPath = CGPathCreateMutable();
    CGPathAddLines(cgPath, &transform, points, sizeof points / sizeof *points);
    CGPathCloseSubpath(cgPath);
    
    UIBezierPath *uiPath = [UIBezierPath bezierPathWithCGPath:cgPath];
    CGPathRelease(cgPath);
    return uiPath;
}

+ (void)getAxisAlignedArrowPoints:(CGPoint[kArrowPointCount])points
                        forLength:(CGFloat)length
                        tailWidth:(CGFloat)tailWidth
                        headWidth:(CGFloat)headWidth
                       headLength:(CGFloat)headLength {
    CGFloat tailLength = length - headLength;
    points[0] = CGPointMake(0, 0);
    points[1] = CGPointMake(tailLength, tailWidth / 2);
    points[2] = CGPointMake(length - headLength *1.2, headWidth / 2);
    points[3] = CGPointMake(length, 0);
    points[4] = CGPointMake(length - headLength *1.2, -headWidth / 2);
    points[5] = CGPointMake(tailLength, -tailWidth / 2);
    points[6] = CGPointMake(0, 0);
}

+ (CGAffineTransform)transformForTailPoint:(CGPoint)tailPoint
                                  tipPoint:(CGPoint)tipPoint
                                    length:(CGFloat)length {
    CGFloat cosine = (tipPoint.x - tailPoint.x) / length;
    CGFloat sine = (tipPoint.y - tailPoint.y) / length;
    return (CGAffineTransform){ cosine, sine, -sine, cosine, tailPoint.x, tailPoint.y };
}

@end

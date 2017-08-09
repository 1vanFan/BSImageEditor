//
//  UIBezierPath+BSArrow.h
//  WiseAPP
//
//  Created by 1vanFan on 2017/7/3.
//  Copyright © 2017年 SHYouChi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LineWidthScale 1.5

@interface UIBezierPath (BSArrow)

/**
 通过头尾部坐标和线宽绘制箭头

 @param tailPoint 尾部坐标
 @param tipPoint  头部坐标
 @param lineWidth 尾部线宽度 放大一定倍数
 */
+ (UIBezierPath *)bezierPathWithArrowFromPoint:(CGPoint)tailPoint
                                       toPoint:(CGPoint)tipPoint
                                     lineWidth:(CGFloat)lineWidth;
@end

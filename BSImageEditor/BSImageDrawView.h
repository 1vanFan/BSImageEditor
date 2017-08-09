//
//  BSImageDrawView.h
//  WiseAPP
//
//  Created by 1vanFan on 2017/7/3.
//  Copyright © 2017年 SHYouChi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSImageItem.h"
#import "UIBezierPath+BSArrow.h"

@protocol BSImageDrawViewDelegate;

@interface BSImageDrawView : UIView

@property (nonatomic, weak) id <BSImageDrawViewDelegate> delegate;

@property (nonatomic, assign) BSImageType imageType;    //!< item类型
@property (nonatomic, assign) CGFloat lineWidth;        //!< 线宽
@property (nonatomic, assign) CGPoint recordPoint;      //!< 记录触摸点
@property (nonatomic, assign) CAShapeLayer *shapeLayer; //!< 绘制图形
@end

@protocol BSImageDrawViewDelegate <NSObject>

/**
 返回绘制的椭圆区域frame
 */
- (void)bs_imageDrawView:(BSImageDrawView *)drawView didDrawOvalInRect:(CGRect)rect;

/**
 返回绘制的箭头的两端坐标
 @param tailPoint 箭头尾部坐标
 @param tipPoint  箭头头部坐标
 */
- (void)bs_imageDrawView:(BSImageDrawView *)drawView didDrawArrowTailPoint:(CGPoint)tailPoint tipPoint:(CGPoint)tipPoint;
@end

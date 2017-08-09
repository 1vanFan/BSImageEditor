//
//  BSImageItem.h
//  WiseAPP
//
//  Created by 1vanFan on 2017/7/3.
//  Copyright © 2017年 SHYouChi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPointWH 8
#define kTouchWH 20

#define kWidthThin      2
#define kWidthDefault   4
#define kWidthThick     6

typedef NS_ENUM(NSInteger, BSImageType) {
    BSImageTypeOval,   //!< 椭圆
    BSImageTypeArrow   //!< 箭头
};

@protocol BSImageItemDelegate;
@interface BSImageItem : UIView

@property (nonatomic, weak) id <BSImageItemDelegate> delegate;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, assign) CGPoint recordPoint;
@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, assign) BOOL select; //!< 选中状态 被选中时显示触摸圆点

- (void)changeLineWidth:(CGFloat)width;
- (void)showEditPoints:(BOOL)show;
- (void)moveCenterHorizon:(CGFloat)x vertical:(CGFloat)y;
@end

@protocol BSImageItemDelegate <NSObject>

- (void)imageEditorSelectItem:(BSImageItem *)item;
@end

#pragma mark - Touch Point

@interface BSTouchPoint : UIView

@property (nonatomic, strong) UIImageView *pointImgV;
@end

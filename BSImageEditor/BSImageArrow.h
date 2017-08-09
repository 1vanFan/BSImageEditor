//
//  BSImageArrow.h
//  WiseAPP
//
//  Created by 1vanFan on 2017/7/3.
//  Copyright © 2017年 SHYouChi. All rights reserved.
//

#import "BSImageItem.h"

@interface BSImageArrow : BSImageItem

@property (nonatomic, assign) CGPoint arrowPoint;   //!< 箭头在父视图位置
@property (nonatomic, assign) CGPoint linePoint;    //!< 尾端在父视图位置

@property (nonatomic, assign) CGPoint tipPoint;     //!< 箭头在本视图位置
@property (nonatomic, assign) CGPoint tailPoint;    //!< 尾端在本视图位置

@property (nonatomic, strong) BSTouchPoint *tipView;    //!< 箭头触摸点
@property (nonatomic, strong) BSTouchPoint *tailView;   //!< 尾端触摸点

- (instancetype)initWithTailPoint:(CGPoint)tailPoint tipPoint:(CGPoint)tipPoint;
@end

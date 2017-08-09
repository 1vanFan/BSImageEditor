//
//  BSImageEditor.h
//  WiseAPP
//
//  Created by 1vanFan on 2017/7/3.
//  Copyright © 2017年 SHYouChi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BSImageEditorDelegate;

@interface BSImageEditor : UIViewController

/** 默认为YES，若设置为NO，则需要在代理中手动dismiss editor */
@property (nonatomic, assign) BOOL autoDismiss;

@property (nonatomic, weak) id <BSImageEditorDelegate> delegate;

/**
 初始化图片编辑器

 @param image 需要编辑的图片
 @param delegate 添加代理
 */
- (instancetype)initWithImage:(UIImage *)image delegate:(id<BSImageEditorDelegate>)delegate;
@end

@protocol BSImageEditorDelegate <NSObject>

@optional

/**
 当点击完成按钮时调用代理方法，返回经过编辑的图片
 */
- (void)bs_imageEditor:(BSImageEditor *)controller didFinishEditWithImage:(UIImage *)image;

/**
 当点击取消时调用代理方法
 */
- (void)bs_imageEditorDidCancel:(BSImageEditor *)controller;
@end

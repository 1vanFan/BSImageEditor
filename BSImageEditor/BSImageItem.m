//
//  BSImageItem.m
//  WiseAPP
//
//  Created by 1vanFan on 2017/7/3.
//  Copyright © 2017年 SHYouChi. All rights reserved.
//

#import "BSImageItem.h"
#import "UIImage+BSBundle.h"

@interface BSImageItem ()

@property (nonatomic, strong) UITapGestureRecognizer *tap;  //!< 点击选择item手势
@property (nonatomic, strong) UIPanGestureRecognizer *move; //!< item移动手势
@end

@implementation BSImageItem

#pragma mark - select

- (void)setSelect:(BOOL)select
{
    if (_select != select) {
        _select = select;
        
        // 展示操作用的点
        [self showEditPoints: select];
        
        // 非选中状态时 手势切换
        if (select) {
            [self removeGestureRecognizer: self.tap];
            [self addGestureRecognizer: self.move];
        }
        else {
            [self addGestureRecognizer: self.tap];
            [self removeGestureRecognizer: self.move];
        }
    }
}

- (void)showEditPoints:(BOOL)show
{
    for (BSTouchPoint *view in self.subviews) {
        view.hidden = !show;
    }
}

#pragma mark - line width

- (void)changeLineWidth:(CGFloat)width
{
    
}

#pragma mark - tap

// 点击选中
- (void)becomeSelected:(UITapGestureRecognizer *)sender
{
    if (self.select == NO) {
        if ([self.delegate respondsToSelector:@selector(imageEditorSelectItem:)]) {
            [self.delegate imageEditorSelectItem:self];
        }
    }
}

#pragma mark - move

// 移动图像位置
- (void)move:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        _recordPoint = [sender locationInView:self.superview];
    }
    else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint touchPoint = [sender locationInView:self.superview];
        
        self.center = CGPointMake(self.center.x + touchPoint.x - _recordPoint.x, self.center.y + touchPoint.y - _recordPoint.y);
        
        [self moveCenterHorizon:touchPoint.x - _recordPoint.x vertical:touchPoint.y - _recordPoint.y];
        
        _recordPoint = touchPoint;
    }
}

- (void)moveCenterHorizon:(CGFloat)x vertical:(CGFloat)y
{
    
}

#pragma mark - lazy loading

- (CAShapeLayer *)shapeLayer
{
    if (_shapeLayer == nil) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.backgroundColor = [UIColor clearColor].CGColor;
        layer.lineCap     = kCALineCapRound;
        layer.lineJoin    = kCALineJoinRound;
        layer.lineWidth   = self.lineWidth;
        _shapeLayer = layer;
    }
    return _shapeLayer;
}

- (UITapGestureRecognizer *)tap
{
    if (_tap == nil) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(becomeSelected:)];
    }
    return _tap;
}

- (UIPanGestureRecognizer *)move
{
    if (_move == nil) {
        _move = [[UIPanGestureRecognizer alloc ] initWithTarget:self action:@selector(move:)];
    }
    return _move;
}

- (CGFloat)lineWidth
{
    if (_lineWidth == 0) {
        _lineWidth = kWidthDefault;
    }
    return _lineWidth;
}

@end

@implementation BSTouchPoint

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pointImgV = [[UIImageView alloc] initWithImage:[UIImage bs_bundleImageNamed:@"touchPoint_blue"]];
        _pointImgV.bounds = CGRectMake(0, 0, kPointWH, kPointWH);
        [self addSubview:_pointImgV];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _pointImgV.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

@end

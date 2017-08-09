//
//  BSImageArrow.m
//  WiseAPP
//
//  Created by 1vanFan on 2017/7/3.
//  Copyright © 2017年 SHYouChi. All rights reserved.
//

#import "BSImageArrow.h"
#import "UIBezierPath+BSArrow.h"

@implementation BSImageArrow

#pragma mark - override

- (void)changeLineWidth:(CGFloat)width
{
    if (self.lineWidth != width) {
        self.lineWidth = width;
        self.shapeLayer.lineWidth = width;
        [self drawArrowShapeLayer];
    }
}

// 修复move操作带来的箭头两坐标点在父视图上的位置变化
- (void)moveCenterHorizon:(CGFloat)x vertical:(CGFloat)y
{
    _arrowPoint.x += x;
    _arrowPoint.y += y;
    
    _linePoint.x += x;
    _linePoint.y += y;
}

#pragma mark - init

- (instancetype)initWithTailPoint:(CGPoint)tailPoint tipPoint:(CGPoint)tipPoint
{
    self = [super init];
    if (self) {
        // 创建标识手势圆点
        [self setupPoints];
        
        // 根据坐标变更frame
        _arrowPoint = tipPoint;
        _linePoint  = tailPoint;
        [self refreshFrame];
        
        // 画出箭头
        [self drawArrowShapeLayer];
        self.shapeLayer.strokeColor = [UIColor clearColor].CGColor;
        self.shapeLayer.fillColor   = [UIColor redColor].CGColor;
        [self.layer addSublayer:self.shapeLayer];
        
        [self bringSubviewToFront:_tailView];
        [self bringSubviewToFront:_tipView];
    }
    
    return self;
}

- (void)setupPoints
{
    _tipView = [[BSTouchPoint alloc] init];
    [self addSubview:_tipView];
    UIPanGestureRecognizer *tipPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragTipPoint:)];
    [_tipView addGestureRecognizer:tipPan];
    
    _tailView = [[BSTouchPoint alloc] init];
    [self addSubview:_tailView];
    UIPanGestureRecognizer *tailPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragTailPoint:)];
    [_tailView addGestureRecognizer:tailPan];
}

- (void)refreshFrame
{
    CGFloat x = _linePoint.x < _arrowPoint.x?_linePoint.x:_arrowPoint.x;
    CGFloat y = _linePoint.y < _arrowPoint.y?_linePoint.y:_arrowPoint.y;
    CGFloat width = ABS(_linePoint.x - _arrowPoint.x);
    CGFloat height = ABS(_linePoint.y - _arrowPoint.y);
    self.frame = CGRectMake(x -kTouchWH/2, y-kTouchWH/2, width +kTouchWH, height +kTouchWH);
    
    if (_linePoint.x <= _arrowPoint.x && _linePoint.y <= _arrowPoint.y) {
        _tailPoint.x = kTouchWH/2;
        _tailPoint.y = kTouchWH/2;
        _tipPoint.x = kTouchWH/2 + width;
        _tipPoint.y = kTouchWH/2 + height;
        
        _tailView.frame = CGRectMake(0, 0, kTouchWH, kTouchWH);
        _tipView.frame = CGRectMake(self.frame.size.width - kTouchWH, self.frame.size.height -kTouchWH, kTouchWH, kTouchWH);
    }
    else if (_linePoint.x <= _arrowPoint.x && _linePoint.y > _arrowPoint.y) {
        _tailPoint.x = kTouchWH/2;
        _tailPoint.y = kTouchWH/2 +height;
        _tipPoint.x = kTouchWH/2 +width;
        _tipPoint.y = kTouchWH/2;
        
        _tailView.frame = CGRectMake(0, self.frame.size.height -kTouchWH, kTouchWH, kTouchWH);
        _tipView.frame = CGRectMake(self.frame.size.width - kTouchWH, 0, kTouchWH, kTouchWH);
    }
    else if (_linePoint.x > _arrowPoint.x && _linePoint.y <= _arrowPoint.y) {
        _tailPoint.x = kTouchWH/2 +width;
        _tailPoint.y = kTouchWH/2;
        _tipPoint.x  = kTouchWH/2;
        _tipPoint.y  = kTouchWH/2 +height;
        
        _tailView.frame = CGRectMake(self.frame.size.width - kTouchWH, 0, kTouchWH, kTouchWH);
        _tipView.frame = CGRectMake(0, self.frame.size.height -kTouchWH, kTouchWH, kTouchWH);
    }
    else {
        _tailPoint.x = kTouchWH/2 +width;
        _tailPoint.y = kTouchWH/2 +height;
        _tipPoint.x = kTouchWH/2;
        _tipPoint.y = kTouchWH/2;
        
        _tailView.frame = CGRectMake(self.frame.size.width - kTouchWH, self.frame.size.height -kTouchWH, kTouchWH, kTouchWH);
        _tipView.frame = CGRectMake(0, 0, kTouchWH, kTouchWH);
    }
}

- (void)drawArrowShapeLayer
{
    CGRect frame = self.frame;
    if (frame.size.width < kTouchWH) {
        frame.size.width = kTouchWH;
        self.frame = frame;
    }
    if (frame.size.height < kTouchWH) {
        frame.size.height = kTouchWH;
        self.frame = frame;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArrowFromPoint:_tailPoint toPoint:_tipPoint lineWidth:self.lineWidth];
    path.lineWidth = self.lineWidth;
    self.shapeLayer.path = path.CGPath;
}

#pragma mark - gesture

- (void)dragTipPoint:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateChanged) {
        
        _arrowPoint = [sender locationInView:self.superview];
        
        [self refreshFrame];
        [self drawArrowShapeLayer];
    }
}

- (void)dragTailPoint:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateChanged) {
        
        _linePoint = [sender locationInView:self.superview];
        
        [self refreshFrame];
        [self drawArrowShapeLayer];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  BSImageOval.m
//  WiseAPP
//
//  Created by 1vanFan on 2017/7/3.
//  Copyright © 2017年 SHYouChi. All rights reserved.
//

#import "BSImageOval.h"

@interface BSImageOval ()

@property (nonatomic, strong) BSTouchPoint *pointLT;
@property (nonatomic, strong) BSTouchPoint *pointRT;
@property (nonatomic, strong) BSTouchPoint *pointLB;
@property (nonatomic, strong) BSTouchPoint *pointRB;
@property (nonatomic, strong) BSTouchPoint *pointL;
@property (nonatomic, strong) BSTouchPoint *pointR;
@property (nonatomic, strong) BSTouchPoint *pointT;
@property (nonatomic, strong) BSTouchPoint *pointB;
@end

@implementation BSImageOval

#pragma mark - override

- (void)changeLineWidth:(CGFloat)width
{
    if (self.lineWidth != width && width != 0) {
        self.lineWidth = width;
        self.shapeLayer.lineWidth = width;
    }
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: CGRectMake(frame.origin.x -kTouchWH/2, frame.origin.y -kTouchWH/2, frame.size.width +kTouchWH, frame.size.height +kTouchWH)];
    if (self) {
        [self drawItemShapeLayer];
        
        self.shapeLayer.strokeColor = [UIColor redColor].CGColor;
        self.shapeLayer.fillColor   = [UIColor clearColor].CGColor;
        [self.layer addSublayer:self.shapeLayer];
        
        [self setupPoints];
    }
    return self;
}

// 绘制椭圆layer frame检测
- (void)drawItemShapeLayer
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
    [self refreshPointsFrame];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(kTouchWH/2, kTouchWH/2, frame.size.width -kTouchWH, frame.size.height -kTouchWH)];
    path.lineWidth = self.lineWidth;
    self.shapeLayer.path = path.CGPath;
}

- (void)refreshPointsFrame
{
    _pointLT.frame = CGRectMake(0, 0, kTouchWH, kTouchWH);
    _pointRT.frame = CGRectMake(self.frame.size.width - kTouchWH, 0, kTouchWH, kTouchWH);
    _pointLB.frame = CGRectMake(0, self.frame.size.height - kTouchWH, kTouchWH, kTouchWH);
    _pointRB.frame = CGRectMake(self.frame.size.width - kTouchWH, self.frame.size.height - kTouchWH, kTouchWH, kTouchWH);
    _pointL.center = CGPointMake(kTouchWH /2, self.frame.size.height/2);
    _pointR.center = CGPointMake(self.frame.size.width - kTouchWH /2, self.frame.size.height/2);
    _pointT.center = CGPointMake(self.frame.size.width/2, kTouchWH/2);
    _pointB.center = CGPointMake(self.frame.size.width/2, self.frame.size.height - kTouchWH/2);
}

// 创建触摸点
- (void)setupPoints
{
    // 左上
    _pointLT = [[BSTouchPoint alloc] init];
    [self addSubview: _pointLT];
    
    // 右上
    _pointRT = [[BSTouchPoint alloc] init];
    [self addSubview: _pointRT];
    
    // 左下
    _pointLB = [[BSTouchPoint alloc] init];
    [self addSubview: _pointLB];
    
    // 右下
    _pointRB = [[BSTouchPoint alloc] init];
    [self addSubview: _pointRB];
    
    // 上
    _pointT = [[BSTouchPoint alloc] init];
    _pointT.bounds = CGRectMake(0, 0, kTouchWH, kTouchWH);
    [self addSubview: _pointT];
    
    // 下
    _pointB = [[BSTouchPoint alloc] init];
    _pointB.bounds = CGRectMake(0, 0, kTouchWH, kTouchWH);
    [self addSubview: _pointB];
    
    // 左
    _pointL = [[BSTouchPoint alloc] init];
    _pointL.bounds = CGRectMake(0, 0, kTouchWH, kTouchWH);
    [self addSubview: _pointL];
    
    // 右
    _pointR = [[BSTouchPoint alloc] init];
    _pointR.bounds = CGRectMake(0, 0, kTouchWH, kTouchWH);
    [self addSubview: _pointR];
    
    UIPanGestureRecognizer *panLT = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(stretchCorner:)];
    [_pointLT addGestureRecognizer:panLT];
    UIPanGestureRecognizer *panRT = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(stretchCorner:)];
    [_pointRT addGestureRecognizer:panRT];
    UIPanGestureRecognizer *panLB = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(stretchCorner:)];
    [_pointLB addGestureRecognizer:panLB];
    UIPanGestureRecognizer *panRB = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(stretchCorner:)];
    [_pointRB addGestureRecognizer:panRB];
    
    UIPanGestureRecognizer *panL = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(stretchHorizon:)];
    [_pointL addGestureRecognizer:panL];
    UIPanGestureRecognizer *panR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(stretchHorizon:)];
    [_pointR addGestureRecognizer:panR];
    UIPanGestureRecognizer *panT = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(stretchVertical:)];
    [_pointT addGestureRecognizer:panT];
    UIPanGestureRecognizer *panB = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(stretchVertical:)];
    [_pointB addGestureRecognizer:panB];
    
    [self refreshPointsFrame];
}

#pragma mark - gesture

- (void)stretchCorner:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateChanged) {
        
        CGPoint touchPoint = [sender locationInView:self.superview];
        // 触摸点在view中为缩放 不在则为拉伸
        CGFloat maxX = CGRectGetMaxX(self.frame);
        CGFloat maxY = CGRectGetMaxY(self.frame);
        CGFloat x = self.frame.origin.x;
        CGFloat y = self.frame.origin.y;
        
        if (touchPoint.x >= self.center.x && touchPoint.y < self.center.y) {
            // 第一象限
            self.frame = CGRectMake(x, touchPoint.y, touchPoint.x - x, maxY - touchPoint.y);
        }
        else if (touchPoint.x < self.center.x && touchPoint.y < self.center.y) {
            // 第二象限
            self.frame = CGRectMake(touchPoint.x, touchPoint.y, maxX - touchPoint.x, maxY - touchPoint.y);
        }
        else if (touchPoint.x < self.center.x && touchPoint.y >= self.center.y) {
            // 第三象限
            self.frame = CGRectMake(touchPoint.x, y, maxX - touchPoint.x, touchPoint.y - y);
        }
        else {
            // 第四象限
            self.frame = CGRectMake(x, y, touchPoint.x - x, touchPoint.y - y);
        }
        
        [self drawItemShapeLayer];
    }
}

- (void)stretchHorizon:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateChanged) {
        
        CGPoint touchPoint = [sender locationInView:self.superview];
        if (CGRectContainsPoint(self.frame, touchPoint)) {
            // 缩小
            if (touchPoint.x < self.center.x) {
                //左边往内
                self.frame = CGRectMake(touchPoint.x, self.frame.origin.y, CGRectGetMaxX(self.frame) - touchPoint.x, self.frame.size.height);
            }
            else {
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, (touchPoint.x - self.frame.origin.x), self.frame.size.height);
            }
        }
        else {
            // 放大
            if (touchPoint.x < self.center.x) {
                //往左放大
                self.frame = CGRectMake(touchPoint.x, self.frame.origin.y, CGRectGetMaxX(self.frame) - touchPoint.x, self.frame.size.height);
            }
            else {
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, touchPoint.x - self.frame.origin.x, self.frame.size.height);
            }
        }
        [self drawItemShapeLayer];
    }
}

- (void)stretchVertical:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateChanged) {
        
        CGPoint touchPoint = [sender locationInView:self.superview];
        if (CGRectContainsPoint(self.frame, touchPoint)) {
            // 缩小
            if (touchPoint.y < self.center.y) {
                //上方往内
                self.frame = CGRectMake(self.frame.origin.x, touchPoint.y, self.frame.size.width, CGRectGetMaxY(self.frame) - touchPoint.y);
            }
            else {
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, touchPoint.y - self.frame.origin.y);
            }
        }
        else {
            // 放大
            if (touchPoint.y < self.center.y) {
                //往上放大
                self.frame = CGRectMake(self.frame.origin.x, touchPoint.y, self.frame.size.width , CGRectGetMaxY(self.frame) - touchPoint.y);
            }
            else {
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, touchPoint.y - self.frame.origin.y);
            }
        }
        [self drawItemShapeLayer];
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

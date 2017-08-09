//
//  BSImageDrawView.m
//  WiseAPP
//
//  Created by 1vanFan on 2017/7/3.
//  Copyright © 2017年 SHYouChi. All rights reserved.
//

#import "BSImageDrawView.h"

@implementation BSImageDrawView

- (CGPoint)pointWithTouches:(NSSet *)touches
{
    return [[touches anyObject] locationInView:self];
}

#pragma mark - event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 获取当前触摸点
    _recordPoint = [self pointWithTouches:touches];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.backgroundColor = [UIColor clearColor].CGColor;
    if (_imageType == BSImageTypeOval) {
        layer.strokeColor = [UIColor redColor].CGColor;
        layer.fillColor   = [UIColor clearColor].CGColor;
    } else if(_imageType == BSImageTypeArrow){
        layer.fillColor = [UIColor redColor].CGColor;
    }
    
    layer.lineCap     = kCALineCapRound;
    layer.lineJoin    = kCALineJoinRound;
    layer.lineWidth   = self.lineWidth;
    [self.layer addSublayer:layer];
    self.shapeLayer = layer;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 获取当前触摸点
    CGPoint touchPoint = [self pointWithTouches:touches];
    if (CGPointEqualToPoint(_recordPoint, touchPoint)) {
        return;
    }
    
    if (_imageType == BSImageTypeOval) {
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_recordPoint.x, _recordPoint.y, touchPoint.x - _recordPoint.x, touchPoint.y - _recordPoint.y)];
        path.lineWidth = self.lineWidth;
        _shapeLayer.path = path.CGPath;
    }
    else if(_imageType == BSImageTypeArrow) {
        UIBezierPath *path = [UIBezierPath bezierPathWithArrowFromPoint:_recordPoint toPoint:touchPoint lineWidth:self.lineWidth];
        path.lineWidth = self.lineWidth;
        self.shapeLayer.path = path.CGPath;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_shapeLayer removeFromSuperlayer];
    
    CGPoint touchPoint = [self pointWithTouches:touches];
    
    if (_imageType == BSImageTypeOval) {
        if ([self.delegate respondsToSelector:@selector(bs_imageDrawView:didDrawOvalInRect:)]) {
            
            CGFloat x = _recordPoint.x < touchPoint.x?_recordPoint.x:touchPoint.x;
            CGFloat y = _recordPoint.y < touchPoint.y?_recordPoint.y:touchPoint.y;
            CGFloat width = ABS(_recordPoint.x - touchPoint.x);
            CGFloat height = ABS(_recordPoint.y - touchPoint.y);
            
            [self.delegate bs_imageDrawView:self didDrawOvalInRect:CGRectMake(x, y, width, height)];
        }
    }
    else if(_imageType == BSImageTypeArrow) {
        if ([self.delegate respondsToSelector:@selector(bs_imageDrawView:didDrawArrowTailPoint:tipPoint:)]) {
            [self.delegate bs_imageDrawView:self didDrawArrowTailPoint:_recordPoint tipPoint:touchPoint];
        }
    }
}

#pragma mark - lazy loading

- (CGFloat)lineWidth
{
    if (_lineWidth == 0) {
        _lineWidth = kWidthDefault;
    }
    return _lineWidth;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

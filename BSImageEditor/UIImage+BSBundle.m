//
//  UIImage+BSBundle.m
//  WiseAPP
//
//  Created by 范宝珅 on 2017/8/2.
//  Copyright © 2017年 SHYouChi. All rights reserved.
//

#import "UIImage+BSBundle.h"

@implementation UIImage (BSBundle)
+ (UIImage *)bs_bundleImageNamed:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:[@"BSImageEditor.bundle" stringByAppendingPathComponent:name]];
    if (image) {
        return image;
    } else {
        image = [UIImage imageNamed:[@"Frameworks/BSImageEditor.framework/Assets/BSImageEditor.bundle" stringByAppendingPathComponent:name]];
        if (!image) {
            image = [UIImage imageNamed:name];
        }
        return image;
    }
}
@end

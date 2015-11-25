//
//  Tool.m
//  ProxiFinal
//
//  Created by Michael Liu on 10/11/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "Tool.h"

@implementation Tool
+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)resize

{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(resize.width, resize.height), NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, resize.width, resize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}


@end

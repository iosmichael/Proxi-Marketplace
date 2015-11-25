//
//  Tool.h
//  ProxiFinal
//
//  Created by Michael Liu on 10/11/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Tool : NSObject
+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)resize;
@end

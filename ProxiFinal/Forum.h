//
//  Forum.h
//  ProxiFinal
//
//  Created by Michael Liu on 3/6/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Forum : NSObject
@property (strong,nonatomic) NSString *forum_title;
@property (strong,nonatomic) NSString *forum_email;
@property (strong,nonatomic) NSString *forum_description;
@property (strong,nonatomic) NSString *forum_time;

-(instancetype)initWithTitle:(NSString *)forum_title Email:(NSString *)forum_email Description:(NSString *)forum_description Time:(NSString *)forum_time;
@end

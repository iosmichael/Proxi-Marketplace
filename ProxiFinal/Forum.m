//
//  Forum.m
//  ProxiFinal
//
//  Created by Michael Liu on 3/6/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import "Forum.h"

@implementation Forum
-(instancetype)initWithTitle:(NSString *)forum_title Email:(NSString *)forum_email Description:(NSString *)forum_description Time:(NSString *)forum_time{
    self = [super init];
    if (self) {
        self.forum_title = forum_title;
        self.forum_email = forum_email;
        self.forum_description = forum_description;
        self.forum_time = forum_time;
    }
    return self;
}
@end

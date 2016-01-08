//
//  Event.m
//  ProxiFinal
//
//  Created by Michael Liu on 1/2/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import "Event.h"

@implementation Event

-(instancetype)initWithTitle:(NSString *)title time:(NSString *)time url:(NSString *)url image:(NSString *)img_url{
    self = [super init];
    if (self) {
        self.title = title;
        self.time = time;
        self.url = url;
        self.img_url = img_url;
    }
    return self;
}

@end

//
//  Store.m
//  ProxiFinal
//
//  Created by Michael Liu on 1/30/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import "Store.h"

@implementation Store
-(instancetype)initWithID:(NSString *)store_id name:(NSString *)store_name time:(NSString *)store_open_time owner:(NSString *)store_operator location:(NSString *)store_location status:(NSString *)store_status{
    
    self = [super init];
    if (self) {
        self.store_id = store_id;
        self.store_open_time = store_open_time;
        self.store_operator = store_operator;
        self.store_location = store_location;
        self.store_status = store_status;
        self.store_name = store_name;
    }
    return self;
}

@end

//
//  User.m
//  ProxiFinal
//
//  Created by Michael Liu on 10/10/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "User.h"

@implementation User

-(instancetype)initWithID:(NSString *)userID email:(NSString *)email password:(NSString *)password phone:(NSString *)phone{
    self = [super init];
    if (self) {
        self.userID = userID;
        self.email = email;
        self.password = password;
        self.phone = phone;
    }
    
    return self;
    
}


-(instancetype)initWithEmail:(NSString *)email password:(NSString *)password{
    self = [super init];
    if (self) {
        self.email = email;
        self.password = password;
    }
    return self;
}



@end

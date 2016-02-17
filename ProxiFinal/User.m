//
//  User.m
//  ProxiFinal
//
//  Created by Michael Liu on 10/10/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "User.h"

@implementation User


-(instancetype)initWithEmail:(NSString *)email firstName:(NSString *)firstName lastName:(NSString *)lastName password:(NSString *)password phone:(NSString *)phone dateOfBirth:(NSString *)dateOfBirth {
    self = [super init];
    if (self) {
        self.email = email;
        self.password = password;
        self.phone = phone;
        self.dateOfBirth = dateOfBirth;
        self.firstName = firstName;
        self.lastName =lastName;
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

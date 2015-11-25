//
//  User.h
//  ProxiFinal
//
//  Created by Michael Liu on 10/10/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *email;
@property (strong,nonatomic) NSString *password;
@property (strong,nonatomic) NSString *userID;
@property (strong,nonatomic) NSString *phone;

-(instancetype)initWithID:(NSString *)userID email:(NSString *)email password:(NSString *)password phone:(NSString *)phone;

-(instancetype)initWithEmail:(NSString *)email password:(NSString *)password;
@end

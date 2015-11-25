//
//  UserConnection.h
//  ProxiFinal
//
//  Created by Michael Liu on 10/17/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "User.h"

@interface UserConnection : NSObject

@property (strong,nonatomic) AFHTTPRequestOperationManager *manager;

-(instancetype)init;


-(void)registeredUserInfo: (User *)user image:(NSData *)userImage;
-(void)registeredUserInfo:(User *)user;
-(void)loginUserInfo:(User *)user;
-(void)fetchSellerInfo: (NSString *)sellerEmail;
-(void)fetchSellerImage: (NSString *)sellerID;
@end

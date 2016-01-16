//
//  UserConnection.m
//  ProxiFinal
//
//  Created by Michael Liu on 10/17/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "UserConnection.h"

#define address @"https://proximarketplace.com/database/index.php"
@implementation UserConnection

-(instancetype)init{
    self = [super init];
    if (self) {
        self.manager = [[AFHTTPRequestOperationManager alloc]init];
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}

-(void)registeredUserInfo:(User *)user{
    NSDictionary *param =@{
                           @"email":user.email,
                           @"password":user.password,
                           @"firstName":user.firstName,
                           @"lastName":user.lastName,
                           @"phone":user.phone,
                           @"venmoEmail":user.venmoEmail,
                           @"dateOfBirth":user.dateOfBirth
                           };
    NSLog(@"%@",[param description]);
    NSDictionary *param2 = @{
                             @"object":@"User",
                             @"method":@"register",
                             @"data":param
                             };
    [self.manager POST:address parameters:param2 constructingBodyWithBlock:nil
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *response = responseObject;
        NSString *responseString = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"%@",[responseString description]);
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RegisterPassNotification" object:responseString];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RegisterFailNotification" object:nil];
    }];
    
}




-(void)loginUserInfo:(User *)user{
    NSDictionary *param =@{
                           @"email":user.email,
                           @"password":user.password
                           };
    NSDictionary *param2 = @{
                             @"object":@"User",
                             @"method":@"login",
                             @"data":param
                             };
    
    [self.manager POST:address parameters:param2 constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *response = responseObject;
        NSString *responseString = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"LoginPassNotification" object:responseString];
        
        NSLog(@"%@",[responseString description]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"LoginErrorNotification" object:nil];
        NSLog(@"%@",[error description]);
    }];
}

-(void)fetchSellerInfo:(NSString *)sellerEmail{
    NSDictionary *param = @{
                            @"email":sellerEmail
                            };
    NSDictionary *param2 = @{
                             @"object":@"User",
                             @"method":@"userInfo",
                             @"data":param
                             };
    [self.manager POST:address parameters:param2 constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *responseData = responseObject;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ReceiveSellerInfo" object:json];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error description]);
    }];
}

-(void)retrievePassword:(NSString *)userEmail phone:(NSString *)userPhone{
    NSDictionary *param = @{
                            @"email":userEmail,
                            @"phone":userPhone
                            };
    NSDictionary *param2 = @{
                             @"object":@"User",
                        @"method":@"retrievePassword",
                             @"data":param
                             };
    [self.manager POST:address parameters:param2 constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *responseData = responseObject;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RetrievePasswordNotification" object:json];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error description]);
    }];
}




@end

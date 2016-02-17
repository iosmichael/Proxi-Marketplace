//
//  StoreConnection.m
//  ProxiFinal
//
//  Created by Michael Liu on 1/30/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import "StoreConnection.h"
#define address @"https://www.proximarketplace.com/database/index.php"

@implementation StoreConnection

-(instancetype)init{
    self = [super init];
    if (self) {
        self.manager = [[AFHTTPRequestOperationManager alloc]init];
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}

-(void)fetchStores{
    
    NSDictionary *param2 = @{
                             @"object":@"Store",
                             @"method":@"fetchStores",
                             @"data":@"",
                             };
    [self.manager POST:address parameters:param2 constructingBodyWithBlock:nil
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   NSData *response = responseObject;
                   
                   NSString *responseString = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
                   NSLog(@"%@",[responseString description]);
                   NSArray *json  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
                   [[NSNotificationCenter defaultCenter]postNotificationName:@"StoreNotification" object:json];
                   
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   
               }];
    
}


@end

//
//  EventConnection.m
//  ProxiFinal
//
//  Created by Michael Liu on 1/2/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import "EventConnection.h"

#define address @"https://www.proximarketplace.com/database/index.php"

@implementation EventConnection
-(instancetype)init{
    self = [super init];
    if (self) {
        self.manager = [[AFHTTPRequestOperationManager alloc]init];
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}

-(void)fetchEvents{

    NSDictionary *param2 = @{
                             @"object":@"Event",
                             @"method":@"fetchEvents",
                             @"data":@"event"
                             };
    [self.manager POST:address parameters:param2 constructingBodyWithBlock:nil
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   NSData *response = responseObject;

                   NSString *responseString = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
                   NSLog(@"%@",[responseString description]);
                   NSArray *json  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
                   [[NSNotificationCenter defaultCenter]postNotificationName:@"EventNotification" object:json];
                   
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   
               }];
    
}

@end

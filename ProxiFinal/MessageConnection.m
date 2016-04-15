//
//  MessageConnection.m
//  ProxiFinal
//
//  Created by Michael Liu on 3/11/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import "MessageConnection.h"
#define address @"https://www.proximarketplace.com/database/push_code/pushnotification.php"
@implementation MessageConnection
-(instancetype)init{
    self = [super init];
    if (self) {
        self.manager = [[AFHTTPRequestOperationManager alloc]init];
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}

-(void)sendNotification:(NSString *)receiver{
    NSLog(@"Send Notification!");
    NSDictionary *param = @{
                             @"receive":receiver
                             };
    NSLog(@"Notification to: %@",receiver);
    [self.manager POST:address parameters:param constructingBodyWithBlock:nil
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   NSData *response = responseObject;
                   NSString *str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
                   NSLog(@"Response: %@",str);
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   
               }];
    
}
@end

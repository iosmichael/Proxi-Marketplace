//
//  OrderConnection.m
//  ProxiFinal
//
//  Created by Michael Liu on 10/31/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "OrderConnection.h"
#define address @"http://proximarketplace.com/database/index.php"

@implementation OrderConnection

-(void)postOrder:(NSString *)user_email item:(Item *)item messageToSeller:(NSString *)message{
    NSDictionary *param = @{
                            @"user_email":user_email,
                            @"item_id":item.item_id,
                            @"message":message
                            };
    NSDictionary *param2 = @{
                             @"object":@"Transaction",
                             @"method":@"checkout",
                             @"data":param
                             };
    
    AFHTTPRequestOperationManager *manager= [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    
    [manager POST:address parameters:param2 constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSData *data = responseObject;
        NSString *dataDescription  = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",[dataDescription description]);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CheckoutNotification" object:dataDescription];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"this is an Error");
        NSLog(@"%@",[error description]);
    }];

}

-(void)dropOrder:(NSString *)item_id{
    NSDictionary *param = @{
                            @"item_id":item_id
                            };
    NSDictionary *param2 = @{
                             @"object":@"Transaction",
                             @"method":@"cancelOrder",
                             @"data":param
                             };
    
    AFHTTPRequestOperationManager *manager= [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    
    [manager POST:address parameters:param2 constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSData *data = responseObject;
        NSString *dataDescription  = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",[dataDescription description]);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CancelOrderNotification" object:dataDescription];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"this is an Error");
        NSLog(@"%@",[error description]);
    }];

}

-(void)finishCheckOut:(NSString *)item_id{
    
    NSDictionary *param = @{
                            @"item_id":item_id
                            };
    NSDictionary *param2 = @{
                             @"object":@"Transaction",
                             @"method":@"finish",
                             @"data":param
                             };
    
    AFHTTPRequestOperationManager *manager= [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    
    [manager POST:address parameters:param2 constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSData *data = responseObject;
        NSString *dataDescription  = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",[dataDescription description]);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"FinishCheckoutNotification" object:dataDescription];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"this is an Error");
        NSLog(@"%@",[error description]);
    }];
    
}

@end

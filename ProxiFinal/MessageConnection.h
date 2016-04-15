//
//  MessageConnection.h
//  ProxiFinal
//
//  Created by Michael Liu on 3/11/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface MessageConnection : NSObject
@property (strong,nonatomic) AFHTTPRequestOperationManager *manager;


-(instancetype)init;
-(void)sendNotification:(NSString *)receiver;
@end

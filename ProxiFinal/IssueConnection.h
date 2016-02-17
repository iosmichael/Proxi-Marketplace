//
//  IssueConnection.h
//  ProxiFinal
//
//  Created by Michael Liu on 1/16/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface IssueConnection : NSObject
-(void)reportSend:(NSString *)reportDetail fromUser:(NSString *)username;
-(void)passwordChange:(NSString *)oldPassword andNew:(NSString *)newPassword;
-(void)accountChange:(NSString *)phoneNumber password:(NSString *)password venmoAccount:(NSString *)venmoAccount fromUser:(NSString *)user;
@end

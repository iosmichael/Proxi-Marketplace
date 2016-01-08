//
//  EventConnection.h
//  ProxiFinal
//
//  Created by Michael Liu on 1/2/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "Event.h"

@interface EventConnection : NSObject
@property (strong,nonatomic) AFHTTPRequestOperationManager *manager;

-(instancetype)init;
-(void)fetchEvents;

@end

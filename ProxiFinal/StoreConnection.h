//
//  StoreConnection.h
//  ProxiFinal
//
//  Created by Michael Liu on 1/30/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface StoreConnection : NSObject
@property (strong,nonatomic) AFHTTPRequestOperationManager *manager;

-(instancetype)init;
-(void)fetchStores;
@end

//
//  Store.h
//  ProxiFinal
//
//  Created by Michael Liu on 1/30/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Store : NSObject
@property (strong,nonatomic) NSString *store_id;
@property (strong,nonatomic) NSString *store_location;
@property (strong,nonatomic) NSString *store_operator;
@property (strong,nonatomic) NSString *store_open_time;
@property (strong,nonatomic) NSString *store_status;
@property (strong,nonatomic) NSString *store_name;

-(instancetype)initWithID:(NSString *)store_id name:(NSString *)store_name time:(NSString *)store_open_time owner:(NSString *)store_operator location: (NSString *)store_location status:(NSString *)store_status;

@end

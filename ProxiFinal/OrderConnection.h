//
//  OrderConnection.h
//  ProxiFinal
//
//  Created by Michael Liu on 10/31/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "Item.h"

@interface OrderConnection : NSObject
-(void)postOrder:(NSString *)user_email item:(Item *)item messageToSeller:(NSString *)message paymentMethodNonce:(NSString *)paymentMethodNonce;
-(void)dropOrder:(NSString *)item_id;
-(void)finishCheckOut:(NSString *)item_id;
-(void)refund:(NSString *)item_id;

@end

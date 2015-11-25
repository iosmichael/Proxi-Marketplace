//
//  Order.h
//  ProxiFinal
//
//  Created by Michael Liu on 11/1/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject
@property (strong,nonatomic) NSString *order_id;
@property (strong,nonatomic) NSString *item_id;
@property (strong,nonatomic) NSString *user_id;
@property (strong,nonatomic) NSString *order_date;
@property (strong,nonatomic) NSString *order_price;
@property (strong,nonatomic) NSString *item_img_url;
@property (strong,nonatomic) NSString *item_title;
@property (strong,nonatomic) NSString *item_description;
@property (strong,nonatomic) NSData *img_data;

-(instancetype)initWithItem:(NSString *)item_id user:(NSString *)user_id orderID:(NSString *)order_id orderDate:(NSString *)orderDate orderPrice:(NSString *)orderPrice item_img_url:(NSString *)item_img_url item_title:(NSString *)item_title item_description:(NSString *)item_description;

@end

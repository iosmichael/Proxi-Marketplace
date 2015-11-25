//
//  Order.m
//  ProxiFinal
//
//  Created by Michael Liu on 11/1/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "Order.h"
#define Image_url_prefix @"http://proximarketplace.com/database/images/"

@implementation Order

-(instancetype)initWithItem:(NSString *)item_id user:(NSString *)user_id orderID:(NSString *)order_id orderDate:(NSString *)orderDate orderPrice:(NSString *)orderPrice item_img_url:(NSString *)item_img_url item_title:(NSString *)item_title item_description:(NSString *)item_description{
    self = [super init];
    if (self) {
        self.order_id = order_id;
        self.item_id = item_id;
        self.user_id = user_id;
        self.order_date = orderDate;
        self.order_price = orderPrice;
        self.item_img_url = item_img_url;
        self.item_title = item_title;
        self.item_description = item_description;
        if (self.item_img_url) {
            
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                
                NSError *error;
                NSString *urlString =[Image_url_prefix stringByAppendingString:self.item_img_url];
                NSURL *url = [NSURL URLWithString:urlString];
                self.img_data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
                if (error) {
                    NSLog(@"%@",[error description]);
                }
                [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshTableNotification" object:nil];
            });
        }
    }
    return self;
}

@end

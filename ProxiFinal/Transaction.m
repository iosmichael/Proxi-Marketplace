//
//  Transaction.m
//  ProxiFinal
//
//  Created by Michael Liu on 11/8/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "Transaction.h"

@implementation Transaction
-(instancetype)initWith:(NSString *)item_title date:(NSString *)bought_date price:(NSString *)item_price{
    self = [super init];
    if (self) {
        self.item_title = item_title;
        self.item_price = item_price;
        self.bought_date = bought_date;
    }
    return self;
}
@end

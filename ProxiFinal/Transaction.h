//
//  Transaction.h
//  ProxiFinal
//
//  Created by Michael Liu on 11/8/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transaction : NSObject
@property (strong,nonatomic) NSString *item_title;
@property (strong,nonatomic) NSString *bought_date;
@property (strong,nonatomic) NSString *item_price;
@property (strong,nonatomic) NSString *transaction_status;

-(instancetype)initWith:(NSString *)item_title date:(NSString *)bought_date price:(NSString *)item_price status:(NSString *)status;


@end

//
//  Item.h
//  ProxiFinal
//
//  Created by Michael Liu on 10/10/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^itemFetchBlock)(NSData *data);

@interface Item : NSObject

@property (strong,nonatomic) NSString *item_title;
@property (strong,nonatomic) NSString *item_description;
@property (nonatomic) NSString *item_id;
@property (nonatomic) NSString *price_current;
@property (nonatomic) NSString *price_high;
@property (nonatomic) NSString *price_low;
@property (nonatomic) NSString *userID;
@property (strong,nonatomic) NSString *date;
@property (strong,nonatomic) NSString *user_email;
@property (strong,nonatomic) NSString *category;
@property (strong,nonatomic) NSString *image_url;
@property (strong,nonatomic) NSData *image;



@property (strong,nonatomic) NSDictionary *dataBundle;
@property (copy) itemFetchBlock blockProperty;


-(instancetype)initWithTitle:(NSString *)title description:(NSString *)description userID:(NSString *)userID image:(NSData *)image date:(NSString *)date itemID:(NSString *)itemID price:(NSString *)price image_url:(NSString *)image_url;
-(instancetype)initWithID:(NSString *)item_id;

-(instancetype)initWithTitle:(NSString *)title description:(NSString *)description userEmail:(NSString *)userEmail image:(NSData *)image date:(NSString *)date itemID:(NSString *)itemID price:(NSString *)price;

-(instancetype)initWithTitle:(NSString *)title description:(NSString *)description userEmail:(NSString *)userEmail image:(NSData *)image date:(NSString *)date itemID:(NSString *)itemID price: (NSString *)price category:(NSString *)category;

@end

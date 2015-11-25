//
//  Item.m
//  ProxiFinal
//
//  Created by Michael Liu on 10/10/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "Item.h"
#define Image_url_prefix @"http://proximarketplace.com/database/images/"
@implementation Item
-(instancetype)initWithTitle:(NSString *)title description:(NSString *)description userID:(NSString *)userID image:(NSData *)image date:(NSString *)date itemID:(NSString *)itemID price: (NSString *)price image_url:(NSString *)image_url{
    self = [super init];
    if (self) {
        self.item_title = title;
        self.item_description = description;
        self.userID = userID;
        self.image = image;
        self.date = date;
        self.item_id = itemID;
        self.price_current = price;
        self.image_url =image_url;
        if (self.image_url) {
            
            dispatch_async(dispatch_get_global_queue(0,0), ^{

                NSError *error;
                NSString *urlString =[Image_url_prefix stringByAppendingString:self.image_url];
                NSURL *url = [NSURL URLWithString:urlString];
                self.image = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
                if (error) {
                    NSLog(@"%@",[error description]);
                }
                [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshTableNotification" object:nil];
            });
        }
    }

        //more data
    
    return self;
}




-(instancetype)initWithID:(NSString *)item_id{
    self= [super init];
    if (self) {
        self.item_id = item_id;
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title description:(NSString *)description userEmail:(NSString *)userEmail image:(NSData *)image date:(NSString *)date itemID:(NSString *)itemID price: (NSString *)price{
    self = [super init];
    if (self) {
        self.item_title = title;
        self.item_description = description;
        self.user_email = userEmail;
        self.image = image;
        self.date = date;
        self.item_id = itemID;
        self.price_current = price;
        //more data
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title description:(NSString *)description userEmail:(NSString *)userEmail image:(NSData *)image date:(NSString *)date itemID:(NSString *)itemID price: (NSString *)price category:(NSString *)category{
    self = [super init];
    if (self) {
        self.item_title = title;
        self.item_description = description;
        self.user_email = userEmail;
        self.image = image;
        self.date = date;
        self.item_id = itemID;
        self.price_current = price;
        self.category = category;
        //more data
    }
    return self;
}



@end

//
//  ItemContainer.m
//  ProxiFinal
//
//  Created by Michael Liu on 10/10/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "ItemContainer.h"
#import "ItemConnection.h"

@implementation ItemContainer
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.container = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)addItem:(Item *)item{
    [self.container addObject:item];
}

-(NSArray *)allItem{
    return (NSArray *)[self.container copy];
}

-(void)addItemsFromJSONDictionaries:(NSArray *)json
{
    for (NSDictionary *dic in json) {
        NSString *itemID = dic[@"item_id"];
        NSString *itemAmount = dic[@"item_price"];
        NSString *itemName = dic[@"item_title"];
        NSString *itemDescription = dic[@"item_description"];
        NSString *sellerID = dic[@"user_id"];
        NSString *date = dic[@"item_date"];
        NSString *image_url = dic[@"item_img_url"];
        Item *newItem = [[Item alloc]initWithTitle:itemName description:itemDescription userID:sellerID image:nil date:date itemID:itemID price:itemAmount image_url:image_url];
        if ([dic[@"item_status"]isEqualToString:@"unordered "]) {
                 [self addItem:newItem];
        }
    }
}



-(void)fetchItemsFromDatabase:(NSInteger)numberOfItems offset:(NSInteger)offset{
    ItemConnection *connection = [[ItemConnection alloc]init];
    [connection fetchItemFromIndex:offset amount:numberOfItems];

}


-(void)fetchItemsFromDatabaseWithCategoryName:(NSString *)categoryName number:(NSInteger)numberOfItems {
    ItemConnection *connection = [[ItemConnection alloc]init];
    [connection fetchItemsByCategory:categoryName amount:numberOfItems];
    
}

-(void)addItemImageFromDatabase:(Item *)item{
    ItemConnection *connection = [[ItemConnection alloc]init];
    [connection fetchItemImageWithItem:item];
}


@end

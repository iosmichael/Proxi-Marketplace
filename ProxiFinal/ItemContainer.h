//
//  ItemContainer.h
//  ProxiFinal
//
//  Created by Michael Liu on 10/10/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface ItemContainer : NSObject


@property (strong,nonatomic) NSMutableArray *container;

-(instancetype)init;
-(void)addItem:(Item *)item;
-(NSArray *)allItem;
-(void)addItemsFromJSONDictionaries: (NSArray *)json;
-(void)fetchItemsFromDatabase:(NSInteger)numberOfItems offset:(NSInteger)offset;
-(void)fetchItemsFromDatabaseWithCategoryName:(NSString *)categoryName number:(NSInteger)numberOfItems;

@end

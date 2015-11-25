//
//  ItemConnection.h
//  ProxiFinal
//
//  Created by Michael Liu on 10/17/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "Item.h"

@interface ItemConnection : NSObject

-(void)postItemData: (Item *)newItem;
-(void)fetchItemFromIndex:(NSInteger)indexOfItems amount:(NSInteger)numberOfItems;
-(void)fetchItemImageWithItem:(Item *)item;
-(void)fetchItemsFromIndex:(NSInteger)indexOfItems amount:(NSInteger)numberOfItems;
-(void)fetchItemsByName:(NSString *)searchName FromIndex:(NSInteger)indexOfItems amount:(NSInteger)numberOfItems;
-(void)fetchItemsByCategory:(NSString *)searchCategory amount:(NSInteger)numberOfItems;
-(void)myItems:(NSString *)user_email FromIndex:(NSInteger)indexOfItems amount:(NSInteger)numberOfItems detail_category:(NSString *)detail_category;
-(void)myOrders:(NSString *)user_email detail_category:(NSString *)detail_category;
-(void)mySells:(NSString *)user_email detail_category:(NSString *)detail_category;
-(void)myTransactions:(NSString *)user_email detail_category:(NSString *)detail_category;


-(void)drop:(NSString *)item_order_id detail_category:(NSString *)detail_category;

@end

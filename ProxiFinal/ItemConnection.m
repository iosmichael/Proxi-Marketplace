//
//  ItemConnection.m
//  ProxiFinal
//
//  Created by Michael Liu on 10/17/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "ItemConnection.h"
#define address @"http://proximarketplace.com/database/index.php"

@implementation ItemConnection


-(void)postItemData: (Item *)newItem
{
    NSDictionary *param = @{
#warning need to change Item_high_price
                            @"item_title":newItem.item_title,
                            @"item_description":newItem.item_description,
                            @"item_high_price":newItem.price_current,
                            @"item_low_price":newItem.price_current,
                            @"user_email":newItem.user_email,
                            @"item_category":newItem.category
                            };
    NSDictionary *param2 = @{
                             @"object":@"Item",
                             @"method":@"postItem",
                             @"data":param
                             };
    AFHTTPRequestOperationManager *manager= [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manager POST:address parameters:param2 constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:newItem.image name:@"item_image" fileName:@"item_image" mimeType:@"image/jpg/file"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *response = responseObject;
        NSString *responseString = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"%@",responseString);
#warning Notification established
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"PostItemNotification" object:responseString];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"PostItemNotificationError" object:nil];
        NSLog(@"this is an Error");
        NSLog(@"%@", [error description]);
        
    }];
    
}

#pragma mark - Fetch Item
-(void)fetchItemFromIndex:(NSInteger)indexOfItems amount:(NSInteger)numberOfItems
{
    
    
    AFHTTPRequestOperationManager *manager= [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    NSString *index = [NSString stringWithFormat:@"%ld",(long)indexOfItems];
    NSString *numberOfItemString = [NSString stringWithFormat:@"%ld",(long)numberOfItems];
    NSDictionary *param = @{@"offset":index,
                            @"number":numberOfItemString
                            };
    NSDictionary *param2 = @{@"object":@"Search",
                             @"method":@"fetchAllItems",
                             @"data":param
                             };
    [manager POST:address parameters:param2 constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = responseObject;
        NSArray *json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"FetchItemNotification" object:json];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"this is an Error");
        NSLog(@"%@", [error description]);
    }];
    
}

-(void)fetchItemsFromIndex:(NSInteger)indexOfItems amount:(NSInteger)numberOfItems
{
    
    
    AFHTTPRequestOperationManager *manager= [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    
    
    NSString *index = [NSString stringWithFormat:@"%ld",(long)indexOfItems];
    NSString *numberOfItemString = [NSString stringWithFormat:@"%ld",(long)numberOfItems];
    NSDictionary *param = @{@"offset":index,
                            @"number":numberOfItemString
                            };
    NSDictionary *param2 = @{@"object":@"Search",
                             @"method":@"fetchAllItems",
                             @"data":param
                             };
    [manager POST:address parameters:param2 constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = responseObject;
        NSArray *json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"FetchBigItemNotification" object:json];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"this is an Error");
        NSLog(@"%@", [error description]);
    }];
    
}

-(void)fetchItemsByName:(NSString *)searchName FromIndex:(NSInteger)indexOfItems amount:(NSInteger)numberOfItems{
    
    AFHTTPRequestOperationManager *manager= [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    
    
    NSString *index = [NSString stringWithFormat:@"%ld",(long)indexOfItems];
    NSString *numberOfItemString = [NSString stringWithFormat:@"%ld",(long)numberOfItems];
    NSDictionary *param = @{@"offset":index,
                            @"number":numberOfItemString,
                            @"name":searchName
                            };
    NSDictionary *param2 = @{@"object":@"Search",
                             @"method":@"searchItemName",
                             @"data":param
                             };
    [manager POST:address parameters:param2 constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = responseObject;
        NSArray *json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"FetchItemByNameNotification" object:json];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"this is an Error");
        NSLog(@"%@", [error description]);
    }];
    
}


-(void)fetchItemsByCategory:(NSString *)searchCategory amount:(NSInteger)numberOfItems{
    
    AFHTTPRequestOperationManager *manager= [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    
    NSString *numberOfItemString = [NSString stringWithFormat:@"%ld",(long)numberOfItems];
    NSDictionary *param = @{
                            @"number":numberOfItemString,
                            @"category_name":searchCategory
                            };
    NSDictionary *param2 = @{@"object":@"Search",
                             @"method":@"searchItemCategory",
                             @"data":param
                             };
    [manager POST:address parameters:param2 constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = responseObject;
        NSArray *json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"FetchItemByCategoryNotification" object:json];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"this is an Error");
        NSLog(@"%@", [error description]);
    }];
    
}


-(void)myItems:(NSString *)user_email FromIndex:(NSInteger)indexOfItems amount:(NSInteger)numberOfItems detail_category:(NSString *)detail_category{
    
    AFHTTPRequestOperationManager *manager= [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    
    
    NSString *index = [NSString stringWithFormat:@"%ld",(long)indexOfItems];
    NSString *numberOfItemString = [NSString stringWithFormat:@"%ld",(long)numberOfItems];
    NSDictionary *param = @{@"offset":index,
                            @"number":numberOfItemString,
                            @"user_email":user_email
                            };
    NSDictionary *param2 = @{@"object":@"Manager",
                             @"method":detail_category,
                             @"data":param
                             };
    [manager POST:address parameters:param2 constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = responseObject;
        NSString *dataDescription  = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",[dataDescription description]);
        NSArray *json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MyTableNotification" object:json];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"this is an Error");
        NSLog(@"%@", [error description]);
    }];
    
}

-(void)myOrders:(NSString *)user_email detail_category:(NSString *)detail_category{
    AFHTTPRequestOperationManager *manager= [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    
    NSDictionary *param = @{
                            @"user_email":user_email
                            };
    NSDictionary *param2 = @{@"object":@"Manager",
                             @"method":detail_category,
                             @"data":param
                             };
    [manager POST:address parameters:param2 constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = responseObject;
        NSString *dataDescription  = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",[dataDescription description]);
        NSArray *json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MyOrderNotification" object:json];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"this is an Error");
        NSLog(@"%@", [error description]);
    }];

}

-(void)mySells:(NSString *)user_email detail_category:(NSString *)detail_category{
    AFHTTPRequestOperationManager *manager= [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    
    NSDictionary *param = @{
                            @"user_email":user_email
                            };
    NSDictionary *param2 = @{@"object":@"Manager",
                             @"method":detail_category,
                             @"data":param
                             };
    [manager POST:address parameters:param2 constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = responseObject;
        NSString *dataDescription  = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",[dataDescription description]);
        NSArray *json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MySellNotification" object:json];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"this is an Error");
        NSLog(@"%@", [error description]);
    }];

}

-(void)myTransactions:(NSString *)user_email detail_category:(NSString *)detail_category{
    AFHTTPRequestOperationManager *manager= [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    
    NSDictionary *param = @{
                            @"user_email":user_email
                            };
    NSDictionary *param2 = @{@"object":@"Manager",
                             @"method":detail_category,
                             @"data":param
                             };
    [manager POST:address parameters:param2 constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = responseObject;
        NSString *dataDescription  = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",[dataDescription description]);
        NSArray *json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MyHistoryNotification" object:json];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"this is an Error");
        NSLog(@"%@", [error description]);
    }];
    
}




-(void)drop:(NSString *)item_order_id detail_category:(NSString *)detail_category{
    AFHTTPRequestOperationManager *manager= [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    
    if ([detail_category isEqualToString:@"My Items"]) {
        NSDictionary *param = @{
                                @"item_id":item_order_id
                                };
        NSDictionary *param2 = @{
                                 @"object":@"Item",
                                 @"method":@"drop",
                                 @"data":param
                                 };
        
        [manager POST:address parameters:param2 constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSData *data = responseObject;
            NSString *dataDescription  = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",[dataDescription description]);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"DropNotification" object:dataDescription];
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            NSLog(@"this is an Error");
            NSLog(@"%@",[error description]);
        }];
        
    }else if ([detail_category isEqualToString:@"My Orders"]){
        NSDictionary *param = @{
                                @"item_id":item_order_id
                                };
        NSDictionary *param2 = @{
                                 @"object":@"Transaction",
                                 @"method":@"cancelOrder",
                                 @"data":param
                                 };
        
        [manager POST:address parameters:param2 constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSData *data = responseObject;
            NSString *dataDescription  = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",[dataDescription description]);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"DropNotification" object:dataDescription];
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            NSLog(@"this is an Error");
            NSLog(@"%@",[error description]);
        }];
        
    }else{
        
    }
}


@end

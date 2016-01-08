//
//  Event.h
//  ProxiFinal
//
//  Created by Michael Liu on 1/2/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *time;
@property (strong,nonatomic) NSString *url;
@property (strong,nonatomic) NSString *img_url;

-(instancetype)initWithTitle:(NSString *)title time:(NSString *)time url:(NSString *)url image:(NSString *)img_url;

@end

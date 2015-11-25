//
//  Utility.h
//  ProxiFinal
//
//  Created by Michael Liu on 10/10/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject


+ (BOOL)hasLoggedIn;
+ (void)logOut;
+ (NSString *)getSchoolID;

@end

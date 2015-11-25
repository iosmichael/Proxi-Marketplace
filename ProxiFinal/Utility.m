//
//  Utility.m
//  ProxiFinal
//
//  Created by Michael Liu on 10/10/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (BOOL)hasLoggedIn
{
    if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"id"]
        && [[NSUserDefaults standardUserDefaults] objectForKey:@"email"]
        && [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"]) {
        return YES;
    }
    return NO;
}



+ (void)logOut
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"favorites"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"schoolID"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"login"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDictionary *)getUser
{
    return @{
             @"user_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"id"],
             @"user_email": [[NSUserDefaults standardUserDefaults] objectForKey:@"email"]
             };
}

+ (NSString *)getSchoolID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"schoolID"];
}
@end

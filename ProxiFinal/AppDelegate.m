//
//  AppDelegate.m
//  ProxiFinal
//
//  Created by Michael Liu on 10/3/15.
//  Copyright © 2015 Michael Liu. All rights reserved.
//

#import "AppDelegate.h"
#import <Braintree/Braintree.h>
#import <Firebase/Firebase.h>
#define firebase_url @"https://luminous-inferno-5888.firebaseio.com"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Braintree setReturnURLScheme:@"com.proximarketplace.proxifinal.payments"];
    // Override point for customization after application launch.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    // This code will work in iOS 7.0 and below:
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeNewsstandContentAvailability| UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    return YES;
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString * deviceTokenString = [[[[deviceToken description]
                                      stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                     stringByReplacingOccurrencesOfString: @">" withString: @""]
                                    stringByReplacingOccurrencesOfString: @" " withString: @""];
    Firebase *firebase = [[[[Firebase alloc]initWithUrl:firebase_url]childByAppendingPath:@"users"]childByAppendingPath:@"WheatonCollege"];
    NSUserDefaults *standardDefault = [NSUserDefaults standardUserDefaults];
    if (![standardDefault objectForKey:@"username"]) {
        return;
    }
    firebase = [[firebase childByAppendingPath:[self profileName:[standardDefault objectForKey:@"username"]]]childByAppendingPath:@"deviceToken"];
    [firebase setValue:deviceTokenString withCompletionBlock:^(NSError *error, Firebase *ref) {
        if (error) {
            NSLog(@"Didn't Register");
        }else{
            NSLog(@"Did Register");
        }
    }];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if ([url.scheme localizedCaseInsensitiveCompare:@"com.proximarketplace.proxifinal.payments"] == NSOrderedSame) {
        return [Braintree handleOpenURL:url sourceApplication:sourceApplication];
    }
    return NO;
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    UIApplicationState state = [application applicationState];
    
    // If your app is running
    if (state == UIApplicationStateActive)
    {
        
        //You need to customize your alert by yourself for this situation. For ex,
        NSString *cancelTitle = @"Cancel";
        NSString *message = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:cancelTitle
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }
    // If your app was in in active state
    else if (state == UIApplicationStateInactive)
    {
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(NSString *)profileName:(NSString *)email{
    NSString* fullName =[[email componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@".#[]$"]]
     componentsJoinedByString:@""];
    return fullName;
    
}


@end

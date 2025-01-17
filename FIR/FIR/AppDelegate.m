//
//  AppDelegate.m
//  FIR
//
//  Created by Vijay on 03/12/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <DigitsKit/DigitsKit.h>
#import "FIRUser.h"
#import "DataSource.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Fabric with:@[[Digits class]]];
    Digits *digits = [Digits sharedInstance];
    // Initialize Parse.
    [Parse setApplicationId:@"20ET8vDW6uFUheVsYeFNE27UeNYvFWJL3kbw6vum"
                  clientKey:@"SkFhHaDlOsGuuuelyEIMKoh77oUz9J9HZXPuWw83"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    //[digits logOut];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        DGTAuthenticationConfiguration *config = [[DGTAuthenticationConfiguration alloc] initWithAccountFields:DGTAccountFieldsNone];
        config.phoneNumber = @"+91";
    
        [digits authenticateWithViewController:nil configuration:config completion:^(DGTSession *session, NSError *error) {
            FIRUser *user = [[DataSource sharedDataSource] currentUser];
            NSMutableString *phoneNo = [NSMutableString stringWithString:session.phoneNumber];
            user.userID = session.userID;
            user.phoneNumber = phoneNo;
            [user saveUser];
        }];
    });

    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
    [[[DataSource sharedDataSource] currentUser] setDeviceToken:currentInstallation.deviceToken];
    [[[DataSource sharedDataSource] currentUser] saveUser];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

@end

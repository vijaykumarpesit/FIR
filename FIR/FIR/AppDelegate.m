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
#import <Firebase.h>
#import "GoContactSync.h"
#import <QRCodeReaderViewController/QRCodeReaderViewController.h>
#import "DataSource.h"

@interface AppDelegate () <QRCodeReaderDelegate>
@property (nonatomic, strong) QRCodeReaderViewController *codeReaderVC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UINavigationBar appearance] setTintColor:[UIColor redColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    
    [Fabric with:@[[Digits class]]];
    
    [FIRApp configure];
    
    
    [[GoContactSync sharedInstance] syncAddressBookIfNeeded];

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self checkSignIn];
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


- (void)checkSignIn {
    
    Digits *digits = [Digits sharedInstance];

    DGTAuthenticationConfiguration *config = [[DGTAuthenticationConfiguration alloc] initWithAccountFields:DGTAccountFieldsNone];
    config.phoneNumber = @"+91";
    [digits logOut];
    [digits authenticateWithViewController:nil
                             configuration:config
                                completion:^(DGTSession *session, NSError *error) {
                                    
                                    //First time sign up
                                    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"phoneNumber"]) {
                                        
                                        FIRUser *user = [[FIRUser alloc] init];
                                        NSMutableString *phoneNo = [NSMutableString stringWithString:session.phoneNumber];
                                        user.userID = session.userID;
                                        user.phoneNumber = phoneNo;
                                        [user saveUser];
                                        [DataSource sharedDataSource].currentUser = user;
                                        [[NSUserDefaults standardUserDefaults] setValue:session.phoneNumber forKey:@"phoneNumber"];
                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                    }
                                    
                                    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"adharNumber"]) {
                                        
                                        QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
                                        
                                        QRCodeReaderViewController *vc = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel"
                                                                                                                      codeReader:reader
                                                                                                             startScanningAtLoad:YES
                                                                                                          showSwitchCameraButton:YES
                                                                                                                 showTorchButton:YES];
                                        vc.modalPresentationStyle = UIModalPresentationFormSheet;
                                        vc.delegate = self;
                                        self.codeReaderVC = vc;

                                        [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
                                    }
                                    
                                    
                                }];

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

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"%@", result);
        //Set the adhar value and user
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end

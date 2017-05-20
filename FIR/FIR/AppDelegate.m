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
#import <XMLDictionary/XMLDictionary.h>
#import "FIRInvestment.h"
#import "FIRLocationManger.h"

@interface AppDelegate () <QRCodeReaderDelegate>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [Fabric with:@[[Digits class]]];
    
    [FIRApp configure];
    
    [FIRLocationManger locationManager];
    
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
    
    [DataSource sharedDataSource];
    
    return YES;
}


- (void)checkSignIn {
    
    Digits *digits = [Digits sharedInstance];
    
    DGTAuthenticationConfiguration *config = [[DGTAuthenticationConfiguration alloc] initWithAccountFields:DGTAccountFieldsNone];
    config.phoneNumber = @"+91";
    //[digits logOut];
    [digits authenticateWithViewController:nil
                             configuration:config
                                completion:^(DGTSession *session, NSError *error) {
                                    
                                    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"phoneNumber"] && [[NSUserDefaults standardUserDefaults] valueForKey:@"adharNumber"]) {
                                        //Everything is cool just go
                                    } else {
                                        //First time sign up
                                        FIRUser *user = [[FIRUser alloc] init];
                                        NSMutableString *phoneNo = [NSMutableString stringWithString:[session.phoneNumber substringFromIndex:3]];
                                        user.userID = session.userID;
                                        user.phoneNumber = phoneNo;
                                        [user saveUser];
                                        [DataSource sharedDataSource].currentUser = user;
                                        [[NSUserDefaults standardUserDefaults] setValue:phoneNo forKey:@"phoneNumber"];
                                        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"loanID"];
                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                        
                                        
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            if (![[NSUserDefaults standardUserDefaults] valueForKey:@"adharNumber"]) {
                                                
                                                QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
                                                
                                                QRCodeReaderViewController *vc = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel"
                                                                                                                              codeReader:reader
                                                                                                                     startScanningAtLoad:YES
                                                                                                                  showSwitchCameraButton:YES
                                                                                                                         showTorchButton:YES];
                                                vc.modalPresentationStyle = UIModalPresentationFormSheet;
                                                vc.delegate = self;
                                                
                                                [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
                                            }
                                            
                                        });
                                    }
                                    
                                }];
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    NSArray *invest = [DataSource sharedDataSource].investments.value;
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
/*
- (void)applicationDidBecomeActive:(UIApplication *)application {
    FIRInvestment *investment = [[FIRInvestment alloc] init];
    investment.investmentID = @"100";
    investment.loanID = @"someThing";
    [investment saveInvestment];
}
*/
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        
        NSDictionary *xmlDoc = [[XMLDictionaryParser sharedInstance] dictionaryWithString:result];
        
        NSLog(@"%@", xmlDoc);
        
        FIRUser *user = [[DataSource sharedDataSource] currentUser];
        
        if ([xmlDoc[@"_uid"] length]) {
            user.adharID = xmlDoc[@"_uid"];
        }
        
        if ([xmlDoc count]) {
            user.completeAdharInfo = xmlDoc;
        }
        
        [user saveUser];
        
        if (user.adharID) {
            [[NSUserDefaults standardUserDefaults] setValue:user.adharID forKey:@"adharNumber"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end

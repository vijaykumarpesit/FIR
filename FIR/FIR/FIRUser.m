//
//  FIRUser.m
//  FIR
//
//  Created by Vijay on 04/12/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "FIRUser.h"
NSString * const kKeyName = @"name";
NSString * const kKeyPhoneNumber = @"phoneNumber";
NSString * const kKeyUserId = @"userID";
NSString * const kIsPolice = @"isPolice";
NSString *const kLocation = @"location";
NSString *const kDeviceToken = @"deviceToken";

@interface FIRUser ()

@property (nonatomic, assign) BOOL isSaveInPreogress;

@end


@implementation FIRUser
/*
- (void)setUserID:(NSString*)userID {
}

- (NSString*)userID {
}

- (void)setName:(NSString*)Name {
}

- (NSString*)name {
}


- (void)setPhoneNumber:(NSString *)phoneNumber {
}

- (NSString*)phoneNumber {
}

- (void)saveUser {
    
    
}


-(BOOL)isPolice {
    
    return  [[self.parseUser objectForKey:kIsPolice] boolValue];
}

- (void)setLocation:(PFGeoPoint *)location {
    
    [self.parseUser setObject:location forKey:kLocation];

}

- (PFGeoPoint *)location {
    return [self.parseUser objectForKey:kLocation];
}

- (void)setDeviceToken:(NSString *)deviceToken {
    [self.parseUser setObject:deviceToken forKey:kDeviceToken];
}

- (NSString *)deviceToken {
    return [self.parseUser objectForKey:kDeviceToken];
}
*/
@end

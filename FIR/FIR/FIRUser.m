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


@end


@implementation FIRUser

- (instancetype)initWithPFUser:(PFUser*)parseUser {
    if (self = [super init]) {
        self.parseUser = parseUser;
        //self.isPolice = YES;
    }
    return self;
}

- (void)setUserID:(NSString*)userID {
    [self.parseUser setObject:userID forKey:kKeyUserId];
}

- (NSString*)userID {
    return [self.parseUser objectForKey:kKeyUserId];
}

- (void)setName:(NSString*)Name {
    [self.parseUser setObject:Name forKey:kKeyName];
}

- (NSString*)name {
    return [self.parseUser objectForKey:kKeyName];
}


- (void)setPhoneNumber:(NSString *)phoneNumber {
    [self.parseUser setObject:phoneNumber forKey:kKeyPhoneNumber];
}

- (NSString*)phoneNumber {
    return [self.parseUser objectForKey:kKeyPhoneNumber];
}

- (void)saveUser {
    
    [self.parseUser saveInBackground];
    
    __block PFObject *user = nil;
    
    if (self.phoneNumber) {
        PFQuery *query = [PFQuery queryWithClassName:@"FIRUser"];
        [query whereKey:@"phoneNumber" equalTo:self.phoneNumber];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            
            if (objects.count) {
                user = [objects lastObject];
            } else {
                user = [PFObject objectWithClassName:@"FIRUser"];
            }
            
            
            [self.parseUser.allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
                [user setObject:self.parseUser[key] forKey:key];
                
            }];
            
            [user saveInBackground];
        }];
        
        
    }
    
    
    
}

- (void)setIsPolice:(BOOL)isPolice {
    [self.parseUser setObject:@(isPolice) forKey:kIsPolice];
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

@end

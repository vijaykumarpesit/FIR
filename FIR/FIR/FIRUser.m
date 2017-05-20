//
//  FIRUser.m
//  FIR
//
//  Created by Vijay on 04/12/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "FIRUser.h"
#import "FIRDataBase.h"
#import "NSObject+DictionaryRep.h"

NSString * const kKeyName = @"name";
NSString * const kKeyPhoneNumber = @"phoneNumber";
NSString * const kKeyUserId = @"userID";
NSString * const kIsPolice = @"isPolice";
NSString *const kLocation = @"location";
NSString *const kDeviceToken = @"deviceToken";

@interface FIRUser ()

@end


@implementation FIRUser

- (void)saveUser {
    
    FIRDatabaseReference *ref = [FIRDataBase sharedDataBase].ref;
    
    NSDictionary *propertyDict = [self dictionaryRepresentation];
    
    if (propertyDict.count && propertyDict[@"phoneNumber"]) {
        [[[ref child:@"accounts"] child:self.phoneNumber] setValue:propertyDict];
    }
}

- (void)updateUser {
    
}

@end

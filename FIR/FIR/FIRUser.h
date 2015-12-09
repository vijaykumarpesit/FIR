//
//  FIRUser.h
//  FIR
//
//  Created by Vijay on 04/12/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface FIRUser : NSObject

- (instancetype)initWithPFUser:(PFUser*)parseUser;

@property (nonatomic, strong)PFUser *parseUser;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, assign) BOOL isPolice;
@property (nonatomic, strong) PFGeoPoint *location;
@property (nonatomic, strong) NSString *deviceToken;

- (void)saveUser;


@end

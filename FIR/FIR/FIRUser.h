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


@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *investmentScore;
@property (nonatomic, copy) NSString *riskScore;
@property (nonatomic, copy) NSString *adharID;

- (void)saveUser;


@end

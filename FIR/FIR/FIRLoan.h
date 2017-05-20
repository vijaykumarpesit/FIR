//
//  FIRLoan.h
//  FIR
//
//  Created by Vijay on 20/05/17.
//  Copyright © 2017 Vijay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FIRLoan : NSObject

@property (nonatomic, copy) NSString *loanID;
@property (nonatomic, copy) NSNumber *money;
@property (nonatomic, copy) NSString *duartion;
@property (nonatomic, copy) NSArray *documents;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSDictionary *locationDict;
@property (nonatomic, copy) NSString *name;

- (void)saveLoan;
+ (NSString *)getDistanceFromSnapshot:(NSDictionary *)loan;

@end

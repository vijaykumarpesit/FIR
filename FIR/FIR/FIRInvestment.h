//
//  FIRInvestment.h
//  FIR
//
//  Created by Vijay on 20/05/17.
//  Copyright © 2017 Vijay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FIRInvestment : NSObject

@property (nonatomic, copy) NSString * loanID;
@property (nonatomic, copy) NSString * investMentID;
@property (nonatomic, copy) NSString * userID;
@property (nonatomic, copy) NSString * phoneNumber;
@property (nonatomic, copy) NSDictionary *offers;

- (void)saveInvestment;

@end

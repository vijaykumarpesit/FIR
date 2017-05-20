//
//  FIRInvestment.m
//  FIR
//
//  Created by Vijay on 20/05/17.
//  Copyright © 2017 Vijay. All rights reserved.
//

#import "FIRInvestment.h"
#import "FIRDataBase.h"
#import "NSObject+DictionaryRep.h"

@implementation FIRInvestment

- (void)saveInvestment {
    
    FIRDatabaseReference *ref = [FIRDataBase sharedDataBase].ref;
    
    NSDictionary *propertyDict = [self dictionaryRepresentation];
    
    if (propertyDict.count && propertyDict[@"investmentID"]) {
        [[[ref child:@"investments"] child:self.userID] setValue:propertyDict];
    }
}

@end

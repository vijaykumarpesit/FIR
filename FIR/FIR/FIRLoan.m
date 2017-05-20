//
//  FIRLoan.m
//  FIR
//
//  Created by Vijay on 20/05/17.
//  Copyright © 2017 Vijay. All rights reserved.
//

#import "FIRLoan.h"
#import "FIRDataBase.h"
#import "NSObject+DictionaryRep.h"

@implementation FIRLoan


- (void)saveLoan {
   
    FIRDatabaseReference *ref = [FIRDataBase sharedDataBase].ref;
    
    NSDictionary *propertyDict = [self dictionaryRepresentation];
    
    if (propertyDict.count && propertyDict[@"loanID"]) {
        [[[ref child:@"loans"] child:self.loanID] setValue:propertyDict];
    }
}

@end

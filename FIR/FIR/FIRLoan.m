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
#import "FIRLocationManger.h"

@implementation FIRLoan


- (void)saveLoan {
   
    FIRDatabaseReference *ref = [FIRDataBase sharedDataBase].ref;
    
    NSDictionary *propertyDict = [self dictionaryRepresentation];
    
    if (propertyDict.count && propertyDict[@"loanID"]) {
        [[[ref child:@"loans"] child:self.loanID] setValue:propertyDict];
    }
}

+ (NSString *)getDistanceFromSnapshot:(NSDictionary *)loan {
    if (loan[@"locationDict"] == nil) {
        return nil;
    }
    NSNumber *lattitude = [loan[@"locationDict"] valueForKey:@"lattitude"];
    NSNumber *longitude = [loan[@"locationDict"]  valueForKey:@"longitude"];
    
    CLLocation *loanLocation = [[CLLocation alloc] initWithLatitude:lattitude.doubleValue longitude:longitude.doubleValue];
    CLLocation *currentLocation = [FIRLocationManger locationManager].locationManger.location;
    
    CLLocationDistance distance = ([currentLocation distanceFromLocation:loanLocation]/1000);
    
    return [NSString stringWithFormat:@"%f kms", distance];
}

@end

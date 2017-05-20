//
//  DataSource.m
//  FIR
//
//  Created by Vijay on 04/12/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "DataSource.h"
#import <Parse/Parse.h>
#import "FIRUser.h"
#import "FIRRiskScoreLoan.h"
#import "GoContactSync.h"
#import "FIRLocationManger.h"

@interface DataSource ()

@property (nonatomic, strong) NSMutableOrderedSet *myLoans;
@property (nonatomic, strong) NSMutableOrderedSet *othersLoans;
@property (nonatomic, strong) NSOperationQueue *dataRefreshQueue;
@end

@implementation DataSource

+ (DataSource *)sharedDataSource {
    
    static DataSource* sharedDataSource = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedDataSource = [[DataSource alloc] init];
    });
    
    return sharedDataSource;
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.myLoans = [[NSMutableOrderedSet alloc] init];
        self.othersLoans = [[NSMutableOrderedSet alloc] init];
        self.dataRefreshQueue = [[NSOperationQueue alloc] init];
        self.dataRefreshQueue.maxConcurrentOperationCount = 1;
        
        FIRDatabaseReference *ref =  [FIRDataBase sharedDataBase].ref;
        
        
        [[ref child:@"investments"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            self.investments = snapshot;
            [self refreshInvestments];
        }];
        
        [[ref child:@"loans"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            self.loans = snapshot;
            [self refreshLoans];
        }];
        
        
        NSString *phoneNumber =  [[NSUserDefaults standardUserDefaults] valueForKey:@"phoneNumber"];
        
        if (phoneNumber) {
            [[[ref child:@"accounts"] child:phoneNumber] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                self.currentUserSnapShot = snapshot;
            }];
        }
        
    }
    
    return self;
}

- (void)refreshInvestments {
    
}

- (void)refreshLoans {
    
    [self.dataRefreshQueue addOperationWithBlock:^{
        
        if (self.loans) {
            
            NSMutableOrderedSet *localMyLoans = [NSMutableOrderedSet orderedSet];
            NSMutableOrderedSet *localOthersLoans = [NSMutableOrderedSet orderedSet];
            
            NSEnumerator *children = [self.loans children];
            
            FIRDataSnapshot *child;
            
            NSString *phoneNumber =  [[NSUserDefaults standardUserDefaults] valueForKey:@"phoneNumber"];
            
            while (child = [children nextObject]) {
                
                if ([[child valueForKey:@"phoneNumber"] isEqualToString:phoneNumber]) {
                    FIRRiskScoreLoan *loan = [[FIRRiskScoreLoan alloc] init];
                    loan.loanSnapshot = child;
                    [localMyLoans addObject:loan];
                } else {
                    [localOthersLoans addObject:[self riskScoreLoanFor:child]];
                    
                    
                }
                
            }
            
            self.othersLoans = localOthersLoans;
            self.myLoans = localMyLoans;
            
        }
        
    }];
    
}

- (FIRRiskScoreLoan *)riskScoreLoanFor:(FIRDataSnapshot *)snapShot {
    
    FIRRiskScoreLoan *riskScoreLoan = [[FIRRiskScoreLoan alloc] init];
    riskScoreLoan.loanSnapshot = snapShot;
    
    NSUInteger riskScore = 0;
    
    NSString *phoneNumber = [snapShot valueForKey:@"phoneNumber"];
    
    //First check
    if ([[[[GoContactSync sharedInstance] syncedContacts] allKeys] containsObject:phoneNumber]) {
        riskScore += 10;
    }
   
    //SecondCheck
    
    if ([snapShot valueForKey:@"locationDict"]) {
        NSDictionary *locationDict = [snapShot valueForKey:@"locationDict"];
        NSNumber *lattitude = [locationDict valueForKey:@"lattitude"];
        NSNumber *longitude = [locationDict valueForKey:@"longitude"];
        
        CLLocation *loanLocation = [[CLLocation alloc] initWithLatitude:lattitude.doubleValue longitude:longitude.doubleValue];
        CLLocation *currentLocation = [FIRLocationManger locationManager].locationManger.location;
        
        CLLocationDistance distance = [loanLocation distanceFromLocation:loanLocation];
        riskScore += (riskScore*distance/1000);
        
    }
    
    return riskScoreLoan;
}

- (NSArray *)myLoansArray {
    return self.myLoans.array;
}

- (NSArray *)othersLoansArray {
    return self.othersLoans.array;
}
@end

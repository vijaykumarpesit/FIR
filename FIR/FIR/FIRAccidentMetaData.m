//
//  FIRAccidentMetaData.m
//  FIR
//
//  Created by Vijay on 04/12/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "FIRAccidentMetaData.h"

@implementation FIRAccidentMetaData


- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.victimImages = [[NSMutableArray alloc] init];
        self.spotImages = [[NSMutableArray alloc] init];
        self.documentsImages = [[NSMutableArray alloc] init];
        self.reportedByPhoneNOs = [[NSMutableSet alloc] init];
        self.attendedByPhoneNos = [[NSMutableSet alloc] init];
        self.vehicleNumbers = [[NSMutableSet alloc] init];
    }
    return self;
}

@end

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
        _victimImages = [[NSMutableArray alloc] init];
        _spotImages = [[NSMutableArray alloc] init];
       _vehicleNoImages = [[NSMutableArray alloc] init];
        _reportedByPhoneNOs = [[NSMutableSet alloc] init];
        _attendedByPhoneNos = [[NSMutableSet alloc] init];
        _vehicleNumbers = [[NSMutableSet alloc] init];
        _images = [[NSMutableArray alloc] init];
    }
    return self;
}

@end

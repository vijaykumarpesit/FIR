//
//  FIRDataBase.m
//  FIR
//
//  Created by Vijay on 20/05/17.
//  Copyright © 2017 Vijay. All rights reserved.
//

#import "FIRDataBase.h"

@implementation FIRDataBase

+ (FIRDataBase *)sharedDataSource {
    
    static FIRDataBase* sharedDataSource = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedDataSource = [[FIRDataBase alloc] init];
    });
    
    return sharedDataSource;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.ref = [[FIRDatabase database] reference];
    }
    return self;
}

@end

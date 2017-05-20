//
//  FIRDataBase.m
//  FIR
//
//  Created by Vijay on 20/05/17.
//  Copyright © 2017 Vijay. All rights reserved.
//

#import "FIRDataBase.h"

@implementation FIRDataBase

+ (FIRDataBase *)sharedDataBase {
    
    static FIRDataBase* sharedDataBase = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedDataBase = [[FIRDataBase alloc] init];
    });
    
    return sharedDataBase;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.ref = [[FIRDatabase database] reference];
    }
    return self;
}

@end

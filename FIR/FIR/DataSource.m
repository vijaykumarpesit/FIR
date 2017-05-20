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

@implementation DataSource

+ (DataSource *)sharedDataSource {
    
    static DataSource* sharedDataSource = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedDataSource = [[DataSource alloc] init];
    });
    
    return sharedDataSource;
}

@end

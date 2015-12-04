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

-(instancetype)init {
    
    if(self = [super init]) {
        PFUser *parseUser = [PFUser currentUser];
        if (!parseUser) {
            parseUser = [PFUser user];
        }
        self.currentUser = [[FIRUser alloc] initWithPFUser:parseUser];
        self.currentUser.phoneNumber = @"9844480550";
        self.accidentMetaDataArry = [[NSMutableArray alloc] init];
        
    }
    
    return self;
}

@end

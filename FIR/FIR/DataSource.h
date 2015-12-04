//
//  DataSource.h
//  FIR
//
//  Created by Vijay on 04/12/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FIRUser.h"

@interface DataSource : NSObject

@property (nonatomic, strong)FIRUser*currentUser;

+ (DataSource *)sharedDataSource;

@end

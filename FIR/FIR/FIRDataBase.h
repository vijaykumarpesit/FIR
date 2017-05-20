//
//  FIRDataBase.h
//  FIR
//
//  Created by Vijay on 20/05/17.
//  Copyright © 2017 Vijay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FirebaseDatabase/FirebaseDatabase.h>

@interface FIRDataBase : NSObject

@property (strong, nonatomic) FIRDatabaseReference *ref;

+ (FIRDataBase *)sharedDataSource;

@end

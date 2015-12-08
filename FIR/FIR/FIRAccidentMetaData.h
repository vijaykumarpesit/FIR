//
//  FIRAccidentMetaData.h
//  FIR
//
//  Created by Vijay on 04/12/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface FIRAccidentMetaData : NSObject

@property (nonatomic, strong)NSDate *date;

@property (nonatomic, assign)CGFloat lattitude;

@property (nonatomic, assign) CGFloat longitude;

@property (nonatomic, strong) NSMutableSet *vehicleNumbers;

@property (nonatomic, strong)NSMutableArray *spotImages;

@property (nonatomic, strong)NSMutableArray *victimImages;

@property (nonatomic, strong)NSMutableArray *vehicleNoImages;

@property (nonatomic, strong) NSMutableSet *reportedByPhoneNOs;

@property (nonatomic, strong) NSMutableSet *attendedByPhoneNos;

@property (nonatomic, strong)NSMutableArray *images;


@property (nonatomic, assign) NSUInteger status;

@property (nonatomic, copy) NSString *accidentDescription;


@end

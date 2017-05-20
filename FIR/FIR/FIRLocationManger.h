//
//  FIRLocationManger.h
//  FIR
//
//  Created by Vijay on 20/05/17.
//  Copyright © 2017 Vijay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface FIRLocationManger : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManger;

+ (instancetype)locationManager;

@end

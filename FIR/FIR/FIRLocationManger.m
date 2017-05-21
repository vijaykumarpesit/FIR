//
//  FIRLocationManger.m
//  FIR
//
//  Created by Vijay on 20/05/17.
//  Copyright © 2017 Vijay. All rights reserved.
//

#import "FIRLocationManger.h"

@implementation FIRLocationManger 

+ (instancetype)locationManager {
    
    static FIRLocationManger *locationManger = nil;
    
    if (!locationManger) {
        
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            locationManger = [[FIRLocationManger alloc] init];
        });
    }
 
    return locationManger;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        if ([CLLocationManager locationServicesEnabled]) {
            self.locationManger = [[CLLocationManager alloc] init];
            [self.locationManger startUpdatingLocation];
            self.locationManger.delegate = self;
        }
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

}

@end

//
//  ImageMetaData.h
//  FIR
//
//  Created by Vijay on 04/12/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,AccidentImageType) {
    
    AccidentImageTypeVictim,
    AccidentImageTypeNumberPlate,
    AccidentImageTypeOther
};

@interface ImageMetaData : NSObject

@property (nonatomic, strong)NSString *filePath;

@property (nonatomic, assign)AccidentImageType imageType;

@property (nonatomic,strong) NSString *text;

@end

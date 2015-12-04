//
//  ImageMetaData.h
//  FIR
//
//  Created by Vijay on 04/12/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageMetaData : NSObject

@property (nonatomic, strong)NSString *filePath;

@property (nonatomic, strong)NSDate *date;

@property (nonatomic, strong)NSString *cameraName;

@end

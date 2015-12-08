//
//  FIRFaceDetector.h
//  FIR
//
//  Created by Vijay on 08/12/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface FIRFaceDetector : NSObject

+(BOOL)isFaceDetectedInImage:(UIImage *)image;

@end

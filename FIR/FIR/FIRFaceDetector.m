//
//  FIRFaceDetector.m
//  FIR
//
//  Created by Vijay on 08/12/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "FIRFaceDetector.h"

@implementation FIRFaceDetector

+(BOOL)isFaceDetectedInImage:(UIImage *)image {
 
    CIContext *context = [CIContext contextWithOptions:nil];
    
    NSDictionary *opts = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh };
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:context
                                              options:opts];
    
    NSArray *features = [detector featuresInImage:image.CIImage];
    
    if ( features.count >2) {
        return YES;
    } else {
        return NO;
    }
}

@end

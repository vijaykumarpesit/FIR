//
//  TextExtractor.m
//  FIR
//
//  Created by Vijay on 04/12/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "TextExtractor.h"
#import <TesseractOCR/TesseractOCR.h>
#import "UIImage+BlackAndWhiteFilters.h"

@implementation TextExtractor


+ (NSString *)textFromImage:(UIImage *)image {
    
    G8Tesseract *ract = [[G8Tesseract alloc] initWithLanguage:@"eng"];
    ract.pageSegmentationMode = G8PageSegmentationModeAuto;
    ract.engineMode = G8OCREngineModeTesseractCubeCombined;
    ract.charWhitelist = @"QWERTYUIOPASDFGHJKLZXCVBNM1234567890";

    ract.maximumRecognitionTime = 60.0;
    ract.image = [image g8_grayScale];
    BOOL success =  [ract recognize];
    
    if (success) {
        return ract.recognizedText;
        
    } else {
        return nil;
    }
}

@end

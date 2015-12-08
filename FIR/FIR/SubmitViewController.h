//
//  SubmitViewController.h
//  FIR
//
//  Created by Vijay on 04/12/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FIRAccidentMetaData.h"

@interface SubmitViewController : UIViewController

@property(nonatomic, assign)BOOL isInEditMode;
@property (nonatomic, strong) FIRAccidentMetaData *accidentMetdata;

@end

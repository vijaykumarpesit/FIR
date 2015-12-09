//
//  DetailsViewController.h
//  FIR
//
//  Created by Sachin Vas on 12/9/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FIRAccidentMetaData.h"

@interface DetailsViewController : UIViewController
@property (nonatomic, strong) FIRAccidentMetaData *accidentMetdata;
@property (nonatomic, strong) NSString *objectID;
@end

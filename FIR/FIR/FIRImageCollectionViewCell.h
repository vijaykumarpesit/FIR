//
//  FIRImageCollectionViewCell.h
//  FIR
//
//  Created by Vijay on 08/12/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^deleteCompletion)(void);

@interface FIRImageCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic)  UIImageView *imageView;
@property (strong, nonatomic)  UIButton *deleteButton;
- (void)addDeleteButtonWithCompletion:(deleteCompletion)deleteCompletion;
@end

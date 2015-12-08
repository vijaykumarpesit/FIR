//
//  FIRImageCollectionViewCell.m
//  FIR
//
//  Created by Vijay on 08/12/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "FIRImageCollectionViewCell.h"

@implementation FIRImageCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [ _imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        [_imageView setUserInteractionEnabled:YES];
    }
    return self;
}

@end

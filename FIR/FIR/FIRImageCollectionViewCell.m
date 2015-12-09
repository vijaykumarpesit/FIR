//
//  FIRImageCollectionViewCell.m
//  FIR
//
//  Created by Vijay on 08/12/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "FIRImageCollectionViewCell.h"

@interface FIRImageCollectionViewCell ()

@property (nonatomic, copy) deleteCompletion deleteCompletion;

@end


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
        [self removeDeleteButton];
    }
    return self;
}

- (void)addDeleteButtonWithCompletion:(deleteCompletion)deleteCompletion {
    [self removeDeleteButton];
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.backgroundColor = [UIColor clearColor];
        _deleteButton.frame = CGRectMake(0, 0, 25, 25);
        [_deleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(handleDeletion:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_deleteButton];
        self.deleteCompletion = deleteCompletion;
    }
}

- (void)removeDeleteButton {
    if (_deleteButton) {
        [_deleteButton removeFromSuperview];
        _deleteButton = nil;
        _deleteCompletion = nil;
    }
}

- (void)prepareForReuse {
    [self removeDeleteButton];
    [super prepareForReuse];
}

- (void)handleDeletion:(id)sender {
    if (self.deleteCompletion) {
        self.deleteCompletion();
    }
}

@end

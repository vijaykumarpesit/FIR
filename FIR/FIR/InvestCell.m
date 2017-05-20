//
//  InvestCell.m
//  FIR
//
//  Created by Sachin Vas on 20/05/17.
//  Copyright © 2017 Vijay. All rights reserved.
//

#import "InvestCell.h"

@implementation InvestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.investButton.layer.shadowOpacity = 0.7;
    self.investButton.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

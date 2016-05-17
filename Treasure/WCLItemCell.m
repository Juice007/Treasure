//
//  WCLItemCell.m
//  Treasure
//
//  Created by Lv on 16/5/14.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import "WCLItemCell.h"

@implementation WCLItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - button actions
- (IBAction)showImage:(id)sender
{
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end

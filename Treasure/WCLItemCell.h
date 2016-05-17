//
//  WCLItemCell.h
//  Treasure
//
//  Created by Lv on 16/5/14.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCLItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelSerialNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelValue;

@property (copy, nonatomic) void (^actionBlock)(void);

@end

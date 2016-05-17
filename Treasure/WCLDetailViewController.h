//
//  WCLDetailViewController.h
//  Treasure
//
//  Created by Lv on 16/5/10.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WCLItem;

@interface WCLDetailViewController : UIViewController

@property(nonatomic, strong) WCLItem *item;

//- (instancetype)initForNewItem:(BOOL)isNew;

@end

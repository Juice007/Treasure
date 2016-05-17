//
//  WCLItem.h
//  Treasure
//
//  Created by Lv on 16/5/7.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface WCLItem : NSObject <NSCoding>

+ (instancetype) randomItem;

- (instancetype) initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber;

- (instancetype) initWithItemName:(NSString *)name;

- (instancetype) init;

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic, unsafe_unretained) int valueInDollars;
@property (nonatomic, readonly, strong) NSDate *dateCreated;

@property (nonatomic, copy) NSString *itemKey;
@property (nonatomic, strong) UIImage *thumbnail;

- (void)setThumbnailFromImage:(UIImage *)image;

@end

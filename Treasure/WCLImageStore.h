//
//  WCLImageStore.h
//  Treasure
//
//  Created by Lv on 16/5/13.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit; //导入框架。一定要加上这一句，否则Xcode无法识别UIImage，会报错：expected a type

@interface WCLImageStore : NSObject

+ (instancetype)sharedStore;

- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;


@end

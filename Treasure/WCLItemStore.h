//
//  WCLItemStore.h
//  Treasure
//
//  Created by Lv on 16/5/7.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WCLItem;

@interface WCLItemStore : NSObject

//allItems属性只有get方法，只能通过get方法返回的形式赋值。而且其他对象只能读取不能改变它的值
@property (nonatomic, readonly) NSArray *allItems;

+ (instancetype)sharedStore;
- (WCLItem *)createItem;
- (void)removeItem:(WCLItem *)item;
- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

- (BOOL)saveChanges;

@end

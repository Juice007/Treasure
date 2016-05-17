//
//  WCLItemStore.m
//  Treasure
//
//  Created by Lv on 16/5/7.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import "WCLItemStore.h"
#import "WCLItem.h"
#import "WCLImageStore.h"

@interface WCLItemStore ()

@property (nonatomic, strong) NSMutableArray *privateItems;

@end


@implementation WCLItemStore

#pragma mark - initialization

+ (instancetype)sharedStore
{
    
    static WCLItemStore *sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

//如果调用[[WCLItemStore alloc] init]就提示应该使用[WCLItemStore sharedStore]
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"请使用[WCLItemStore sharedStore]" userInfo:nil];
    return nil;
}

//真正的私有初始化方法
- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        NSString *path = [self itemArchivePath];
        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (!_privateItems) {
            _privateItems = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

#pragma mark - methods

- (NSArray *)allItems
{
    return self.privateItems;
}

- (WCLItem *)createItem
{
//    WCLItem *item = [WCLItem randomItem];
    WCLItem *item = [[WCLItem alloc] init];
    [self.privateItems addObject:item];
    return item;
}

- (void)removeItem:(WCLItem *)item
{
    NSString *key = item.itemKey;
    [[WCLImageStore sharedStore] deleteImageForKey:key];
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
//    得到要移动的对象的指针，以便稍后能将其插入新的位置
    WCLItem *item = self.privateItems[fromIndex];
//    将item从原位置移出
    [self.privateItems removeObjectAtIndex:fromIndex];
//    根据新的索引位置，将item插回allItems数组
    [self.privateItems insertObject:item atIndex:toIndex];
}

#pragma mark - archiving

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"item.archive"];
}

- (BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];
}










@end

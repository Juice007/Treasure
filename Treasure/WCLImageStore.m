//
//  WCLImageStore.m
//  Treasure
//
//  Created by Lv on 16/5/13.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import "WCLImageStore.h"

@interface WCLImageStore ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;

- (NSString *)imagePathForKey:(NSString *)key;

@end

@implementation WCLImageStore

#pragma mark - initialization

+ (instancetype)sharedStore
{
    static WCLImageStore *sharedStore = nil;
    if (sharedStore == nil) {
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
        
//        每个应用都有一个NSNotificationCenter对象
//       将WCLImageStore注册为通知中心的观察者，接收来自任何对象发送的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearCache:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

#pragma mark - initialize image

- (void)setImage:(UIImage *)image forKey:(NSString *)key {
//    [self.dictionary setObject:image forKey:key];
    self.dictionary[key] = image;
//    获取保存图片的全路径
    NSString *imagePath = [self imagePathForKey:key];
//    从图片提取jpeg格式的数据
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
//    将jpeg格式的数据写入文件
    [data writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)key {
//    return [self.dictionary objectForKey:key];
//    return self.dictionary[key];
    
    UIImage *result = self.dictionary[key];
    
    if (!result) {
        NSString *imagePath = [self imagePathForKey:key];
        result = [UIImage imageWithContentsOfFile:imagePath];
        
        if (result) {
            self.dictionary[key] = result;
        } else {
            NSLog(@"找不到图片路径");
        }
    }
    
    return result;
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
    NSString *imagePath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
    
}

#pragma mark - save image
- (NSString *)imagePathForKey:(NSString *)key
{
    NSLog(@"%@", key);
//    得到Document目录的全路径，返回值为一个数组
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    从数组中获取第一个也是唯一文档目录路径（之所以有这句是因为在Mac系统中可能有多个目录匹配）
    NSString *documentDirectory = [documentDirectories firstObject];
//    在路径后拼接上固化文件文件名（此处以图片的键为文件名）
    return [documentDirectory stringByAppendingPathComponent:key];
}

#pragma mark - clear cache
- (void)clearCache:(NSNotificationCenter *)note {
    NSLog(@"清楚了缓存中的%lu张图片", (unsigned long)[self.dictionary count]);
    [self.dictionary removeAllObjects];
}













@end

//
//  CJGeneralViewController.m
//  示例-ItcastWeibo
//
//  Created by MJ Lee on 14-5-4.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "CJGeneralViewController.h"
#import "CJSettingArrowItem.h"
#import "CJSettingSwitchItem.h"
#import "CJSettingLabelItem.h"
#import "CJSettingGroup.h"
#import "MBProgressHUD+MJ.h"
#import "SDWebImageManager.h"
#import "NSString+Extension.h"
//extern FMDatabaseQueue *_queue;
#import "CJStatusCacheTool.h"

@interface CJGeneralViewController ()

@end

@implementation CJGeneralViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
    [self setupGroup3];
    [self setupGroup4];


}

- (void)setupGroup0
{
    CJSettingGroup *group = [self addGroup];
    
    CJSettingArrowItem *read = [CJSettingArrowItem itemWithTitle:@"阅读模式" destVcClass:nil];
    
    CJSettingArrowItem *font = [CJSettingArrowItem itemWithTitle:@"字号大小" destVcClass:nil];
    
    CJSettingSwitchItem *mark = [CJSettingSwitchItem itemWithTitle:@"显示备注"];
    
    group.items = @[read, font, mark];
}

- (void)setupGroup1
{
    CJSettingGroup *group = [self addGroup];
    
    CJSettingArrowItem *picture = [CJSettingArrowItem itemWithTitle:@"图片质量设置" destVcClass:nil];
    group.items = @[picture];
}

- (void)setupGroup2
{
    CJSettingGroup *group = [self addGroup];
    
    CJSettingSwitchItem *voice = [CJSettingSwitchItem itemWithTitle:@"声音"];
    group.items = @[voice];
}

- (void)setupGroup3
{
    CJSettingGroup *group = [self addGroup];
    
    CJSettingSwitchItem *language = [CJSettingSwitchItem itemWithTitle:@"多语言环境"];
    group.items = @[language];
}

- (void)setupGroup4
{
    CJSettingGroup *group = [self addGroup];
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    CJSettingLabelItem *clearCache = [CJSettingLabelItem itemWithTitle:@"清除图片缓存"];
    __weak typeof(clearCache) weakCache = clearCache;
    clearCache.text = [cachePath fileSize];
    clearCache.opreation = ^{ // 清除缓存

        // 执行清除缓存
        NSFileManager *mgr = [NSFileManager defaultManager];

        NSArray *subpaths = [mgr subpathsAtPath:cachePath];

        for (NSString *subpath in subpaths) {
        
            NSString *fullpath = [cachePath stringByAppendingPathComponent:subpath];
            
            [mgr removeItemAtPath:fullpath error:nil];
        }
        [CJStatusCacheTool initialize];
        
        // 关闭弹框
        [MBProgressHUD showSuccess:@"清除成功"];
        
        weakCache.subtitle = [cachePath fileSize];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:4];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    CJSettingArrowItem *clearHistory = [CJSettingArrowItem itemWithTitle:@"清空搜索历史"];
    group.items = @[clearCache, clearHistory];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

@end

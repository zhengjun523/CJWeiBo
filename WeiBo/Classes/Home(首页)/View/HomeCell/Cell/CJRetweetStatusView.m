//
//  CJRetweetStatusView.m
//  WeiBo
//
//  Created by mac527 on 15/9/15.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import "CJRetweetStatusView.h"
#import "CJStatus.h"
#import "CJPhoto.h"
#import "CJStatusPhotosView.h"
#import "CJStatusFrame.h"
#import "CJStatusLabelTextView.h"
#import "UIImageView+WebCache.h"
#import "CJRetweetStatusToolBar.h"
#import "CJDetailViewController.h"
@interface CJRetweetStatusView()
/**
 *  被转发用户的昵称
 */
//@property (nonatomic, weak) UILabel *retweetNameLabel;
/**
 *  被转发用户的正文
 */
@property (nonatomic, weak) CJStatusLabelTextView *retweetContentLabel;
/**
 *  被转发微博的配图
 */
@property (nonatomic, weak) CJStatusPhotosView *retweetPhotosView;
/**
 *  被转发微博的工具条
 */
@property (nonatomic, weak) CJRetweetStatusToolBar *retweetToolBar;
@end

@implementation CJRetweetStatusView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        // 设置背景图片
//        self.image = [UIImage resizedImageWithName:@"timeline_retweet_background" left:0.9 top:0.5];
        self.backgroundColor = CJColor(245, 245, 245);
        
        /**  被转发微博的正文 */
        CJStatusLabelTextView *retweetContentLabel = [[CJStatusLabelTextView alloc] init];
        [self addSubview:retweetContentLabel];
        self.retweetContentLabel = retweetContentLabel;
        
        /**  被转发微博的配图 */
        CJStatusPhotosView *retweetPhotosView = [[CJStatusPhotosView alloc] init];
        [self addSubview:retweetPhotosView];
        self.retweetPhotosView = retweetPhotosView;
        
        /**  被转发微博的工具条 */
        CJRetweetStatusToolBar *retweetToolBar = [[CJRetweetStatusToolBar alloc] init];
        [self addSubview:retweetToolBar];
        self.retweetToolBar = retweetToolBar;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
#warning 小tips -- 不发通知给控制器跳转
    // 获取根控制器
    UITabBarController *tabBarVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = (UINavigationController *)tabBarVc.selectedViewController;
    
    // 跳转控制器
    CJDetailViewController *detailVc = [[CJDetailViewController alloc] init];
    
    detailVc.status = self.statusFrame.status.retweeted_status;
    
    [nav pushViewController:detailVc animated:YES];
}

- (void)setStatusFrame:(CJStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    CJStatus *retReetStatus = self.statusFrame.status.retweeted_status;
    
    // 1.正文
    self.retweetContentLabel.speicalRects = nil;
    self.retweetContentLabel.attributedText = retReetStatus.retweetedAttributedSting;
    self.retweetContentLabel.frame = self.statusFrame.retweetContentLabelF;
    
    // 2.配图
    if (retReetStatus.pic_urls.count) { // 有配图
        self.retweetPhotosView.hidden = NO;
        self.retweetPhotosView.photos = retReetStatus.pic_urls;
        self.retweetPhotosView.frame = self.statusFrame.retweetPhotosViewF;
    }else { // 无配图
        self.retweetPhotosView.hidden = YES;
    }
    
    // 3.工具条
    if (retReetStatus.isDetail) {
        self.retweetToolBar.frame = statusFrame.retweetToolBarF;
//        NSLog(@"%@",self.retweetToolBar.frame);
        self.retweetToolBar.status = retReetStatus;
        self.retweetToolBar.hidden = NO;
    }else{
        self.retweetToolBar.hidden = YES;
    }
}


@end

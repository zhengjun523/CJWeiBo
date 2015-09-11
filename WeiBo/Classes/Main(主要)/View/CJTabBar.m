//
//  CJTabBar.m
//  WeiBo
//
//  Created by mac527 on 15/9/9.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import "CJTabBar.h"
#import "CJTabBarButton.h"
@interface CJTabBar()

@property (nonatomic ,weak) CJTabBarButton *selectedButton;

@property (nonatomic ,strong) NSMutableArray *allTabBarButton;

@property (nonatomic ,weak) UIButton *plusButton;

@end

@implementation CJTabBar

- (instancetype)initWithFrame:(CGRect)frame
{

    if (self == [super initWithFrame:frame]) {
        
        UIButton *plusButton = [[UIButton alloc] init];
        
        [plusButton setBackgroundImage:[UIImage imageWithName:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [plusButton setBackgroundImage:[UIImage imageWithName:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        
        [plusButton setImage:[UIImage imageWithName:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [plusButton setImage:[UIImage imageWithName:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        plusButton.bounds = CGRectMake(0, 0, plusButton.currentBackgroundImage.size.width, 53);
        
        [self addSubview:plusButton];
        self.plusButton = plusButton;
        
        
    }
    
    return  self;
}


- (NSMutableArray *)allTabBarButton
{

    if (_allTabBarButton == nil) {
        
        _allTabBarButton = [NSMutableArray array];
    }
    return _allTabBarButton;
}


/**
 *  添加一个 UITabBarItem
 */
- (void)addTabBarButtonWithItem:(UITabBarItem *)item
{

    CJTabBarButton *button = [[CJTabBarButton alloc] init];
    
    button.item = item;
    
    [self addSubview:button];

    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    [self.allTabBarButton addObject:button];
}


/**
 *  监听点击事件 切换控制器
 */
- (void)buttonClick:(CJTabBarButton *)button
{
    
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectedButtonFrom:(self.selectedButton.tag - 2015) to:(button.tag - 2015)];
        
    }
    
    self.selectedButton.selected = NO;

    button.selected = YES;
    
    self.selectedButton = button;

}


/**
 *  调整子控件位置
 */
- (void)layoutSubviews
{

    [super layoutSubviews];
    
    
    self.plusButton.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    
    CGFloat Y = 0;
    CGFloat W = kWidth / self.subviews.count;
    CGFloat H = self.frame.size.height;
    

    for (int index = 0 ;index < self.allTabBarButton.count ; index ++)
    {

        CJTabBarButton *button = self.allTabBarButton[index];
        
        CGFloat X = W * index;
        if (index > 1) {
            X = W * (index + 1);
        }
        button.frame = CGRectMake(X, Y, W, H);
     
        button.tag = 2015 + index;
        
        if (index == 0) {
            [self buttonClick:button];
        }
        

    }

}



@end

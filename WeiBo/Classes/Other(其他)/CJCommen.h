//
//  CJComment.h
//  WeiBo
//
//  Created by mac527 on 15/9/17.
//  Copyright (c) 2015年 mac527. All rights reserved.
//  存放宏


#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
// 0.0判断是否为iOS7
#define iOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)



// 1.获得RGB颜色
#define CJColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 1.1随机色
#define CJRandomColor CJColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
// 1.2全局背景颜色
#define CJGlobelBackgroundColor CJColor(226, 226, 226)

// 2.自定义Log
#ifdef DEBUG
#define CJLog(...) NSLog(__VA_ARGS__)
#else
#define CJLog(...)
#endif

// 3.定义导航栏文字颜色
#define navButtonColor [UIColor colorWithWhite:0.400 alpha:1.000]

// 4.微博cell相关属性
/** 表格的边框宽度 */
#define CJStatusFrameBorder 10
/** cell的边框宽度 */
#define CJStatusCellBorder 10

/** 昵称的字体 */
#define CJStatusNameFont [UIFont systemFontOfSize:15];
/** 被转发微博作者昵称的字体 */
#define CJRetweetStatusNameFont [UIFont systemFontOfSize:15]

/** 时间的字体 */
#define CJStatusTimeFont [UIFont systemFontOfSize:12]
/** 来源的字体 */
#define CJStatusSourceFont [UIFont boldSystemFontOfSize:12]

/** 正文的字体 */
#define CJStatusContentFont [UIFont systemFontOfSize:17]
/** 被转发微博正文的字体 */
#define CJRetweetStatusContentFont [UIFont systemFontOfSize:17]

// 5.微博cell配图相关属性
// 多张配图时图片尺寸
#define CJPhotosWH 100

// 6.表情键盘
// 一页中最多3行
#define CJEmotionMaxRows 3
// 一行中最多7列
#define CJEmotionMaxCols 7
// 每一页的表情个数
#define CJMaxEmotionCount ((CJEmotionMaxCols * CJEmotionMaxRows) - 1)
// 表情间距
#define CJPageViewInset 10

// 7.微博配图
// 只有一张配图时图片尺寸
#define CJPhotoWH 140
#define CJPhotosMargin 10



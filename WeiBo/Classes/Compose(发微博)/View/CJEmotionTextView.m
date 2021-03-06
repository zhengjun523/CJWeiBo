//
//  CJEmotionTextView.m
//  WeiBo
//
//  Created by mac527 on 15/9/25.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import "CJEmotionTextView.h"
#import "CJEmotion.h"
#import "NSString+Emoji.h"
#import "UITextView+CJ.h"
#import "CJEmotionAttachment.h"

@implementation CJEmotionTextView

/**
 *  插入一个表情
 */
- (void)insertEmotion:(CJEmotion *)emotion
{

    if (emotion.code) { // emoji
        
        [self insertText:emotion.code.emoji];
        
    }else if (emotion.png){ // 图片
        CJEmotionAttachment *attac = [[CJEmotionAttachment alloc] init];
        attac.emotion = emotion;
        attac.bounds = CGRectMake(0, -4, self.font.lineHeight, self.font.lineHeight);
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attac];
        
        [self insertAttributedText:imageStr];
    }
}


/**
 *  获取所有文字
 */
- (NSString *)fullText
{
    NSMutableString *fullText = [NSMutableString string];
    
    // 遍历所有的属性文字（图片、emoji、普通文字）
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        // 如果是图片表情
        CJEmotionAttachment *attch = attrs[@"NSAttachment"];
        if (attch) { // 图片
            [fullText appendString:attch.emotion.chs];
        } else { // emoji、普通文本
            // 获得这个范围内的文字
            NSAttributedString *str = [self.attributedText attributedSubstringFromRange:range];
            [fullText appendString:str.string];
        }
    }];
    
    return fullText;
}
@end

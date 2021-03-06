//
//  CJComposeViewController.m
//  WeiBo
//
//  Created by mac527 on 15/9/17.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import "CJComposeViewController.h"
#import "CJComposeTool.h"
#import "CJAccountTool.h"
#import "CJAccount.h"
#import "CJEmotionTextView.h"
#import "CJFarmData.h"
#import "CJComposeToolBar.h"
#import "MBProgressHUD+MJ.h"
#import "CJEmotionKeyborad.h"
#import "CJEmotion.h"

@interface CJComposeViewController () <UITextViewDelegate,CJComposeToolBarDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,CJTextViewDelegate>

@property (nonatomic ,weak) CJEmotionTextView *textView;
@property (nonatomic ,weak) CJComposeToolBar *toolBar;
@property (nonatomic ,weak) UIImageView *imageView;

#warning 一定要用strong保住他的命
@property (nonatomic ,strong) CJEmotionKeyborad *emotionKeyboard;
@end

@implementation CJComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏内容
    [self setupNavBar];
    // 设置textView
    [self setupTextView];
    
    // 设置imageView
    [self setupImageView];
    
    // 设置工具条
    [self setupToolBar];
    

}
/**
 *  懒加载
 *
 *  @return 返回一个_emotionKeyboard
 */
- (CJEmotionKeyborad *)emotionKeyboard
{
 
    if (_emotionKeyboard == nil) {
        _emotionKeyboard = [[CJEmotionKeyborad alloc] init];
        _emotionKeyboard.frame = CGRectMake(0, 0, self.view.width, 216);
    }
    return _emotionKeyboard;
}

/**
 *  ViewDidLoad中 设置self.navigationItem.rightBarButtonItem.enabled 的颜色无效。。。 ios 8 Bug；
 */
- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];

    // 弹出键盘
    [self.textView becomeFirstResponder];
    
}

/**
 *  设置导航栏
 */
- (void)setupNavBar
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发微博";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor orangeColor]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:CJColor(254, 254, 254)] forState:UIControlStateDisabled];
    [button setBackgroundImage:[UIImage imageWithColor:CJColor(117, 55, 8)] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:CJColor(207, 207, 207) forState:UIControlStateDisabled];
    [button setTitle:@"发送" forState:UIControlStateNormal];
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    button.layer.borderWidth = 0.5;
    button.layer.cornerRadius = 2;
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    button.frame = CGRectMake(0, 0, 40, 25);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
/**
 *  设置textView
 */
- (void)setupTextView
{
    CJEmotionTextView *textView = [[CJEmotionTextView alloc] init];
    textView.frame = self.view.bounds;
    textView.placeholder = @"分享点新鲜事...";
    textView.alwaysBounceVertical = YES;
    textView.delegate = self;
    textView.CJdelegate = self;
    [self.view addSubview:textView];
    self.textView = textView;
    
    // 添加通知 监听文字改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
    
    // 键盘弹出消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 添加表情通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionSelected:) name:CJEmotionKeyboardDidSelectedNotification object:nil];
    
    // 删除按钮通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDeleted:) name:CJEmitionkeyboardDidDeletedNotification object:nil];
}


/**
 *  键盘弹出会调用
 */
- (void)keyboardWillShow:(NSNotification *)note
{

    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 取出键盘高度
    CGFloat keyboardY = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    // 动画时间
    [UIView animateWithDuration:duration animations:^{
        
        self.toolBar.transform = CGAffineTransformMakeTranslation(0, -keyboardY);
    }];

}

/**
 *  键盘关闭会调用
 */
- (void)keyboardWillHide:(NSNotification *)note
{
    
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 动画时间
    [UIView animateWithDuration:duration animations:^{
        
            self.toolBar.transform = CGAffineTransformIdentity;
    
    }];

}
/**
 *  设置工具条
 */
- (void)setupToolBar
{
    CJComposeToolBar *toolBar = [[CJComposeToolBar alloc] init];
    CGFloat toolBarX = 0;
    CGFloat toolBarW = self.view.frame.size.width;
    CGFloat toolBarH = 44;
    CGFloat toolBarY = self.view.frame.size.height - toolBarH;
    toolBar.frame = CGRectMake(toolBarX, toolBarY, toolBarW, toolBarH);
    toolBar.delegate = self;
    [self.view addSubview:toolBar];
    self.toolBar = toolBar;
}

/**
 *  设置imageView
 */
- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(10, 120, 70, 70);
    [self.view addSubview:imageView];
    self.imageView = imageView;

}

#pragma mark - CJComposeToolBar 代理方法
- (void)composeToolBar:(CJComposeToolBar *)toolBar didClickButton:(CJComposeToolBarButtonType)type
{
    
    
    switch (type) {
        case CJComposeToolBarButtonTypeCamera:
            [self openCemera];
            break;
        case CJComposeToolBarButtonTypePhotoLibrary:
            [self openPhotoLibaray];
            break;
        case CJComposeToolBarButtonTypeMention:  // @
            break;
        case CJComposeToolBarButtonTypeTrend: // #
            break;
        case CJComposeToolBarButtonTypeEmotion:
            [self ClickEmotionButton];  // 表情
            break;
            
        default:
            break;
    }


}
/**
 *  打开相机
 */
- (void)openCemera
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}
/**
 *  打开相册
 */
- (void)openPhotoLibaray
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];

}

#pragma mark - 监听方法
/**
 *  表情被选中了
 *
 *  @param notification 通知
 */
- (void)emotionSelected:(NSNotification *)notification
{

    CJEmotion *emotion = notification.userInfo[CJselectedEmotionKey];
    
    [self.textView insertEmotion:emotion];
}
/**
 *  自定义表情键盘的删除按钮被选点击了
 *
 *  @param notification 通知
 */
- (void)emotionDeleted:(NSNotification *)notification
{
    [self.textView deleteBackward];
}

/**
 *  状态栏表情按钮被点击
 */
- (void)ClickEmotionButton
{
    if (self.textView.inputView == nil) { // 系统键盘
        

        self.textView.inputView = self.emotionKeyboard;
        self.toolBar.showEmotionKeyboard = NO;
        
    }else {  // 表情键盘
    
        self.textView.inputView = nil;
        self.toolBar.showEmotionKeyboard = YES;
    }

    [self.textView endEditing:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textView becomeFirstResponder];
    });
    
}

#pragma mark - UIImagePickerController 代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //  销毁picker控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //  取出图片
    self.imageView.image = info[UIImagePickerControllerOriginalImage];
    
}

#pragma mark - textView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    [self.textView endEditing:YES];
    
}
/**
 *  当textView中输入了属性文字
 */
- (void)textViewAttributedTextDidChange:(CJTextView *)textView
{

    [self textDidChange];

}


/**
 *  通知： 当textView中的文字改变了
 */
- (void)textDidChange
{
    
    self.navigationItem.rightBarButtonItem.enabled = self.textView.text.length | self.textView.attributedText.length;

}

- (void)cancel
{
    [self.textView endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];

}

/**
 *  发送
 */
- (void)send
{
    if (self.imageView.image) {
        [self sendStatusWithPhoto];
    }else{
        [self sendStatusWithoutPhoto];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

/**
 *  有图
 */
- (void)sendStatusWithPhoto
{
    // 1.封装请求参数
    CJComposeParma *parma = [CJComposeParma parma];
    parma.status = self.textView.fullText;

    
    // 2.封装复杂请求参数
    NSData *data = UIImageJPEGRepresentation(self.imageView.image, 0.1);
    
    CJFarmData *farmData = [[CJFarmData alloc] initWithData:data name:@"pic" fileName:@"" mimeType:@"image/jpeg"];
    NSArray *farmDatas = @[farmData];
    
    [CJComposeTool composeWithparameters:parma farmDatas:farmDatas success:^(CJComposeResult *result) {
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];
}

/**
 *  无图
 */
- (void)sendStatusWithoutPhoto
{
    // 1.封装请求参数
    CJComposeParma *param = [CJComposeParma parma];
    param.status = self.textView.fullText;
    
    // 2.发送请求
    [CJComposeTool composeWithParameters:param success:^(CJComposeResult *result) {
      [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(NSError *error) {
      [MBProgressHUD showError:@"发送失败"];
    }];
}
@end

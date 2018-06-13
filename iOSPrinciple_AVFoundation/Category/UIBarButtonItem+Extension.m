#import "UIBarButtonItem+Extension.h"
#import "UIView+GMCategory.h"

@implementation UIBarButtonItem (Extension)


+(instancetype)itemWithImageName:(NSString *)imageName  target:(id)target action:(SEL)action
{
  
    //初始化一个自定义view(UIButton)
    UIButton *button = [[UIButton alloc] init];
    //设置不同状态显示的图片
//    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlighted",imageName]] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.size = button.currentImage.size;
    //添加点击事件
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
    
}

+(instancetype)itemWithImageName:(NSString *)imageName  title:(NSString *)title target:(id)target action:(SEL)action
{
    //初始化一个自定义view(UIButton)
    UIButton *button = [[UIButton alloc] init];
    //设置不同状态显示的图片
//    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlighted",imageName]] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];

    //设置button的文字
    [button setTitle:title forState:UIControlStateNormal];
    
    [button sizeToFit];
    //添加点击事件
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIColor *selColor =[UIColor colorWithRed:26/255.0 green:108/255.0 blue:133/255.0 alpha:1.0];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:selColor forState:UIControlStateHighlighted];
    [button sizeToFit];
    return [[UIBarButtonItem alloc]initWithCustomView:button];

}


+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    //设置不同状态下的文字颜色
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [button sizeToFit];
    
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}


@end

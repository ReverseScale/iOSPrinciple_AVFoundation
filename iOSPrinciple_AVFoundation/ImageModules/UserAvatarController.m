//
//  UserAvatarController.m
//  iOSPrinciple_AVFoundation
//
//  Created by WhatsXie on 2018/6/13.
//  Copyright © 2018年 WhatsXie. All rights reserved.
//

#import "UserAvatarController.h"
#import "AvatarPhotoController.h"

@interface UserAvatarController ()
@property (nonatomic,strong) UIImageView * iconImage;

@end

@implementation UserAvatarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createViews];
}

- (void)createViews {
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 200, 200)];
    GM_BorderRadius(self.iconImage, 100, 1, [UIColor blackColor]);
    self.iconImage.backgroundColor = [UIColor lightGrayColor];
    self.iconImage.centerX = self.view.centerX;
    self.iconImage.centerY = self.view.centerY;
    self.iconImage.userInteractionEnabled = YES;
    [self.iconImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImageClick:)]];
    [self.view addSubview:_iconImage];
}

- (void)avatarImageClick:(UITapGestureRecognizer *)sender {
    [self popAlertToChoosePhoto];
}

- (void)popAlertToChoosePhoto {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"相机");
        [self getSourceWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"相册");
        [self getSourceWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)getSourceWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    PhotoNaviStyle * config = [[PhotoNaviStyle alloc] init];
    config.navBarTintColor = [UIColor whiteColor];
    config.navBarBgColor = [UIColor colorWithRed:48/255.0 green:50/255.0 blue:57/255.0 alpha:1];
    config.navBarTitleColor = [UIColor whiteColor];
    
    [[AvatarPhotoController creatWithSourceType:sourceType config:config] getSourceWithSelectImageBlock:^(id data) {
        if ([data isKindOfClass:[UIImage class]]) {
            [self.iconImage setImage:(UIImage *)data];
        } else {
            NSLog(@"所选内容非图片对象");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

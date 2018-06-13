//
//  AvatarPhotoController.h
//  iOSPrinciple_AVFoundation
//
//  Created by WhatsXie on 2018/6/13.
//  Copyright © 2018年 WhatsXie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoNaviStyle;
typedef void(^AvatarPhotoBlock)(id data);


@interface AvatarPhotoController : UIImagePickerController
+ (instancetype)creatWithSourceType:(UIImagePickerControllerSourceType)sourceType config:(PhotoNaviStyle *)config;
- (void)getSourceWithSelectImageBlock:(AvatarPhotoBlock)selectImageBlock;
@end


@interface PhotoNaviStyle: NSObject
@property (nonatomic,strong) UIColor *navBarBgColor;
@property (nonatomic,strong) UIColor *navBarTintColor;
@property (nonatomic,strong) UIColor *navBarTitleColor;
@end

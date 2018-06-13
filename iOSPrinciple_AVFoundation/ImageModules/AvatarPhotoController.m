//
//  AvatarPhotoController.m
//  iOSPrinciple_AVFoundation
//
//  Created by WhatsXie on 2018/6/13.
//  Copyright © 2018年 WhatsXie. All rights reserved.
//

#import "AvatarPhotoController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface AvatarPhotoDelegate: NSObject <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,copy) AvatarPhotoBlock selectImageBlock;
@end

@implementation AvatarPhotoDelegate
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker setNavigationBarHidden:YES];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:( NSString *)kUTTypeImage]) {
        UIImage *image = nil;
        if ([picker allowsEditing]) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        if (_selectImageBlock) {
            _selectImageBlock(image);
        }
    } else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
        if (_selectImageBlock) {
            _selectImageBlock(mediaURL);
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end


@interface AvatarPhotoController ()
@property (nonatomic,strong) AvatarPhotoDelegate * delegateHelper;
@end

@implementation AvatarPhotoController
+ (instancetype)creatWithSourceType:(UIImagePickerControllerSourceType)sourceType config:(PhotoNaviStyle *)config {
    AvatarPhotoController *imagePicker = [[AvatarPhotoController alloc] init];
    imagePicker.delegateHelper = [[AvatarPhotoDelegate alloc] init];
    imagePicker.delegate = imagePicker.delegateHelper;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    } else {
        imagePicker.sourceType = sourceType;
    }
    
    UIColor *navBarTintColor  = nil;
    UIColor *navBarBgColor    = nil;
    UIColor *navBarTitleColor = nil;
    
    navBarTintColor = config && config.navBarTintColor ?  config.navBarTintColor : [UIColor colorWithRed:0.21 green:0.57 blue:0.98 alpha:1.0];
    navBarBgColor = config && config.navBarBgColor ? config.navBarBgColor : [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
    navBarTitleColor = config && config.navBarTitleColor ? config.navBarTitleColor : [UIColor blackColor];
    
    imagePicker.allowsEditing = YES;
    [imagePicker.navigationBar setBarTintColor:navBarBgColor];
    [imagePicker.navigationBar setTranslucent:NO];
    [imagePicker.navigationBar setTintColor:navBarTintColor];
    [imagePicker.navigationBar setBackgroundColor:navBarBgColor];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = navBarTitleColor;
    [imagePicker.navigationBar setTitleTextAttributes:attrs];
    
    return imagePicker;
}

- (void)getSourceWithSelectImageBlock:(AvatarPhotoBlock)selectImageBlock {
    self.delegateHelper.selectImageBlock = selectImageBlock;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self animated:YES completion:nil];
}
@end

@implementation PhotoNaviStyle

@end

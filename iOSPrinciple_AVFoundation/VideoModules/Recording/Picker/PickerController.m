//
//  PickerController.m
//  iOSPrinciple_AVFoundation
//
//  Created by WhatsXie on 2018/6/8.
//  Copyright © 2018年 WhatsXie. All rights reserved.
//

#import "PickerController.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PickerController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation PickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![self isVideoRecordingAvailable]) {
        return;
    }
    
    self.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.mediaTypes = @[(NSString *)kUTTypeMovie];
    self.delegate = self;

}

#pragma mark 自定义方法

- (void)startRecorder {
    [self startVideoCapture];
}

- (void)stopRecoder {
    [self stopVideoCapture];
}

#pragma mark - Private methods
- (BOOL)isVideoRecordingAvailable {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if([availableMediaTypes containsObject:(NSString *)kUTTypeMovie]){
            return YES;
        }
    }
    return NO;
}

- (void)switchCameraIsFront:(BOOL)front {
    if (front) {
        if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]){
            [self setCameraDevice:UIImagePickerControllerCameraDeviceFront];
        }
    } else {
        if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]){
            [self setCameraDevice:UIImagePickerControllerCameraDeviceRear];
        }
    }
}


//隐藏系统自带的UI，可以自定义UI
- (void)configureCustomUIOnImagePicker {
    self.showsCameraControls = NO;
    
    UIView *cameraOverlay = [[UIView alloc] init];
    self.cameraOverlayView = cameraOverlay;
}

#pragma mark - UIImagePickerControllerDelegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //录制完的视频保存到相册
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    NSURL *recordedVideoURL= [info objectForKey:UIImagePickerControllerMediaURL];
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:recordedVideoURL]) {
        [library writeVideoAtPathToSavedPhotosAlbum:recordedVideoURL
                                    completionBlock:^(NSURL *assetURL, NSError *error){}
         ];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

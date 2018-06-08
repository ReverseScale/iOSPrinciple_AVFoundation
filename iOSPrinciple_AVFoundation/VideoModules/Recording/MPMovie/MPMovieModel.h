//
//  MPMoiveModel.h
//  iOSPrinciple_AVFoundation
//
//  Created by WhatsXie on 2018/6/8.
//  Copyright © 2018年 WhatsXie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//录制视频的长宽比
typedef NS_ENUM(NSInteger, MPVideoViewType) {
    Type1X1 = 0,
    Type4X3,
    TypeFullScreen
};

//闪光灯状态
typedef NS_ENUM(NSInteger, FMFlashState) {
    FMFlashClose = 0,
    FMFlashOpen,
    FMFlashAuto,
};

//录制状态
typedef NS_ENUM(NSInteger, FMRecordState) {
    FMRecordStateInit = 0,
    FMRecordStateRecording,
    FMRecordStatePause,
    FMRecordStateFinish,
};


@protocol MPModelDelegate <NSObject>

- (void)updateFlashState:(FMFlashState)state;
- (void)updateRecordingProgress:(CGFloat)progress;
- (void)updateRecordState:(FMRecordState)recordState;

@end

@interface MPMovieModel : NSObject
@property (nonatomic, weak  ) id<MPModelDelegate>delegate;
@property (nonatomic, assign) FMRecordState recordState;
@property (nonatomic, strong, readonly) NSURL *videoUrl;
- (instancetype)initWithFMVideoViewType:(MPVideoViewType )type superView:(UIView *)superView;

- (void)turnCameraAction;
- (void)switchflash;
- (void)startRecord;
- (void)stopRecord;
- (void)reset;
@end

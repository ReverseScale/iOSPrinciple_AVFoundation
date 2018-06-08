//
//  MPVideoView.h
//  iOSPrinciple_AVFoundation
//
//  Created by WhatsXie on 2018/6/8.
//  Copyright © 2018年 WhatsXie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMovieModel.h"

@protocol MPMovieVideoViewDelegate <NSObject>

- (void)dismissVC;
- (void)recordFinishWithvideoUrl:(NSURL *)videoUrl;

@end

@interface MPMovieVideoView : UIView
@property (nonatomic, assign) MPVideoViewType viewType;
@property (nonatomic, strong, readonly) MPMovieModel *mpModel;
@property (nonatomic, weak) id <MPMovieVideoViewDelegate> delegate;

- (instancetype)initWithFMVideoViewType:(MPVideoViewType)type;
- (void)reset;
@end

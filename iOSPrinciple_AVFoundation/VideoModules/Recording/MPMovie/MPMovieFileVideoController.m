//
//  MPMovieFileVideoController.m
//  iOSPrinciple_AVFoundation
//
//  Created by WhatsXie on 2018/6/8.
//  Copyright © 2018年 WhatsXie. All rights reserved.
//

#import "MPMovieFileVideoController.h"
#import "MPMovieVideoView.h"
#import "MovieVideoViewController.h"
@interface MPMovieFileVideoController ()<MPMovieVideoViewDelegate>
@property (nonatomic, strong) MPMovieVideoView *videoView;

@end

@implementation MPMovieFileVideoController

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    _videoView = [[MPMovieVideoView alloc] initWithFMVideoViewType:TypeFullScreen];
    _videoView.delegate = self;
    [self.view addSubview:_videoView];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_videoView.mpModel.recordState == FMRecordStateFinish) {
        [_videoView reset];
    }
    
}
#pragma mark - FMFVideoViewDelegate
- (void)dismissVC {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)recordFinishWithvideoUrl:(NSURL *)videoUrl {
    MovieVideoViewController *playVC = [[MovieVideoViewController alloc] init];
    playVC.videoUrl =  videoUrl;
    [self.navigationController pushViewController:playVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

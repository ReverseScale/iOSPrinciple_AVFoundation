//
//  ZFPlayerViewController.m
//  iOSPrinciple_AVFoundation
//
//  Created by WhatsXie on 2018/6/5.
//  Copyright © 2018年 WhatsXie. All rights reserved.
//

#import "ZFPlayerViewController.h"
#import <KTVHTTPCache/KTVHTTPCache.h>
#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
#import "ZFPlayerControlView.h"

@interface ZFPlayerViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@end

@implementation ZFPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupHTTPCache];
}

- (void)setupHTTPCache {
    [KTVHTTPCache logSetConsoleLogEnable:YES];
    NSError * error;
    [KTVHTTPCache proxyStart:&error];
    if (error) {
        NSLog(@"Proxy Start Failure, %@", error);
    } else {
        NSLog(@"Proxy Start Success");
    }
    
    [KTVHTTPCache cacheSetURLFilterForArchive:^NSString *(NSString *originalURLString) {
        NSLog(@"URL Filter reviced URL : %@", originalURLString);
        return originalURLString;
    }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}


- (IBAction)playClick:(UIButton *)sender {
    [self.controlView resetControlView];
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// 播放器相关
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    self.player.controlView = self.controlView;
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self.view endEditing:YES];
        [self setNeedsStatusBarAppearanceUpdate];
    };
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player enterFullScreen:NO animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.player.orientationObserver.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.player stop];
        });
    };
    
    NSString *URLString = [@"http://tb-video.bdstatic.com/tieba-smallvideo-transcode/3612804_e50cb68f52adb3c4c3f6135c0edcc7b0_3.mp4" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString *proxyURLString = [KTVHTTPCache proxyURLStringWithOriginalURLString:URLString];
    playerManager.assetURL = [NSURL URLWithString:proxyURLString];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - about keyboard orientation

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        [_controlView showTitle:@"视频标题" coverURLString:@"http://imgsrc.baidu.com/forum/eWH%3D240%2C176/sign=183252ee8bd6277ffb784f351a0c2f1c/5d6034a85edf8db15420ba310523dd54564e745d.jpg" fullScreenMode:ZFFullScreenModeLandscape];
    }
    return _controlView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

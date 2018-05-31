//
//  AVAudioPlayerViewController.m
//  iOSPrinciple_AVFoundation
//
//  Created by WhatsXie on 2018/5/31.
//  Copyright © 2018年 WhatsXie. All rights reserved.
//

#import "AVAudioPlayerViewController.h"

@interface AVAudioPlayerViewController ()

@end

@implementation AVAudioPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setAVAudioPlayer];
}

- (void)viewDidAppear:(BOOL)animated {
    //    接受远程控制
    [self becomeFirstResponder];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)viewDidDisappear:(BOOL)animated {
    //    取消远程控制
    [self resignFirstResponder];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

- (void)setAVAudioPlayer {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"dog" withExtension:@"wav"];
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    self.player.delegate = self;
    
    [self setLockShow];
}

- (void)setLockShow {
    //添加通知，拔出耳机后暂停播放
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
    
    //设置锁屏仍能继续播放
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    
    self.startLabel.text = [NSString stringWithFormat:@"%f",self.player.currentTime];
    self.endLabel.text = [NSString stringWithFormat:@"%f",self.player.duration];
    
    [self setPlayingInfo];
}

- (void)setPlayingInfo {
    //    设置后台播放时显示的东西，例如歌曲名字，图片等
    MPMediaItemArtwork *artWork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"dog.jpeg"]];
    
    NSDictionary *dic = @{MPMediaItemPropertyTitle:@"Dog Song",
                          MPMediaItemPropertyArtist:@"Dog",
                          MPMediaItemPropertyArtwork:artWork
                          };
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dic];
}

- (void)updateProgress {
    //进度条显示播放进度
    self.progress.progress = self.player.currentTime/self.player.duration;
    self.startLabel.text = [NSString stringWithFormat:@"%f",self.player.currentTime];
}

#pragma mark - 接收方法的设置
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    //判断是否为远程控制
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case  UIEventSubtypeRemoteControlPlay:
                if (![_player isPlaying]) {
                    [_player play];
                }
                break;
            case UIEventSubtypeRemoteControlPause:
                if ([_player isPlaying]) {
                    [_player pause];
                }
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"下一首");
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"上一首 ");
                break;
                default:
                break;
        }
    }
}

#pragma mark AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (player == _player && flag) {
        [self.startButton setBackgroundImage:[UIImage imageNamed:@"播放"] forState:0];
    }
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    if (player == _player){
        NSLog(@"播放被中断");
    }
}

#pragma mark Action
- (IBAction)startAction:(id)sender {
    if ([self.player isPlaying]) {
        [self.startButton setBackgroundImage:[UIImage imageNamed:@"播放"] forState:0];
        [self.player pause];
    } else {
        [self.startButton setBackgroundImage:[UIImage imageNamed:@"暂停"] forState:0];
        [self.player play];
    }
    
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    }
}

- (IBAction)stopAction:(id)sender {
    [self.player stop];
    //计时器停止
    [_timer invalidate];
    //释放定时器
    _timer = nil;
}

- (void)routeChange:(NSNotification *)notification {
    NSDictionary *dic=notification.userInfo;
    int changeReason= [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    //等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable表示旧输出不可用
    if (changeReason==AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *routeDescription=dic[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription= [routeDescription.outputs firstObject];
        //原设备为耳机则暂停
        if ([portDescription.portType isEqualToString:@"Headphones"]) {
            [self.player pause];
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

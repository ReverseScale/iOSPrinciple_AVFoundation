//
//  AVPlayerViewController.m
//  iOSPrinciple_AVFoundation
//
//  Created by WhatsXie on 2018/5/31.
//  Copyright © 2018年 WhatsXie. All rights reserved.
//

#import "AVPlayerViewController.h"

#import <MediaPlayer/MPRemoteCommandCenter.h>
#import <MediaPlayer/MPRemoteCommand.h>

#import "RSMusicModel.h"
#import "RSPlayerTools.h"

#define ColorForTheme [UIColor colorWithRed:255.0/255.0 green:112.0/255.0 blue:67.0/255.0 alpha:1]

@interface AVPlayerViewController ()
@property(nonatomic,assign) BOOL isSeeking;

@end

@implementation AVPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.timeSlider.thumbTintColor = ColorForTheme;
    self.timeSlider.minimumTrackTintColor = ColorForTheme;
    [self.timeSlider setThumbImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginPlayMusic:) name:HYPlayerToolMusicBeginPlay object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlayMusicTime:) name:HYPlayerToolMusicTimeUpdate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseMusic:) name:HYPlayerToolMusicPause object:nil];
    
    [self setUpData];
    [self setUpDataWithMusic:[RSPlayerTools sharePlayerTool].currentMusic];
    [self remoteControlEventHandler];
}

- (void)setUpData {
    NSMutableArray<RSMusicModel*> *musicArray = [NSMutableArray array];
    NSArray *urlArray = @[@"http://sc1.111ttt.cn/2016/5/09/12/202121719072.mp3",
                          @"http://sc1.111ttt.cn/2016/5/09/12/202121719072.mp3",
                          @"http://sc1.111ttt.cn/2016/5/09/12/202121719072.mp3"];
    
    for (int i = 0; i < urlArray.count; i++) {
        RSMusicModel *musicModel = [[RSMusicModel alloc] initWithTitle:[NSString stringWithFormat:@"播放曲目%d",i+1] songerName:[NSString stringWithFormat:@"%d号歌手",i+1] musicUrl:urlArray[i]];
        
        [musicArray addObject:musicModel];
    }
    
    [RSPlayerTools sharePlayerTool].dataSourceArr = musicArray;
}

- (void)beginPlayMusic:(NSNotification*)noti {
    RSMusicModel *music = noti.object;
    [self setUpDataWithMusic:music];
}

- (void)pauseMusic:(NSNotification*)noti {
    [self.playButton setSelected:NO];
}

- (void)setUpDataWithMusic:(RSMusicModel *)music {
    RSPlayerTools *tool = [RSPlayerTools sharePlayerTool];
    
    //歌曲信息
    self.titleLabel.text = music.songName;
    self.songerLabel.text = music.singerName;
    
    self.title = [NSString stringWithFormat:@"正在播放%zd/%zd",tool.currentIndex+1,tool.dataSourceArr.count];
    
    [self.playButton setSelected:[[RSPlayerTools sharePlayerTool] isPlaying]];
}

- (void)updatePlayMusicTime:(NSNotification*)noti {
    if (!_isSeeking) {
        RSPlayerTools *tool = [RSPlayerTools sharePlayerTool];
        self.startTimeLabel.text = tool.currentTimeStr;
        self.timeSlider.value = tool.currentPercent;
        self.endTimeLabel.text = tool.durationTimeStr;
    }
}


#pragma mark - 音乐控制
// 在需要处理远程控制事件的具体控制器或其它类中实现
- (void)remoteControlEventHandler {
    // 直接使用sharedCommandCenter来获取MPRemoteCommandCenter的shared实例
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    // 启用播放命令 (锁屏界面和上拉快捷功能菜单处的播放按钮触发的命令)
    commandCenter.playCommand.enabled = YES;
    // 为播放命令添加响应事件, 在点击后触发
    [commandCenter.playCommand addTarget:self action:@selector(playAction:)];
    
    // 播放, 暂停, 上下曲的命令默认都是启用状态, 即enabled默认为YES
    // 为暂停, 上一曲, 下一曲分别添加对应的响应事件
    [commandCenter.pauseCommand addTarget:self action:@selector(pauseAction:)];
    [commandCenter.previousTrackCommand addTarget:self action:@selector(previousTrackAction:)];
    [commandCenter.nextTrackCommand addTarget:self action:@selector(nextTrackAction:)];
    
    // 启用耳机的播放/暂停命令 (耳机上的播放按钮触发的命令)
    commandCenter.togglePlayPauseCommand.enabled = YES;
    // 为耳机的按钮操作添加相关的响应事件
    [commandCenter.togglePlayPauseCommand addTarget:self action:@selector(playOrPauseAction:)];
}

- (void)playAction:(id)obj {
    [[RSPlayerTools sharePlayerTool] play];
}
- (void)pauseAction:(id)obj {
    [[RSPlayerTools sharePlayerTool] pause];
}
- (void)nextTrackAction:(id)obj {
    [[RSPlayerTools sharePlayerTool] playNext];
}
- (void)previousTrackAction:(id)obj {
    [[RSPlayerTools sharePlayerTool] playBack];
}
- (void)playOrPauseAction:(id)obj {
    if ([[RSPlayerTools sharePlayerTool] isPlaying]) {
        [[RSPlayerTools sharePlayerTool] pause];
    }else{
        [[RSPlayerTools sharePlayerTool] play];
    }
}

#pragma mark - Action
//点击播放
- (IBAction)clickPlay:(UIButton *)sender {
    if ([[RSPlayerTools sharePlayerTool] isPlaying]) {
        [[RSPlayerTools sharePlayerTool] pause];
        [self.playButton setSelected:NO];
    }else{
        [[RSPlayerTools sharePlayerTool] play];
        [self.playButton setSelected:YES];
    }
}

//点击下一曲
- (IBAction)clickNext:(UIButton *)sender {
    if(![[RSPlayerTools sharePlayerTool] playNext]){
        NSLog(@"已是最后一首");
    }
}

//点击上一曲
- (IBAction)clickPre:(UIButton *)sender {
    if(![[RSPlayerTools sharePlayerTool] playBack]){
        NSLog(@"已是第一首");
    }
}


- (IBAction)didslide:(UISlider *)slider {
    if ([[RSPlayerTools sharePlayerTool] playerItem] == nil) {
        return;
    }
    _isSeeking = YES;
    [[RSPlayerTools sharePlayerTool] pause];
    NSInteger totalSecond =CMTimeGetSeconds([[RSPlayerTools sharePlayerTool] playerItem].duration);
    self.startTimeLabel.text = [[RSPlayerTools sharePlayerTool] timeformatFromSeconds:slider.value*totalSecond];
}

- (IBAction)slideEnd:(UISlider*)sender {
    if ([[RSPlayerTools sharePlayerTool] playerItem] == nil) {
        sender.value = 0.f;
        return;
    }
    [[RSPlayerTools sharePlayerTool] seekTo:sender.value];
    [[RSPlayerTools sharePlayerTool] play];
    _isSeeking = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

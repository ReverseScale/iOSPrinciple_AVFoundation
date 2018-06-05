//
//  AVEqualizerPlayerController.m
//  iOSPrinciple_AVFoundation
//
//  Created by WhatsXie on 2018/6/4.
//  Copyright © 2018年 WhatsXie. All rights reserved.
//

#import "AVEqualizerPlayerController.h"

#import <TheAmazingAudioEngine.h>
#import <AEHighPassFilter.h>
#import <AEParametricEqFilter.h>
#import <AEVarispeedFilter.h>

@interface AVEqualizerPlayerController ()
@property (nonatomic, strong) AEAudioController *audioController;
@property (nonatomic, strong) AEHighPassFilter *filter;
@property (nonatomic, strong) AEAudioFilePlayer *player;
@property (nonatomic, strong) AEAudioFilePlayer *player1;
@property (nonatomic, strong) AEAudioFilePlayer *player2;
@property (nonatomic, strong) UIButton *progressButton;

@property (nonatomic, strong) NSMutableArray *players;
@property (nonatomic, strong) NSMutableArray *seliderArr;
@property (nonatomic, strong) NSMutableArray *seliderValueArr;

@property (nonatomic, assign) BOOL isPlay;
@property (nonatomic, assign) BOOL isAudioMix;
@property (nonatomic, assign) BOOL isShowEqualizer;
@end

@implementation AVEqualizerPlayerController{
    AEParametricEqFilter *_eq31HzFilter;
    AEParametricEqFilter *_eq62HzFilter;
    AEParametricEqFilter *_eq125HzFilter;
    AEParametricEqFilter *_eq250HzFilter;
    AEParametricEqFilter *_eq500HzFilter;
    AEParametricEqFilter *_eq1kFilter;
    AEParametricEqFilter *_eq2kFilter;
    AEParametricEqFilter *_eq4kFilter;
    AEParametricEqFilter *_eq8kFilter;
    AEParametricEqFilter *_eq16kFilter;
    AEVarispeedFilter    *_playbackRateFilter;
    NSArray * _eqFilters;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    
    self.seliderArr = [NSMutableArray array];
    self.seliderValueArr = [NSMutableArray array];
    self.players = [NSMutableArray array];
    self.audioController = [[AEAudioController alloc] initWithAudioDescription:AEAudioStreamBasicDescriptionNonInterleaved16BitStereo inputEnabled:YES];
    
    NSError *error = NULL;
    BOOL result = [_audioController start:&error];
    if ( !result ) {
        NSLog(@"发生错误:%@",error);
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"specialPeople" ofType:@"mp3"];
    self.player = [[AEAudioFilePlayer alloc] initWithURL:[NSURL fileURLWithPath:path] error:&error];
    [self.players addObject:self.player];
    
//    [self playSoundWithURL:[NSURL URLWithString:@"http://sc1.111ttt.cn/2016/5/09/12/202121719072.mp3"]];
    
    [self creatEqFliters];
    [self setSubViews];
    
}

#pragma mark - 音频播放
- (void)playSoundWithURL:(NSURL *)songURL {
    // 创建AEAudioFilePlayer对象
    _player = [[AEAudioFilePlayer alloc] initWithURL:songURL error:nil];
    
    // 进行播放
    [_audioController addChannels:@[_player]];
}


#pragma mark - 界面初始化
- (void)creatEqFliters {
    _eq31HzFilter           = [[AEParametricEqFilter alloc] init];
    _eq62HzFilter           = [[AEParametricEqFilter alloc] init];
    _eq125HzFilter          = [[AEParametricEqFilter alloc] init];
    _eq250HzFilter          = [[AEParametricEqFilter alloc] init];
    _eq500HzFilter          = [[AEParametricEqFilter alloc] init];
    _eq1kFilter             = [[AEParametricEqFilter alloc] init];
    _eq2kFilter             = [[AEParametricEqFilter alloc] init];
    _eq4kFilter             = [[AEParametricEqFilter alloc] init];
    _eq8kFilter            = [[AEParametricEqFilter alloc] init];
    _eq16kFilter            = [[AEParametricEqFilter alloc] init];
    _playbackRateFilter     = [[AEVarispeedFilter alloc] init];
    
    _eqFilters              = @[_eq31HzFilter, _eq62HzFilter, _eq125HzFilter, _eq250HzFilter, _eq500HzFilter, _eq1kFilter, _eq2kFilter, _eq4kFilter, _eq8kFilter, _eq16kFilter, _playbackRateFilter];
}

- (void)setSubViews {
    NSArray *arr = [NSArray arrayWithObjects:@"31",@"62",@"125",@"250",@"500",@"1k",@"2k",@"4k",@"8k",@"16k",@"Volume", @"Speed", nil];
    CGFloat margin = 10;
    
    for (int i = 0; i < 12; i++) {
        
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(20, margin+30*i, CGRectGetWidth(self.view.frame)-100, 20)];
        slider.tag = 1000 + i;
        slider.minimumValue = -5.0;
        slider.minimumTrackTintColor = [UIColor cyanColor];
        slider.maximumValue = 5.0;
        slider.value = 0.0;
        
        if (i == 10) {
            slider.minimumValue = 0.0;
            slider.maximumValue = 1.0;
            slider.value = 0.5;
            [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
        } else if (i == 11) {
            slider.minimumValue = 0.5;
            slider.maximumValue = 2.0;
            slider.value = 1.0;
            [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
        } else {
            [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventTouchUpInside];
            [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventTouchUpOutside];
            [self.seliderArr addObject:slider];
        }
        
        [self.seliderValueArr addObject:[NSString stringWithFormat:@"%f", slider.value]];
        
        [self.equalizerView addSubview:slider];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(slider.frame) + 10, CGRectGetMinY(slider.frame), 100, 20)];
        lab.text = [NSString stringWithFormat:@"%@",arr[i]];
        lab.textColor = [UIColor blackColor];
        lab.font = [UIFont systemFontOfSize:15];
        [self.equalizerView addSubview:lab];
    }
    
    [self.audioController addChannels:@[self.player]];
    
    self.playerSlider.maximumValue = self.player.duration;
    self.endTimeLabel.text = [self stringWithNSTimerinterval:self.player.duration];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(progress) userInfo:nil repeats:YES];
    
    [self.audioController stop];
}

- (void)progress {
    self.startTimeLabel.text = [self stringWithNSTimerinterval:self.player.currentTime];
    self.playerSlider.value = self.player.currentTime;
}

- (IBAction)sliderChanged:(id)sender {
    self.player.currentTime = self.playerSlider.value;
}

#pragma mark - Action
- (IBAction)playAction:(id)sender {
    //开始播放
    if (self.isPlay) {
        [self.audioController stop];
        [self.playButton setSelected:NO];
    } else {
        [self.audioController start:nil];
        [self.playButton setSelected:YES];
    }
    self.isPlay = !self.isPlay;
}

- (IBAction)equalizerAction:(id)sender {
    if (self.isShowEqualizer) {
        [UIView animateWithDuration:0.43 animations:^{
            self.equalizerView.alpha = 0.0;
        }];
    } else {
        [UIView animateWithDuration:0.43 animations:^{
            self.equalizerView.alpha = 0.89;
        }];
    }
    self.isShowEqualizer = !self.isShowEqualizer;
}

- (IBAction)audioMixingAction:(id)sender {
    if (!_isAudioMix) {
        [self.audioController removeChannels:@[self.player]];
        NSString *path1 = [[NSBundle mainBundle] pathForResource:@"dog" ofType:@"wav"];
        self.player1 = [[AEAudioFilePlayer alloc] initWithURL:[NSURL fileURLWithPath:path1] error:nil];
        [self.players addObject:self.player1];
        
        NSString *path2 = [[NSBundle mainBundle] pathForResource:@"sea" ofType:@"wav"];
        self.player2 = [[AEAudioFilePlayer alloc] initWithURL:[NSURL fileURLWithPath:path2] error:nil];
        [self.players addObject:self.player2];
        
        [self.audioController addChannels:@[self.player, self.player1, self.player2]];
        [self.audioController start:nil];
        
        _isAudioMix = YES;
    } else {
        if (self.isPlay) {
            [self.audioController stop];
        } else {
            [self.audioController start:nil];
        }
        
        self.isPlay = !self.isPlay;
    }
}

- (IBAction)resetAction:(id)sender {
    for (int i = 0; i < self.seliderArr.count; i++) {
        UISlider *slider = self.seliderArr[i];
        slider.value = [self.seliderValueArr[i] floatValue];
        [self sliderValueChange:slider];
    }
}

- (void)sliderValueChange:(UISlider *)slider {
    CGFloat value = slider.value;
    NSInteger eqType = 31;
    switch (slider.tag) {
        case 1000:{
            break;
        }
        case 1001:{
            eqType = 62;
            break;
        }
        case 1002:{
            eqType = 125;
            break;
        }
        case 1003:{
            eqType = 250;
            break;
        }
        case 1004:{
            eqType = 500;
            break;
        }
        case 1005:{
            eqType = 1000;
            break;
        }
        case 1006:{
            eqType = 2000;
            break;
        }
        case 1007:{
            eqType = 4000;
            break;
        }case 1008:{
            eqType = 8000;
            break;
        }case 1009:{
            eqType = 16000;
            break;
        }case 1010:{
            self.player.volume = value;
            return;
        }case 1011:{
            [self setupEqFilter:_playbackRateFilter playbackRate:value];
            return;
        }
    }
    [self setupFilterEq:eqType value:value];
}

- (void)setVolume:(float)value {
    for (AEAudioFilePlayer *player in self.players) {
        player.volume = value;
    }
}

//改变音效
- (void)setupFilterEq:(NSInteger)eqType value:(double)gain {
    switch (eqType) {
        case 31: {
            [self setupEqFilter:_eq31HzFilter centerFrequency:31 gain:gain];
            break;
        }
        case 62: {
            [self setupEqFilter:_eq62HzFilter centerFrequency:62 gain:gain];
            break;
        }
        case 125: {
            [self setupEqFilter:_eq125HzFilter centerFrequency:125 gain:gain];
            break;
        }
        case 250: {
            [self setupEqFilter:_eq250HzFilter centerFrequency:250 gain:gain];
            break;
        }
        case 500: {
            [self setupEqFilter:_eq500HzFilter centerFrequency:500 gain:gain];
            break;
        }
        case 1000: {
            [self setupEqFilter:_eq1kFilter centerFrequency:1000 gain:gain];
            break;
        }
        case 2000: {
            [self setupEqFilter:_eq2kFilter centerFrequency:2000 gain:gain];
            break;
        }
        case 4000: {
            [self setupEqFilter:_eq4kFilter centerFrequency:4000 gain:gain];
            break;
        }
        case 8000: {
            [self setupEqFilter:_eq8kFilter centerFrequency:8000 gain:gain];
            break;
        }
        case 16000: {
            [self setupEqFilter:_eq16kFilter centerFrequency:16000 gain:gain];
            break;
        }
    }
}


- (void)setupEqFilter:(AEParametricEqFilter *)eqFilter centerFrequency:(double)centerFrequency gain:(double)gain {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ( ![_audioController.filters containsObject:eqFilter] ) {
            for (AEParametricEqFilter *existEqFilter in _eqFilters) {
                if (eqFilter == existEqFilter) {
                    [self.audioController addFilter:eqFilter];
                    break;
                }
            }
        }
        
        eqFilter.centerFrequency = centerFrequency;
        eqFilter.qFactor         = 1.0;
        eqFilter.gain            = gain;
    });
}

- (void)setupEqFilter:(AEVarispeedFilter *)eqFilter playbackRate:(double)playbackRate {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if ( ![_audioController.filters containsObject:eqFilter] ) {
            for (AEVarispeedFilter *existEqFilter in _eqFilters) {
                if (eqFilter == existEqFilter) {
                    [self.audioController addFilter:eqFilter];
                    break;
                }
            }
        }
        eqFilter.playbackRate   = playbackRate;
    });
}

#pragma mark - Private method
//时间格式化
- (NSString *)stringWithNSTimerinterval:(NSTimeInterval)interval {
    NSInteger min = interval / 60;
    NSInteger sec = (NSInteger)interval % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", min, sec];
}

- (void)dealloc {
    [self.player removeObserver:self forKeyPath:@"duration"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

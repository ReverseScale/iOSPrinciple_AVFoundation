//
//  RecorderViewController.m
//  iOSPrinciple_AVFoundation
//
//  Created by WhatsXie on 2018/6/6.
//  Copyright © 2018年 WhatsXie. All rights reserved.
//

#import "RecorderViewController.h"
#import <AVFoundation/AVFoundation.h>

#define COUNTDOWN 60

@interface RecorderViewController (){
    NSTimer *_timer; //定时器
    NSInteger countDown;  //倒计时
    NSString *filePath;
}
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (nonatomic, strong) AVAudioSession *session;
@property (nonatomic, strong) AVAudioRecorder *recorder;//录音器
@property (nonatomic, strong) AVAudioPlayer *player; //播放器
@property (nonatomic, strong) NSURL *recordFileUrl; //文件地址
@property (nonatomic, assign) BOOL isPlay;
@end

@implementation RecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)startRecord:(id)sender {
    //开始播放
    if (!self.isPlay) {
        [self playRecordingAction];
        [self.playButton setSelected:YES];
    } else {
        [self stopRecordingAction];
        [self.playButton setSelected:NO];
    }
    self.isPlay = !self.isPlay;
}

- (void)playRecordingAction {
    NSLog(@"开始录音");

    countDown = 60;
    [self addTimer];

    // session 准备，后面直接播放
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];

    if (session == nil) {
        NSLog(@"Error creating session: %@",[sessionError description]);
    } else {
        [session setActive:YES error:nil];
    }

    self.session = session;

    [self setFilePath];
}

- (void)setFilePath {
    //1.获取沙盒地址
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    filePath = [path stringByAppendingString:@"/RRecord.wav"];
    
    //2.获取文件路径
    self.recordFileUrl = [NSURL fileURLWithPath:filePath];
    
    //设置参数
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   //采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey,
                                   //音频格式
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   //采样位数  8、16、24、32 默认为16
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                   //音频通道数 1 或 2
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                   //录音质量
                                   [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                                   nil];
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileUrl settings:recordSetting error:nil];
    
    if (_recorder) {
        _recorder.meteringEnabled = YES;
        [_recorder prepareToRecord];
        [_recorder record];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self stopRecordingAction];
        });
    } else {
        NSLog(@"音频格式和文件存储格式不匹配,无法初始化Recorder");
    }
}

- (void)stopRecordingAction {
    [self removeTimer];
    NSLog(@"停止录音");
    
    if ([self.recorder isRecording]) {
        [self.recorder stop];
    }
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        
        _noticeLabel.text = [NSString stringWithFormat:@"录了 %ld 秒,文件大小为 %.2fKb",COUNTDOWN - (long)countDown,[[manager attributesOfItemAtPath:filePath error:nil] fileSize]/1024.0];
    } else {
        _noticeLabel.text = @"最多录60秒";
    }
}

- (IBAction)PlayRecord:(id)sender {
    [self startRecord:nil];
    NSLog(@"播放录音");
    
    if ([self.player isPlaying]) return;
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recordFileUrl error:nil];
    
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.player play];
}

/// 添加定时器
- (void)addTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshLabelText) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)refreshLabelText {
    countDown --;
    _noticeLabel.text = [NSString stringWithFormat:@"还剩 %ld 秒",(long)countDown];
}

/// 移除定时器
- (void)removeTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

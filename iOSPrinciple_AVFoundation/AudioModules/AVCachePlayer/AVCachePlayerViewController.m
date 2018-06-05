//
//  AVCachePlayerViewController.m
//  iOSPrinciple_AVFoundation
//
//  Created by WhatsXie on 2018/6/1.
//  Copyright © 2018年 WhatsXie. All rights reserved.
//

#import "AVCachePlayerViewController.h"
#import "SUPlayer.h"

@interface AVCachePlayerViewController ()
@property (nonatomic, strong) SUPlayer * player;
@property (weak, nonatomic) IBOutlet UIImageView *coverIv;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UIImageView *bgIv;
@property (nonatomic, assign) NSInteger songIndex;
@end

@implementation AVCachePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL * url = [NSURL URLWithString:[self songURLList][self.songIndex]];
    self.player = [[SUPlayer alloc]initWithURL:url];
    
    [self.player addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:nil];
    [self.player addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:nil];
    [self.player addObserver:self forKeyPath:@"cacheProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    [self setBlurEffect];
    [self updateSongInfoShow];
    
    [self.progressSlider addTarget:self action:@selector(changeProgress:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Data
- (NSArray *)songNameList {
    return @[@"大树", @"大海", @"狗子"];
}

- (NSArray *)songURLList {
    return @[@"http://download.lingyongqian.cn/music/AdagioSostenuto.mp3",
             @"http://download.lingyongqian.cn/music/ForElise.mp3",
             @"http://sc1.111ttt.cn/2016/5/09/12/202121719072.mp3"];
}

- (NSArray *)songCoverList {
    return @[@"tree.png", @"sea.png", @"dog.png"];
}

- (void)setBlurEffect {
    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView * effe = [[UIVisualEffectView alloc]initWithEffect:blur];
    effe.alpha = 0.99;
    effe.frame = self.bgIv.bounds;
    [self.bgIv insertSubview:effe aboveSubview:self.bgIv];
}

- (void)changeProgress:(UISlider *)slider {
    float seekTime = self.player.duration * slider.value;
    [self.player seekToTime:seekTime];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"progress"]) {
        if (self.progressSlider.state != UIControlStateHighlighted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressSlider.value = self.player.progress;
                self.currentTime.text = [self convertStringWithTime:self.player.duration * self.player.progress];
            });
        }
    }
    if ([keyPath isEqualToString:@"duration"]) {
        if (self.player.duration > 0) {
            self.duration.text = [self convertStringWithTime:self.player.duration];
            self.duration.hidden = NO;
            self.currentTime.hidden = NO;
        }else {
            self.duration.hidden = YES;
            self.currentTime.hidden = YES;
        }
    }
    if ([keyPath isEqualToString:@"cacheProgress"]) {
        NSLog(@"缓存进度：%f", self.player.cacheProgress);
    }
}

#pragma mark - Action
- (IBAction)play:(UIButton *)sender {
    if (sender.selected) {
        [self.player pause];
    }else {
        [self.player play];
    }
    sender.selected = !sender.selected;
}

- (IBAction)nextSong:(UIButton *)sender {
    self.songIndex ++;
    if (self.songIndex >= 3) self.songIndex = 0;
    
    [self.player stop];
    NSURL * url = [NSURL URLWithString:[self songURLList][self.songIndex]];
    [self.player replaceItemWithURL:url];
    [self.player play];
    [self updateSongInfoShow];
}

- (IBAction)backSong:(UIButton *)sender {
    self.songIndex --;
    if (self.songIndex < 0) self.songIndex = 2;
    
    [self.player stop];
    NSURL * url = [NSURL URLWithString:[self songURLList][self.songIndex]];
    [self.player replaceItemWithURL:url];
    [self.player play];
    [self updateSongInfoShow];
}

- (void)updateSongInfoShow {
    self.songName.text = [self songNameList][self.songIndex];
    
    [UIView transitionWithView:self.bgIv duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.bgIv.image = [UIImage imageNamed:[self songCoverList][self.songIndex]];
    } completion:nil];
    
    [UIView transitionWithView:self.coverIv duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.coverIv.image = [UIImage imageNamed:[self songCoverList][self.songIndex]];
    } completion:nil];
}

- (NSString *)convertStringWithTime:(float)time {
    if (isnan(time)) time = 0.f;
    int min = time / 60.0;
    int sec = time - min * 60;
    NSString * minStr = min > 9 ? [NSString stringWithFormat:@"%d",min] : [NSString stringWithFormat:@"0%d",min];
    NSString * secStr = sec > 9 ? [NSString stringWithFormat:@"%d",sec] : [NSString stringWithFormat:@"0%d",sec];
    NSString * timeStr = [NSString stringWithFormat:@"%@:%@",minStr, secStr];
    return timeStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  RSPlayerTools.h
//  iOSPrinciple_AVFoundation
//
//  Created by WhatsXie on 2018/5/31.
//  Copyright © 2018年 WhatsXie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define HYPlayerToolMusicTimeUpdate @"HYPlayerToolMusicTimeUpdate"
#define HYPlayerToolMusicBeginPlay @"HYPlayerToolMusicBeginPlay"
#define HYPlayerToolMusicPause @"HYPlayerToolMusicPause"
#define HYPlayerToolMusicStop @"HYPlayerToolMusicStop"

@class RSMusicModel;

@interface RSPlayerTools : NSObject

@property(nonatomic,strong) NSMutableArray<RSMusicModel*> *dataSourceArr;
@property(nonatomic,strong) RSMusicModel *currentMusic;

@property(nonatomic,strong) AVQueuePlayer *aPlayer;
@property(nonatomic,strong) AVPlayerItem *playerItem;
@property(nonatomic,assign) BOOL isPlaying;
@property(nonatomic,assign) NSInteger albumId;
@property(nonatomic,assign) NSInteger currentIndex;
@property(nonatomic,assign) NSInteger currentTime;
@property(nonatomic,assign) NSInteger durationTime;
@property(nonatomic,assign) CGFloat currentPercent;
@property(nonatomic,strong) NSString *currentTimeStr;
@property(nonatomic,strong) NSString *durationTimeStr;

@property (nonatomic, strong) NSTimer *playerTimer;

/// 单例
+ (instancetype)sharePlayerTool;

/// 播放第index首
- (void)playMusicAtIndex:(NSInteger)index;

/// 暂停播放
- (void)pause;

/// 停止播放
- (void)stop;

/// 继续播放
- (void)play;

/// 拖动进度到
- (void)seekTo:(CGFloat)percent;

/// 播放下一首
- (BOOL)playNext;

/// 播放上一首
- (BOOL)playBack;

/// 锁屏图片
- (void)updateSongImage:(UIImage*)image url:(NSString*)url;

/// 时间戳转换
- (NSString *)timeformatFromSeconds:(NSInteger)seconds;

@end

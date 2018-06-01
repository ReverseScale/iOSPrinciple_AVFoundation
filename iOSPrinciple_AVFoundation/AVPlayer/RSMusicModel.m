//
//  RSMusicModel.m
//  iOSPrinciple_AVFoundation
//
//  Created by WhatsXie on 2018/5/31.
//  Copyright © 2018年 WhatsXie. All rights reserved.
//

#import "RSMusicModel.h"

@implementation RSMusicModel
- (instancetype)initWithTitle:(NSString *)title songerName:(NSString *)singerName musicUrl:(NSString *)musicUrl {
    if (self == [super init]) {
        self.songName = title;
        self.singerName = singerName;
        self.musicUrl = musicUrl;
    }
    return self;
}
@end

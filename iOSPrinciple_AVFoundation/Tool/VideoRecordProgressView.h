//
//  FMRecordProgressView.h
//  fmvideo
//
//  Created by qianjn on 2016/12/30.
//  Copyright © 2016年 SF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoRecordProgressView : UIView
- (instancetype)initWithFrame:(CGRect)frame;
-(void)updateProgressWithValue:(CGFloat)progress;
-(void)resetProgress;

@end

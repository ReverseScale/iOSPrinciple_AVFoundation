//
//  AVEqualizerPlayerController.h
//  iOSPrinciple_AVFoundation
//
//  Created by WhatsXie on 2018/6/4.
//  Copyright © 2018年 WhatsXie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVEqualizerPlayerController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UISlider *playerSlider;
@property (weak, nonatomic) IBOutlet UIView *equalizerView;

@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@end

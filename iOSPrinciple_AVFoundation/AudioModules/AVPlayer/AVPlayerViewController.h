//
//  AVPlayerViewController.h
//  iOSPrinciple_AVFoundation
//
//  Created by WhatsXie on 2018/5/31.
//  Copyright © 2018年 WhatsXie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVPlayerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *songerLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@end

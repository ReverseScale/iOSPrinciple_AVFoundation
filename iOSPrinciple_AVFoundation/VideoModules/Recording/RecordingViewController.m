//
//  PickerViewController.m
//  iOSPrinciple_AVFoundation
//
//  Created by WhatsXie on 2018/6/8.
//  Copyright © 2018年 WhatsXie. All rights reserved.
//

#import "RecordingViewController.h"
#import "PickerController.h"
#import "MPMovieFileVideoController.h"

@interface RecordingViewController ()

@end

@implementation RecordingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)pickerAction:(id)sender {
    PickerController *picker = [[PickerController alloc] init];
    [self presentViewController:picker animated:YES completion:nil];
}
- (IBAction)recordingAction:(id)sender {
    MPMovieFileVideoController *fileVC = [[MPMovieFileVideoController alloc] init];
    UINavigationController *NAV = [[UINavigationController alloc] initWithRootViewController:fileVC];
    [self presentViewController:NAV animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  ViewController.m
//  EHMediaPlayerDemo
//
//  Created by howell on 9/8/15.
//  Copyright (c) 2015 ender. All rights reserved.
//

#import "ViewController.h"
#import "EHMediaPlayer.h"

@interface ViewController ()

@property (nonatomic)EHMediaPlayer * mediaPlayer;
@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mediaPlayer play];
    [self.view addSubview:self.mediaPlayer.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters & Setters
- (EHMediaPlayer *)mediaPlayer {
    if (!_mediaPlayer) {
        _mediaPlayer = [[EHMediaPlayer alloc] initWithContentURL:nil];
    }
    return _mediaPlayer;
}

@end

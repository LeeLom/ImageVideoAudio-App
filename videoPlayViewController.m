//
//  videoPlayViewController.m
//  GraduateDemo
//
//  Created by LeeLom on 16/4/1.
//  Copyright © 2016年 LeeLom. All rights reserved.
//

#import "videoPlayViewController.h"
#import "videoInfo.h"
#import "audioInfo.h"
#import "videoTableViewController.h"
#import <MobileVLCKit/MobileVLCKit.h>

@interface videoPlayViewController ()<VLCMediaDelegate>{
    UIView *_mediaView;
}
@property (strong,nonatomic) VLCMediaPlayer *vlcPlayer;

@end

@implementation videoPlayViewController
@synthesize mediaPath = _mediaPath;

-(void)viewDidLoad{
    [super viewDidLoad];
    //self.tabBarController.tabBar.hidden = YES;
    
    //[self.navigationController setNavigationBarHidden:YES];
    
    //设置播放界面
    _mediaView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_mediaView];
    
   // NSMutableDictionary *cache = [NSMutableDictionary new];
   // [cache setObject:@"0" forKey:@"network-caching"];
    
    
    
    //设置播放器
    _vlcPlayer = [[VLCMediaPlayer alloc]initWithOptions:nil];
    _vlcPlayer.drawable = _mediaView;
    
    // [_vlcPlayer.media addOptions:cache];
    
    NSString *path = self.mediaPath;
    

    
    
    
    
    VLCMedia *media = [VLCMedia mediaWithURL:[NSURL URLWithString:path]];
    media.delegate = self;//设置delegate 才能可以知道歌曲有多长
    [_vlcPlayer setMedia:media];
    [_vlcPlayer play];
}

-(void)viewWillDisappear:(BOOL)animated{
    [_vlcPlayer stop];
    
    [super viewWillDisappear:animated];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

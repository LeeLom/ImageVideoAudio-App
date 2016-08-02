//
//  TabbarViewController.m
//  GraduateDemo
//
//  Created by LeeLom on 16/3/31.
//  Copyright © 2016年 LeeLom. All rights reserved.
//

#import "TabbarViewController.h"


@interface TabbarViewController()

@end

@implementation TabbarViewController

@synthesize tabbarController = _tabbarController;
@synthesize imageTableView = _imageTableView;
@synthesize videoTableView = _videoTableView;
@synthesize audioTableView = _audioTableView;


-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.imageTableView = [[imageTableViewController alloc]init];
    self.videoTableView = [[videoTableViewController alloc]init];
    self.audioTableView = [[audioTableViewController alloc]init];
    
    UINavigationController *nav1,*nav2,*nav3;
    nav1 = [[UINavigationController alloc]initWithRootViewController:_imageTableView];
    nav2 = [[UINavigationController alloc]initWithRootViewController:_videoTableView];
    nav3 = [[UINavigationController alloc]initWithRootViewController:_audioTableView];
    nav1.delegate = self;
    nav2.delegate = self;
    nav3.delegate = self;
    
    nav1.tabBarItem.image = [UIImage imageNamed:@"image"];
    nav2.tabBarItem.image = [UIImage imageNamed:@"video"];
    nav3.tabBarItem.image = [UIImage imageNamed:@"audio"];
    
    nav1.tabBarItem.title = @"图片";
    nav2.tabBarItem.title = @"视频";
    nav3.tabBarItem.title = @"语音";
    
    
    self.tabbarController = [[UITabBarController alloc]init];
    self.tabbarController.viewControllers = [NSArray arrayWithObjects:nav1,nav2,nav3, nil];
    [self.view addSubview:self.tabbarController.view];
    
    
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
@end


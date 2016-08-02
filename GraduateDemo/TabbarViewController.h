//
//  TabbarViewController.h
//  GraduateDemo
//
//  Created by LeeLom on 16/3/31.
//  Copyright © 2016年 LeeLom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "imageTableViewController.h"
#import "videoTableViewController.h"
#import "audioTableViewController.h"

@interface TabbarViewController : UIViewController<UINavigationControllerDelegate>

@property (nonatomic,retain) UITabBarController *tabbarController;
@property (nonatomic,retain) imageTableViewController *imageTableView;
@property (nonatomic,retain) videoTableViewController *videoTableView;
@property (nonatomic,retain) audioTableViewController *audioTableView;

@end

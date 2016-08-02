//
//  LoginViewController.h
//  GraduateDemo
//
//  Created by LeeLom on 16/4/10.
//  Copyright © 2016年 LeeLom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "videoUploadViewController.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *userNameTextField;
@property (nonatomic,strong) UITextField *passwordTextFeild;
@property (nonatomic,strong) UIImageView *line;
@property (nonatomic,strong) UIImageView *cam;

@end

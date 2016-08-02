//
//  CreateUserViewController.h
//  GraduateDemo
//
//  Created by LeeLom on 16/4/11.
//  Copyright © 2016年 LeeLom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateUserViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic,strong) UITextField *userName;
@property (nonatomic,strong) UITextField *password;
@property (nonatomic,strong) UITextField *passwordAgain;

@end

//
//  LoginViewController.m
//  GraduateDemo
//
//  Created by LeeLom on 16/4/10.
//  Copyright © 2016年 LeeLom. All rights reserved.
//

#import "LoginViewController.h"
#import "TabbarViewController.h"
#import "imageTableViewController.h"
#import "CreateUserViewController.h"
#import "AFNetworking.h"
#import "videoUploadViewController.h"

#define userJsonURL @"http://10.102.14.107:8000/userJson.php"

@interface LoginViewController()<UIAlertViewDelegate>{
    NSMutableArray *userNameInfo;
    NSMutableArray *userPasswordInfo;

}

@end

@implementation LoginViewController

@synthesize userNameTextField = _userNameTextField;
@synthesize passwordTextFeild = _passwordTextFeild;
@synthesize line = _line;
@synthesize cam = _cam;


-(void)viewDidLoad{
    [super viewDidLoad];
    //获取服务器端用户名和密码
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:userJsonURL parameters:nil progress:nil success:^(NSURLSessionDataTask *  task, id responseObject) {
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        NSMutableArray *userJsonInfo = [[NSMutableArray alloc]init];
        userNameInfo = [[NSMutableArray alloc]init];
        userPasswordInfo = [[NSMutableArray alloc]init];
        userJsonInfo = [[json objectForKey:@"userJson"]mutableCopy];
        for (int i=0; i< [userJsonInfo count]; i++) {
            NSString *nameString = [userJsonInfo[i] objectForKey:@"userName"];
            NSString *passwordString = [userJsonInfo[i] objectForKey:@"userPassword"];
            [userNameInfo addObject:nameString];
            [userPasswordInfo addObject:passwordString];
        }
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        NSLog(@"Error:%@",error);
    }];
    
    self.userNameTextField.delegate = self;
    self.passwordTextFeild.delegate = self;
    
    //指定编辑时键盘的return键类型
    self.userNameTextField.returnKeyType = UIReturnKeyNext;
    self.passwordTextFeild.returnKeyType = UIReturnKeyDefault;
    
    //注册键盘相应事件方法
    [self.userNameTextField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.passwordTextFeild addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
 
    
    //添加手势，点击屏幕其他区域关闭键盘的惭怍
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
    
    self.view.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];//#DCDCDC
    [self.navigationController setNavigationBarHidden:YES];
    
    //get userNameText
    //int textFieldWidth = self.view.frame.size.width - 60;//两边各留边距30
    //int textFieldHeight = 50;
    //int textFiledY = (self.view.frame.size.height) / 2
    
    self.userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 150, 260, 50)];
    self.userNameTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.userNameTextField.placeholder = @"  账号";
    self.userNameTextField.font = [UIFont boldSystemFontOfSize:20];
    //[self.userNameTextField setValue:[UIColor colorWithRed:128/255.0 green:138/255.0 blue:135/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    UIImageView *userNameView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"person.png"]];
    self.userNameTextField.leftView = userNameView;
    self.userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.userNameTextField];
    
    //画线函数
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:imageView];
    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1.0);  //线宽
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 1.0, 1.0, 1.0);  //颜色
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 30, 195);  //起点坐标
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 290, 195);   //终点坐标
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    imageView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //get password text
    self.passwordTextFeild = [[UITextField alloc]initWithFrame:CGRectMake(self.userNameTextField.frame.origin.x, self.userNameTextField.frame.origin.y+60, 260, 50)];
    self.passwordTextFeild.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.passwordTextFeild.placeholder = @"  密码";
    self.passwordTextFeild.secureTextEntry = YES;
    self.passwordTextFeild.font = [UIFont boldSystemFontOfSize:20];
    //[self.userNameTextField setValue:[UIColor colorWithRed:128/255.0 green:138/255.0 blue:135/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    UIImageView *passwordView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password.png"]];
    self.passwordTextFeild.leftView = passwordView;
    self.passwordTextFeild.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.passwordTextFeild];
    
    //画线函数
    UIImageView *imageView2=[[UIImageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:imageView2];
    UIGraphicsBeginImageContext(imageView2.frame.size);
    [imageView2.image drawInRect:CGRectMake(0, 0, imageView2.frame.size.width, imageView2.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1.0);  //线宽
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 1.0, 1.0, 1.0);  //颜色
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 30, 255);  //起点坐标
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 290, 255);   //终点坐标
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    imageView2.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //登录按钮
    UIButton *loginButton = [[UIButton alloc] init];
    loginButton.frame = CGRectMake(20, 350, 280, 30);
    [loginButton.layer setCornerRadius:3.0];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    loginButton.backgroundColor = [UIColor colorWithRed:128/255.0 green:138/255.0 blue:135/255.0 alpha:1];//808A87
    [self.view addSubview:loginButton];
    [loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    //注册按钮
    UIButton *registButton = [[UIButton alloc]init];
    registButton.frame = CGRectMake(20, 410, 280, 30);
    [registButton.layer setCornerRadius:3.0];
    [registButton setTitle:@"注册" forState:UIControlStateNormal];
    [registButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    registButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    registButton.backgroundColor = [UIColor colorWithRed:128/255.0 green:138/255.0 blue:135/255.0 alpha:1];
    [registButton addTarget:self action:@selector(registButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registButton];
    
    
}

#pragma mark 登录按钮事件
-(void)loginButtonClick{
    NSLog(@"login button is clicked");
    NSString *name =  self.userNameTextField.text;
    NSString *password = self.passwordTextFeild.text;
    int i=0;
    for ( ; i < [userNameInfo count] ; i++) {
        if (([name isEqualToString:userNameInfo[i]]) & ([password isEqualToString:userPasswordInfo[i]])) {
            

            TabbarViewController *viewController = [[TabbarViewController alloc]init];
            [self.navigationController pushViewController:viewController animated:NO];
            break;

        }
    }
    if (i == [userNameInfo count]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误信息提示" message:@"用户名或者密码错误！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
}
#pragma mark 注册按钮事件
-(void)registButtonClick{
    NSLog(@"regist button is clicked");
    CreateUserViewController *viewController = [[CreateUserViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:NO];

}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
#pragma mark 开始监听编辑

-(void)hidenKeyboard{
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextFeild  resignFirstResponder];
}

-(void)nextOnKeyboard:(UITextField *)textField{
    if (textField == self.userNameTextField) {
        [self.passwordTextFeild becomeFirstResponder];
    }else if (textField == self.passwordTextFeild){
        [self hidenKeyboard];
    }
}

@end

//
//  CreateUserViewController.m
//  GraduateDemo
//
//  Created by LeeLom on 16/4/11.
//  Copyright © 2016年 LeeLom. All rights reserved.
//

#import "CreateUserViewController.h"
#import "LoginViewController.h"
#import "AFNetworking.h"
#define uploadURL @"http://10.102.14.107:8000/uploadPhp.php"

@implementation CreateUserViewController

@synthesize userName;
@synthesize password;
@synthesize passwordAgain;

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    //set NavigationBar 背景颜色&title 颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:128/255.0 green:138/255.0 blue:135/255.0 alpha:1]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor whiteColor];
    userName.delegate = self;
    password.delegate = self;
    passwordAgain.delegate = self;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
    
    self.view.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    [self.navigationController setNavigationBarHidden:NO];
    
    self.title =@"注册账号";
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.userName = [[UITextField alloc] initWithFrame:CGRectMake(30, 150, 260, 50)];
    //self.username.borderStyle = UITextBorderStyleRoundedRect;
    self.userName.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.userName.placeholder = @"  账户";
    self.userName.font = [UIFont boldSystemFontOfSize:20];
    self.userName.textColor = [UIColor whiteColor];
    
    UIImageView *username1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personnal.png"]];
    userName.leftView = username1;
    userName.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *imageView1=[[UIImageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:imageView1];
    UIGraphicsBeginImageContext(imageView1.frame.size);
    [imageView1.image drawInRect:CGRectMake(0, 0, imageView1.frame.size.width, imageView1.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1.0);  //线宽
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 1.0, 1.0, 1.0);  //颜色
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 30, 195);  //起点坐标
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 290, 195);   //终点坐标
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    imageView1.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    [self.userName setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    [self.view addSubview:self.userName];
    
    self.password = [[UITextField alloc] initWithFrame:CGRectMake(self.userName.frame.origin.x, self.userName.frame.origin.y + 60, 260, 50)];
    //self.password.borderStyle = UITextBorderStyleRoundedRect;
    self.password.contentVerticalAlignment =
    UIControlContentHorizontalAlignmentCenter;
    self.password.placeholder = @"  密码";
    
    self.password.font = [UIFont boldSystemFontOfSize:20];
    self.password.secureTextEntry = YES;
    self.password.textColor = [UIColor whiteColor];
    
    UIImageView *passwordpic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password1.png"]];
    password.leftView = passwordpic;
    password.leftViewMode = UITextFieldViewModeAlways;
    [self.password setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
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
    
    
    [self.view addSubview:self.password];
    
    
    
    self.passwordAgain = [[UITextField alloc] initWithFrame:CGRectMake(userName.frame.origin.x, userName.frame.origin.y + 120, 260, 50)];
    //self.passwordAgain.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordAgain.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.passwordAgain.placeholder = @"  确认密码";
    self.passwordAgain.font = [UIFont boldSystemFontOfSize:20];
    UIImageView *againpasswordpic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password1.png"]];
    passwordAgain.leftView = againpasswordpic;
    passwordAgain.leftViewMode = UITextFieldViewModeAlways;
    self.passwordAgain.secureTextEntry = YES;
    self.passwordAgain.textColor = [UIColor whiteColor];
    
    [self.passwordAgain setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    UIImageView *imageView3=[[UIImageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:imageView3];
    UIGraphicsBeginImageContext(imageView3.frame.size);
    [imageView3.image drawInRect:CGRectMake(0, 0, imageView3.frame.size.width, imageView3.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1.0);  //线宽
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 1.0, 1.0, 1.0);  //颜色
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 30, 315);  //起点坐标
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 290, 315);   //终点坐标
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    imageView3.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.view addSubview:self.passwordAgain];
    
    
    UIButton *creatButton = [[UIButton alloc] init];
    creatButton.frame = CGRectMake(30,400,260,30);
    [creatButton.layer setCornerRadius:3.0];
    [creatButton setTitle:@"注册" forState:UIControlStateNormal];
    [creatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [creatButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    creatButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0]; //字体大小
    creatButton.backgroundColor= [UIColor colorWithRed:128/255.0 green:138/255.0 blue:135/255.0 alpha:1];
    [creatButton addTarget:self action:@selector(creatClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:creatButton];
    
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)creatClick{
    if (![self.password.text isEqualToString: self.passwordAgain.text ])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"两次密码输入不符，请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSLog(@"creatbutton is click");
    NSLog(@"%@",self.userName.text);
    NSLog(@"%@",self.password.text);
    NSDictionary *parameters=@{@"userName":self.userName.text,@"userPassword":self.password.text};
    [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:uploadURL parameters:parameters error:nil];
    
    LoginViewController *viewController = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:NO];

}
-(void)hidenKeyboard{
    [userName resignFirstResponder];
    [password  resignFirstResponder];
    [passwordAgain resignFirstResponder];
}

/*
-(void)uploadUserInfo{
    //1.创建请求
    NSURL *url = [NSURL URLWithString:@"haimeiyouxie "];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod  =@"POST";
    
    
    //2.设置请求头
    [request setValue:@"application/json" forKey:@"Content-Type"];
    
    //3.设置请求体
    NSDictionary *json = @{
                           @"userName":self.userName.text,
                           @"userPassword":self.password.text
                           };
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = data;
    
    //4.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *  response, NSData *  data, NSError *  connectionError) {
        NSLog(@"%d",data.length);
        
    }];
    
    
}
*/
@end

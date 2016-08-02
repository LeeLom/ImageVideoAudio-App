//
//  audioTableViewController.m
//  GraduateDemo
//
//  Created by LeeLom on 16/3/30.
//  Copyright © 2016年 LeeLom. All rights reserved.
//

#import "audioTableViewController.h"
#import "audioInfo.h"
#import "takeImageAudioVideoViewController.h"
#import "personInfoViewController.h"
#import "AFNetworking.h"
#import "videoPlayViewController.h"

#define audioInfoURL @"http://10.102.14.107:8000/audioJson.php"

@interface audioTableViewController()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    
    UITableView *_tableView;
    NSMutableArray *_audios;//音频模型数组
    NSMutableArray *_audiosShow;
}
@end

@implementation audioTableViewController

-(void) viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title = @"语音浏览";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"我" style:UIBarButtonItemStylePlain target:self action:@selector(toPersonInfoViewController)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(toTakeImageVideoAudioViewController)];
    self.tabBarController.tabBar.hidden = NO;
    
    [self initAudioData];
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    
    [self.view addSubview:_tableView];
    
    
}

#pragma mark 加载音频数据
-(void)initAudioData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:audioInfoURL parameters:nil progress:nil
        success:^(NSURLSessionDataTask *  task, id  responseObject) {
            id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            _audiosShow = [[json objectForKey:@"audioJson"]mutableCopy];
            _audios = [[NSMutableArray alloc]init];
            
            for (int i=0; i<[_audiosShow count]; i++) {
                NSString *audioNameTmp = [_audiosShow[i] objectForKey:@"audioName"];
                NSString *audioUpLoadUserNameTmp = [_audiosShow[i] objectForKey:@"audioUserName"];
                NSString *audioURLTmp =@"audioShow.jpg" ;
                
                //audioState;
                
                NSString *audioPlayURLTmp= [_audiosShow[i] objectForKey:@"audioURL"]; //填坑 播放url
                
                audioInfo *audio1 = [[audioInfo alloc]initWithAudioName:audioNameTmp andAudioUpLoadUserName:audioUpLoadUserNameTmp andAudioURL:audioURLTmp andAudioState:YES];
                audio1.audioPlayURL = audioPlayURLTmp;
                
                //NSLog(@"-%@--%@--%@-",audioNameTmp,audioPlayURLTmp,audioUpLoadUserNameTmp);
                
                [_audios addObject:audio1];
                
            }
            
            [_tableView reloadData];
    
        }failure:^(NSURLSessionDataTask *  task, NSError *  error) {
                NSLog(@"Error:%@",error);
        }];
    
}

#pragma mark 数据源方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _audios.count;
}

#pragma mark 返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    audioInfo *audio = _audios[indexPath.row];
    
    //由于此方法啊调用十分频繁，cell的标识声明静态变量有利于性能优化
    static NSString *cellIndetifier = @"UITableViewIndentifierKey1";
    //根据标识符先去缓存池去
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    
    //如果缓存池中没有则重新创建并且放到缓存池中去
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndetifier];
        
    }
    cell.textLabel.text = audio.audioName;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.detailTextLabel.text = [audio getAudioUpLoadUserName:audio.audioUpLoadUserName];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    cell.imageView.image = [UIImage imageNamed:audio.audioURL];     //音频设置一张默认数据在前面显示
    return cell;
}

#pragma mark 代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

#pragma mark 左边按钮实现跳转到拍照录音功能
-(void)toTakeImageVideoAudioViewController{
    takeImageAudioVideoViewController *viewController = [[takeImageAudioVideoViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:NO];
    
}

#pragma mark 右边按钮实现跳转到个人主页功能
-(void)toPersonInfoViewController{
    personInfoViewController *viewController = [[personInfoViewController alloc]init];
    [self.navigationController  pushViewController:viewController animated:YES];
}

#pragma mark 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    audioInfo *audio = _audios[indexPath.row];
    
    videoPlayViewController *viewController = [[videoPlayViewController alloc]init];
    viewController.mediaPath = audio.audioPlayURL;
    [self.navigationController pushViewController:viewController animated:NO];
}

@end

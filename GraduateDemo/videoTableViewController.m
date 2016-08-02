//
//  videoTableViewController.m
//  GraduateDemo
//
//  Created by LeeLom on 16/3/30.
//  Copyright © 2016年 LeeLom. All rights reserved.
//

#import "videoTableViewController.h"
#import "videoInfo.h"
#import "takeImageAudioVideoViewController.h"
#import "personInfoViewController.h"
#import "AFNetworking.h"
#import "videoPlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVAsset.h>
#define videoInfoURL @"http://10.102.14.107:8000/videoJson.php"

@interface videoTableViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    UITableView *_tableView;
    //NSMutableArray *_videos;//视频模型
    
    NSString *mediaURL;
    
}

@end


@implementation videoTableViewController

@synthesize videoInfoToPlay = _videoInfoToPlay;
@synthesize selectRow = _selectRow;

static NSMutableArray *_videos;//视频Json模型
static NSMutableArray *_videosShow;

-(void) viewDidLoad{
    [super viewDidLoad];
    
    [self initVideoData];
    
    //NSLog(@"+++++++++++++++++++");
    
    //添加NavigationController
    self.navigationItem.title = @"视频浏览";
    //nav1.tabBarItem.image = [UIImage imageNamed:@"videoTabbarItem2"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"我" style:UIBarButtonItemStylePlain target:self action:@selector(toPersonInfoViewController)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(toTakeImageVideoAudioViewController)];
    self.tabBarController.tabBar.hidden = NO;
    
  
    //添加tableview
   // _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 50.0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    
    [self.view addSubview:_tableView];
    
    /*
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
     manager.responseSerializer = [AFHTTPResponseSerializer serializer];
     
     [manager GET:@"http://10.102.14.107:8000/audioJson.php" parameters:nil success:^(NSURLSessionDataTask * task, id responseObject) {
     NSLog(@"JSON: %@", responseObject);
     id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
     NSLog(@"%@",[json objectForKey:@"audioJson"]);
     NSArray *arrayVideo = [json objectForKey:@"audioJson"];
     NSLog(@"%@",[arrayVideo[2] objectForKey:@"audioURL"]);
     } failure:^(NSURLSessionDataTask * task, NSError *error) {
     NSLog(@"Error: %@", error);
     }];

    */
    
}

#pragma mark 获取视频某一帧的图片 time:第N帧
-(UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time{
    AVURLAsset *asset = [[AVURLAsset alloc]initWithURL:videoURL options:nil];
    //特么的ARC forbidden use expilit autorelease
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError%@",thumbnailImageGenerationError);
        UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage:thumbnailImageRef] : nil;
        return thumbnailImage;
}
#pragma mark 加载数据
-(void)initVideoData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//声明返回的结果是Json类型
    [manager GET:videoInfoURL parameters:nil progress:nil success:^(NSURLSessionDataTask * task, id responseObject){
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        //NSLog(@"%@",[json objectForKey:@"videoJson"]);
        _videos = [[json objectForKey:@"videoJson"] mutableCopy];
        //添加mutablecopy [StackOverflow]解决了问题：__NSCFArray insertObject:atIndex:]: mutating method sent to immutable object'
        //NSMutableArray *loadDefects = [[defaultDefects objectForKey:@"defaultDefects"]mutableCopy];
        
       // NSLog(@"-------%@",_videos);
        
        _videosShow = [[NSMutableArray alloc]init];
        
        NSString *videoNameTmp;
        NSString *videoUploadUserNameTmp;// = [_videos[0] objectForKey:@"videoUserName"];
        NSString *videoURLTmp;// = [_videos[0] objectForKey:@"videoURL"];
        //BOOL videoStateTmp;// = [_videos[0] objectForKey:@"videoState"];
        
        for (int i=0 ;i< [_videos count]; i++) {
            videoNameTmp = [_videos[i] objectForKey:@"videoName"];
            videoUploadUserNameTmp = [_videos[i] objectForKey:@"videoUserName"];
            videoURLTmp = [_videos[i] objectForKey:@"videoURL"];
            //videoStateTmp = [_videos[i] objectForKey:@"videoState"];
            //NSLog(@"videoNameTmp:%@  %@  %@",videoNameTmp,videoUploadUserNameTmp,videoURLTmp);
            
            videoInfo *video1 = [[videoInfo alloc]initWithvideoName:videoNameTmp andVideoUpLoadUserName:videoUploadUserNameTmp andVideoURL:videoURLTmp andVideoState:YES];
            video1.videoPlayURL = videoURLTmp;
            //NSLog(@"video1:%@",video1);
            [_videosShow addObject:video1];
        }
        
        [_tableView reloadData];

    }failure:^(NSURLSessionDataTask * task, NSError *error)
     {
          NSLog(@"Error: %@", error);
     }];

    //下面的代码根本没有执行
    NSLog(@"为什么是空的额啊%@",_videosShow);
    NSLog(@"执行结束");
    //_videos = [[NSMutableArray alloc]init];
    
    //videoInfo *video1 = [[videoInfo alloc]initWithvideoName:@"VideoPic1" andVideoUpLoadUserName:@"LeeLom" andVideoURL:@"1.jpg" andVideoState:YES];
    //videoInfo *video2 = [[videoInfo alloc]initWithvideoName:@"VideoPic2" andVideoUpLoadUserName:@"LeeLom" andVideoURL:@"1.jpg" andVideoState:YES];

    //[_videos addObject:video2];
    
}

#pragma mark 数据源方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _videosShow.count;
    
}

#pragma mark 返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //NSLog(@"***********%@",_videosShow[indexPath.row])
    videoInfo *video = _videosShow[indexPath.row];
    
    //由于此方法调用十分频繁 cell的标识声明称静态变量有利于性能优化
    static NSString *cellIdentifier = @"UITableViewIndentifierKey1";
    //首先根据标志去缓存池取
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //如果缓存池没有则重新创建并放到缓存池当中
    
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = video.videoName;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.detailTextLabel.text = [video getUpLoadUserName:video.videoUploadUserName];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    
    
    UIImage *image1 = [self thumbnailImageForVideo:[NSURL URLWithString:video.videoURL] atTime:20];
    
    CGSize imageSize = CGSizeMake(80, 80);
    UIGraphicsBeginImageContext(imageSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = CGPointZero;
    thumbnailRect.size.width = imageSize.width;
    thumbnailRect.size.height = imageSize.height;
    [image1 drawInRect:thumbnailRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [cell.imageView setImage:newImage];
    
    //cell.imageView.image = [UIImage imageNamed:video.videoURL];
    
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
    
    videoInfo *video = _videosShow[indexPath.row];
    
    
    videoPlayViewController *viewController = [[videoPlayViewController alloc]init];
    viewController.mediaPath = video.videoPlayURL;
    
    [self.navigationController  pushViewController:viewController animated:NO];

}




@end

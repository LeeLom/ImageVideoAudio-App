
//
//  personInfoViewController.m
//  GraduateDemo
//
//  Created by LeeLom on 16/3/31.
//  Copyright © 2016年 LeeLom. All rights reserved.
//

#import "personInfoViewController.h"
#import "imageInfo.h"
#import "videoInfo.h"
#import "audioInfo.h"
#import "AFNetworking.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVAsset.h>
#import "videoPlayViewController.h"

#define videoInfoURL @"http://10.102.14.107:8000/videoJson.php"
#define imageInfoURL @"http://10.102.14.107:8000/imageJson.php"
#define audioInfoURL @"http://10.102.14.107:8000/audioJson.php"
#define personalURL  @"http://10.102.14.107:8000/personalJson.php"

@interface personInfoViewController()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    
    NSMutableArray *_imageUpLoads;
    NSMutableArray *_videoUpLoads;
    NSMutableArray *_audioUpLoads;
    NSMutableArray *_profileUpLoads;
    
    NSMutableArray *_imageShow;
    NSMutableArray *_videoShow;
    NSMutableArray *_audioShow;
    
    NSMutableArray *_deleteResource;
}
@property (nonatomic,strong) UILabel *personNameLabel;

@end

@implementation personInfoViewController
@synthesize personNameLabel = _personNameLabel;

-(void)viewDidLoad{
    [super viewDidLoad];
    NSLog(@"----------%@",_deleteResource);
    
    self.navigationItem.title = @"个人信息";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20],NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(toggleEdit)];
    
    //self.tabBarController.tabBar.hidden = YES;
    
    self.personNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 70)];
    self.personNameLabel.text = @"LeeLom Wang";
    self.personNameLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    self.personNameLabel.textColor = [UIColor whiteColor];
    self.personNameLabel.backgroundColor = [UIColor lightGrayColor];
    self.personNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.personNameLabel];
    
    
    [self initData];
    CGRect tableViewFrame = CGRectMake(0, 120, self.view.bounds.size.width , self.view.bounds.size.height);
    _tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    _tableView.delegate =self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    NSLog(@"tableview加载完毕");
    
    
}
-(void)viewDidDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark 加载数据
-(void)initData{
   /*
    //手动加载数据的
    _imageUpLoads = [[NSMutableArray alloc]init];
    _videoUpLoads = [[NSMutableArray alloc]init];
    _audioUpLoads = [[NSMutableArray alloc]init];
    
    _profileUpLoads = [[NSMutableArray alloc]init];
    
    NSLog(@"initDat开始执行");
    imageInfo *image1 = [[imageInfo alloc]initWithImageName:@"ImagePic1" andImageUpLoadUserName:@"LeeLom" andImageURL:@"1.jpg" andImageState:YES];
    imageInfo *image2 = [[imageInfo alloc]initWithImageName:@"ImagePic2" andImageUpLoadUserName:@"LeeLom" andImageURL:@"2.jpg" andImageState:YES];
    imageInfo *image3 = [[imageInfo alloc]initWithImageName:@"ImagePic2" andImageUpLoadUserName:@"LeeLom" andImageURL:@"2.jpg" andImageState:YES];
    imageInfo *image4 = [[imageInfo alloc]initWithImageName:@"ImagePic2" andImageUpLoadUserName:@"LeeLom" andImageURL:@"2.jpg" andImageState:YES];
    [_imageUpLoads addObject:image1];
    [_imageUpLoads addObject:image2];
    [_imageUpLoads addObject:image3];
    [_imageUpLoads addObject:image4];
    
    videoInfo *video1 = [[videoInfo alloc]initWithvideoName:@"VideoPic1" andVideoUpLoadUserName:@"LeeLom" andVideoURL:@"1.jpg" andVideoState:YES];
    videoInfo *video2 = [[videoInfo alloc]initWithvideoName:@"VideoPic2" andVideoUpLoadUserName:@"LeeLom" andVideoURL:@"1.jpg" andVideoState:YES];
    videoInfo *video3 = [[videoInfo alloc]initWithvideoName:@"VideoPic2" andVideoUpLoadUserName:@"LeeLom" andVideoURL:@"1.jpg" andVideoState:YES];
    videoInfo *video4 = [[videoInfo alloc]initWithvideoName:@"VideoPic2" andVideoUpLoadUserName:@"LeeLom" andVideoURL:@"1.jpg" andVideoState:YES];
    [_videoUpLoads addObject:video1];
    [_videoUpLoads addObject:video2];
    [_videoUpLoads addObject:video3];
    [_videoUpLoads addObject:video4];
    
    audioInfo *audio1 = [[audioInfo alloc]initWithAudioName:@"AudioPic1" andAudioUpLoadUserName:@"Tom" andAudioURL:@"2.jpg" andAudioState:YES];
    audioInfo *audio2 = [[audioInfo alloc]initWithAudioName:@"AudioPic2" andAudioUpLoadUserName:@"Tom" andAudioURL:@"3.jpg" andAudioState:YES];
    audioInfo *audio3 = [[audioInfo alloc]initWithAudioName:@"AudioPic2" andAudioUpLoadUserName:@"Tom" andAudioURL:@"3.jpg" andAudioState:YES];
    audioInfo *audio4 = [[audioInfo alloc]initWithAudioName:@"AudioPic2" andAudioUpLoadUserName:@"Tom" andAudioURL:@"3.jpg" andAudioState:YES];
    [_audioUpLoads addObject:audio1];
    [_audioUpLoads addObject:audio2];
    [_audioUpLoads addObject:audio3];
    [_audioUpLoads addObject:audio4];
    
    [_profileUpLoads addObject:_imageUpLoads];
    [_profileUpLoads addObject:_videoUpLoads];
    [_profileUpLoads addObject:_audioUpLoads];
    
    */
  
    //下面加载网络数据
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manager GET:personalURL parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        _imageShow = [[json objectForKey:@"imageJson"]mutableCopy];
        _videoShow = [[json objectForKey:@"videoJson"]mutableCopy];
        _audioShow = [[json objectForKey:@"audioJson"]mutableCopy];
        
        _videoUpLoads = [[NSMutableArray alloc]init];
        _audioUpLoads = [[NSMutableArray alloc]init];
        _imageUpLoads = [[NSMutableArray alloc]init];
        _profileUpLoads = [[NSMutableArray alloc]init];
        NSLog(@"Number of _imageShow:%li",[_imageShow count]);
        
        NSString  *videoNameTmp,*videoUploadUserNameTmp,*videoURLTmp,*imageNameTmp,*imageUploadUserNameTmp,*imageURLTmp,*imageStateTmp;
        for (int i= 0; i < [_imageShow count]; i++) {
            imageNameTmp = [_imageShow[i] objectForKey:@"imageName"];
            imageUploadUserNameTmp = [_imageShow[i] objectForKey:@"imageUserName"];
            imageURLTmp = [_imageShow[i] objectForKey:@"imageURL"];
            imageStateTmp = [_imageShow[i] objectForKey:@"imageState"];
            
            imageInfo *image1 = [[imageInfo alloc]initWithImageName:imageNameTmp andImageUpLoadUserName:imageUploadUserNameTmp andImageURL:imageURLTmp andImageState:imageStateTmp];
            image1.imagePlayURL = imageURLTmp;
            
            [_imageUpLoads addObject:image1];
        }
        
        for (int i=0; i<[_audioShow count]; i++) {
            NSString *audioNameTmp = [_audioShow[i] objectForKey:@"audioName"];
            NSString *audioUpLoadUserNameTmp = [_audioShow[i] objectForKey:@"audioUserName"];
            NSString *audioURLTmp =@"audioShow.jpg" ;
            
            //audioState;
            
            NSString *audioPlayURLTmp= [_audioShow[i] objectForKey:@"audioURL"]; //填坑 播放url
            
            audioInfo *audio1 = [[audioInfo alloc]initWithAudioName:audioNameTmp andAudioUpLoadUserName:audioUpLoadUserNameTmp andAudioURL:audioURLTmp andAudioState:YES];
            audio1.audioPlayURL = audioPlayURLTmp;
            
            NSLog(@"-%@--%@--%@-",audioNameTmp,audioPlayURLTmp,audioUpLoadUserNameTmp);
            
            [_audioUpLoads addObject:audio1];
            
        }
        
        for (int i=0 ;i< [_videoShow count]; i++) {
            videoNameTmp = [_videoShow[i] objectForKey:@"videoName"];
            videoUploadUserNameTmp = [_videoShow[i] objectForKey:@"videoUserName"];
            videoURLTmp = [_videoShow[i] objectForKey:@"videoURL"];
            //videoStateTmp = [_videoShow[i] objectForKey:@"videoState"];
            NSLog(@"videoNameTmp:%@  %@  %@",videoNameTmp,videoUploadUserNameTmp,videoURLTmp);
            
            videoInfo *video1 = [[videoInfo alloc]initWithvideoName:videoNameTmp andVideoUpLoadUserName:videoUploadUserNameTmp andVideoURL:videoURLTmp andVideoState:YES];
            video1.videoPlayURL = videoURLTmp;
            NSLog(@"video1:%@",video1);
            [_videoUpLoads addObject:video1];
        }
        
        NSLog(@"_imageUpLoads of Number:%i",[_imageUpLoads count]);
        NSLog(@"_videoUpLoads of Number:%i",[_videoUpLoads count]);
        NSLog(@"_audioUpLoads of Number:%i",[_audioUpLoads count]);
    
        [_profileUpLoads addObject:_imageUpLoads];
        [_profileUpLoads addObject:_videoUpLoads];
        [_profileUpLoads addObject:_audioUpLoads];
        NSLog(@"_profileUpLoads of Number:%i",[_profileUpLoads count]);
        
        NSLog(@"----------------------------------------------%@",_profileUpLoads);
        
        [_tableView reloadData];

    } failure:^(NSURLSessionDataTask *task, NSError * error) {
        NSLog(@"为什么出错了！！！！！！");
        NSLog(@"ERROR:%@",error);
    }];
    
    
}

#pragma mark 数据源方法
#pragma makr 返回分组数目
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"返回分组数目执行了");
    return _profileUpLoads.count;//图片视频音频各一个section
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"返回每组行数数目执行了");
   
    
    switch (section) {
        case 0:
            return [_imageUpLoads count];
            break;
        case 1:
            return [_videoUpLoads count];
            break;
        case 2:
            return [_audioUpLoads count];
            break;
            
        default:
            return 0;
            break;
    }
    
    //return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"开始返回Cell");
    imageInfo *image;
    videoInfo *video;
    audioInfo *audio;
    
    //由于此方法调用十分频繁，cell的标识声明静态变量有利于性能优化
    static NSString *cellIdentifier = @"UITableViewIndentifierKey1";
    //根据标识符先去缓存池取
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //如果缓存池中没有则宠幸创建并放到缓存池当中
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    /*
    switch (indexPath.section) {
        
        case 0:
            NSLog(@"image cell");
            cell.textLabel.text = image.imageName;
            cell.detailTextLabel.text = [image getImageUpLoadUserName:image.imageUpLoadUserName];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            //cell.imageView.image = [UIImage imageNamed:image.imageURL];
            cell.imageView.image = [UIImage imageNamed:@"1.jpg"];

            
            return cell;
            break;
         
        case 1:
            NSLog(@"video cell");
            cell.textLabel.text = video.videoName;
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.detailTextLabel.text = [video getUpLoadUserName:video.videoUploadUserName];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
            cell.imageView.image = [UIImage imageNamed:@"2.jpg"];
            NSLog(@"%@",video.videoURL);
            return cell;
            break;
        
        case 2:
            NSLog(@"audio cell");
            cell.textLabel.text = audio.audioName;
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.detailTextLabel.text = [audio getAudioUpLoadUserName:audio.audioUpLoadUserName];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
            cell.imageView.image = [UIImage imageNamed:@"3.jpg"];
            NSLog(@"%@",audio.audioURL);
            return cell;
            break;
        default:
            return nil;
            break;
    }
    */
    if (indexPath.section == 0) {
        image = _imageUpLoads[indexPath.row];
        cell.textLabel.text = image.imageName;
        cell.detailTextLabel.text = [image getImageUpLoadUserName:image.imageUpLoadUserName];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:image.imageURL]];
        UIImage *image1 = [UIImage imageWithData:data];
        
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
        return cell;

    }else if (indexPath.section == 1){
        video = _videoUpLoads[indexPath.row];
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
    }else{
        audio = _audioUpLoads[indexPath.row];
        cell.textLabel.text = audio.audioName;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.text = [audio getAudioUpLoadUserName:audio.audioUpLoadUserName];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
        cell.imageView.image = [UIImage imageNamed:audio.audioURL];     //音频设置一张默认数据在前面显示
        return cell;

    }
}

#pragma mark 返回每组的头标题名称
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return [NSString stringWithFormat:@"我上传的图片资源"];
            break;
        case 1:
            return [NSString stringWithFormat:@"我上传的视频资源"];
            break;
        case 2:
            return [NSString stringWithFormat:@"我上传的语言资源"];
            break;
        default:
            return nil;
            break;
    }
}

#pragma mark 代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
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

#pragma mark 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        audioInfo *audio = _audioUpLoads[indexPath.row];
        
        videoPlayViewController *viewController = [[videoPlayViewController alloc]init];
        viewController.mediaPath = audio.audioPlayURL;
        [self.navigationController pushViewController:viewController animated:NO];
    }
    else if (indexPath.section == 1){
        videoInfo *video = _videoUpLoads[indexPath.row];
        
        
        videoPlayViewController *viewController = [[videoPlayViewController alloc]init];
        viewController.mediaPath = video.videoPlayURL;
        
        [self.navigationController  pushViewController:viewController animated:NO];

    }
    

}

//返回决定单元格的编辑状态
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
//返回值作为删除指定表格行是确定按钮的文本
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"确认删除";
}
//决定某行是否可以编辑
-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//删除的具体方法
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger rowNo = [indexPath row];
        NSInteger sectionNo = [indexPath section];
        if (sectionNo == 0) {
            [_imageUpLoads removeObjectAtIndex:rowNo];
            [_deleteResource addObject:[_imageUpLoads objectAtIndex:rowNo]];
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else if (sectionNo == 1) {
            [_videoUpLoads removeObjectAtIndex:rowNo];
            [_deleteResource addObject:[_videoUpLoads objectAtIndex:rowNo]];
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else if (sectionNo == 2){
            [_audioUpLoads removeObjectAtIndex:rowNo];
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [_deleteResource addObject:[_videoUpLoads objectAtIndex:rowNo]];
        }
    }
}
-(void)toggleEdit{
    //用户单击了“删除按钮”
    [_tableView setEditing:!_tableView.editing animated:YES];
    if (_tableView.editing) {
        self.navigationItem.rightBarButtonItem.title = @"完成";
        
    }else{
        self.navigationItem.rightBarButtonItem.title = @"删除";
    }
    
}



@end

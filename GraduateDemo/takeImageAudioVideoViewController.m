//
//  takeImageAudioVideoViewController.m
//  GraduateDemo
//
//  Created by LeeLom on 16/3/31.
//  Copyright © 2016年 LeeLom. All rights reserved.
//

#import "takeImageAudioVideoViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "audioRecordViewController.h"
#import "AFNetworking.h"
#import "videoUploadViewController.h"
#import "imageUploadViewController.h"

@interface takeImageAudioVideoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic) BOOL isVideo;
@property (strong,nonatomic) UIImagePickerController *imagePicker;
@property (strong,nonatomic) AVPlayer *player;
@property (strong,nonatomic)UIImageView *photo;

@end

@implementation takeImageAudioVideoViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    //设置背景色
    //self.view.backgroundColor = [UIColor colorWithRed:227/255.0 green:238/255.0 blue:223/255.0 alpha:1.0];//讲真的 这背景色 太特么丑了
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"拍摄页面";
    
    //UIButton *takeImageButton = [[UIButton alloc]init];
    UIButton *takeImageButton = [[UIButton alloc] init];
    int buttonHeight = 40;
    int buttonWidth = self.view.bounds.size.width - 40;
    int buttonY = (self.view.bounds.size.height - 110 - 160)/2 + 60;
    
    takeImageButton.frame = CGRectMake(20,buttonY, buttonWidth, buttonHeight);
    takeImageButton.backgroundColor = [UIColor lightGrayColor];
    //takeImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    takeImageButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
    takeImageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//设置按钮文字位置剧中，其实人家默认就是剧中的
    [takeImageButton setTintColor:[UIColor blackColor]];//设置按钮文字
    [takeImageButton setTitle:@"拍摄照片" forState:UIControlStateNormal];
    [takeImageButton addTarget:self action:@selector(setImageState) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takeImageButton];
    
    UIButton *takeVideoButton = [[UIButton alloc]init];
    takeVideoButton.frame = CGRectMake(20, buttonY+60, buttonWidth, buttonHeight);
    //takeVideoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    takeVideoButton.backgroundColor = [UIColor lightGrayColor];
    takeVideoButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
    takeVideoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//设置按钮文字位置剧中，其实人家默认就是剧中的
    [takeVideoButton setTintColor:[UIColor whiteColor]];//设置按钮文字
    [takeVideoButton setTitle:@"录制视频" forState:UIControlStateNormal];
    [takeVideoButton addTarget:self action:@selector(setVideoState) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takeVideoButton];
    
    UIButton *takeAudioButton = [[UIButton alloc]init];
    takeAudioButton.frame = CGRectMake(20, buttonY+120, buttonWidth, buttonHeight);
    //takeAudioButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    takeAudioButton.backgroundColor = [UIColor lightGrayColor];
    takeAudioButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
    takeAudioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//设置按钮文字位置剧中，其实人家默认就是剧中的
    [takeAudioButton setTintColor:[UIColor whiteColor]];//设置按钮文字
    [takeAudioButton setTitle:@"录制音频" forState:UIControlStateNormal];
    [takeAudioButton addTarget:self action:@selector(toAudioRecordViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takeAudioButton];
    
    self.photo = [[UIImageView alloc]initWithFrame:CGRectMake(25, 50, 300, 300)];
    [self.view addSubview:self.photo];
    
    
    NSLog(@"三个按钮加载完毕");

}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 私有化方法设置拍摄图片以及其他的状态
-(void)setImageState{
    self.isVideo = NO;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}
-(void)setVideoState{
    self.isVideo = YES;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

#pragma mark -UIImagePickerController代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        //如果是拍照
        UIImage *image;
        //如果允许编辑则获得编辑后的照片，否则获取原始照片
        image=[info objectForKey:UIImagePickerControllerOriginalImage];//获取原始照片
        //[self.photo setImage:image];//显示照片
        imageUploadViewController *viewController = [[imageUploadViewController alloc]init];
        viewController.imageToUpload = image;
        [self.navigationController pushViewController:viewController animated:YES];
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//保存到相簿
    }else if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){//如果是录制视频
        NSLog(@"video...");
        NSURL *url=[info objectForKey:UIImagePickerControllerMediaURL];//视频路径
        NSString *urlStr=[url path];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
            //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
            UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);//保存视频到相簿

        }
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    self.imagePicker = nil;
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //这里设置cancel按钮返回前一个view
    [self dismissViewControllerAnimated:YES completion:nil];
    self.imagePicker = nil;
    NSLog(@"取消");
}


#pragma mark - 私有方法
-(UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker=[[UIImagePickerController alloc]init];
        _imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;//设置image picker的来源，这里设置为摄像头
        _imagePicker.cameraDevice=UIImagePickerControllerCameraDeviceRear;//设置使用哪个摄像头，这里设置为后置摄像头
        if (self.isVideo) {
            _imagePicker.mediaTypes=@[(NSString *)kUTTypeMovie];
            _imagePicker.videoQuality=UIImagePickerControllerQualityTypeIFrame960x540;
            _imagePicker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModeVideo;//设置摄像头模式（拍照，录制视频）
            self.isVideo = nil;
            
        }else{
            _imagePicker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModePhoto;
            self.isVideo = nil;
        }
        _imagePicker.allowsEditing=YES;//允许编辑
        _imagePicker.delegate=self;//设置代理，检测操作
    }
    return _imagePicker;
}


//视频保存后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
        //录制完之后自动播放
        NSURL *url=[NSURL fileURLWithPath:videoPath];
        
        //以下是播放功能测试 现在不需要播放了
        /*
        _player=[AVPlayer playerWithURL:url];
        AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:_player];
        playerLayer.frame=CGRectMake(15, 50, 300, 300);
       [self.photo.layer addSublayer:playerLayer];
        [_player play];
        */
        videoUploadViewController *videoTableViewController = [[videoUploadViewController alloc]init];
        videoTableViewController.meidaPathtoUpload = videoPath;
        [self.navigationController pushViewController:videoTableViewController animated:YES];
    }
}


#pragma mark 录音按钮实现跳转到录音功能
-(void)toAudioRecordViewController{
    audioRecordViewController *viewController = [[audioRecordViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:NO];
    
}

@end

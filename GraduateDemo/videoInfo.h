//
//  videoInfo.h
//  GraduateDemo
//
//  Created by LeeLom on 16/3/30.
//  Copyright © 2016年 LeeLom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface videoInfo : NSObject

@property (strong,nonatomic) NSString *videoName;
@property (strong,nonatomic) NSString *videoUploadUserName;
@property (strong,nonatomic) NSString *videoURL;
@property (nonatomic) BOOL videoState;//用来存储视频审核状态，状态为YES才能发布

@property (nonatomic,strong) NSString *videoPlayURL; //填坑 播放url


//带参数的构造函数
-(videoInfo *)initWithvideoName:(NSString *)videoName andVideoUpLoadUserName:(NSString *)videoUploadUserName andVideoURL:(NSString *)videoURL andVideoState:(BOOL)videoState;

-(videoInfo *)initWithvideoName:(NSString *)videoName andVideoUpLoadUserName:(NSString *)videoUploadUserName andVideoURL:(NSString *)videoURL andVideoState:(BOOL)videoState andVideoPlayURL:(NSString *)videoPlayURL;

-(NSString *)getUpLoadUserName:(NSString *)videoUploadUserName;
//带参数的静态对象初始化方法

+(videoInfo *)initWithvideoName:(NSString *)videoName andVideoUpLoadUserName:(NSString *)videoUploadUserName andVideoURL:(NSString *)videoURL andVideoState:(BOOL)videoState;
+(videoInfo *)initWithvideoName:(NSString *)videoName andVideoUpLoadUserName:(NSString *)videoUploadUserName andVideoURL:(NSString *)videoURL andVideoState:(BOOL)videoState andVideoPlayURL:(NSString *)videoPlayURL;
@end

//
//  videoInfo.m
//  GraduateDemo
//
//  Created by LeeLom on 16/3/30.
//  Copyright © 2016年 LeeLom. All rights reserved.
//

#import "videoInfo.h"

@implementation videoInfo

@synthesize videoName = _videoName;
@synthesize videoUploadUserName = _videoUploadUserName;
@synthesize videoURL = _videoURL;
@synthesize videoState = _videoState;
@synthesize videoPlayURL = _videoPlayURL;

-(videoInfo *)initWithvideoName:(NSString *)videoName andVideoUpLoadUserName:(NSString *)videoUploadUserName andVideoURL:(NSString *)videoURL andVideoState:(BOOL)videoState{
    if (self = [super init]) {
        self.videoName = videoName;
        self.videoUploadUserName = videoUploadUserName;
        self.videoURL = videoURL;
        self.videoState = videoState;
    }
    return self;
}

-(videoInfo *)initWithvideoName:(NSString *)videoName andVideoUpLoadUserName:(NSString *)videoUploadUserName andVideoURL:(NSString *)videoURL andVideoState:(BOOL)videoState andVideoPlayURL:(NSString *)videoPlayURL{
    if (self = [super init]) {
        self.videoName = videoName;
        self.videoUploadUserName = videoUploadUserName;
        self.videoURL = videoURL;
        self.videoState = videoState;
        self.videoPlayURL = self.videoPlayURL;
    }
    return self;
}

+(videoInfo *)initWithvideoName:(NSString *)videoName andVideoUpLoadUserName:(NSString *)videoUploadUserName andVideoURL:(NSString *)videoURL andVideoState:(BOOL)videoState{
    videoInfo *video1 = [[videoInfo alloc]initWithvideoName:videoName andVideoUpLoadUserName:videoUploadUserName andVideoURL:videoURL andVideoState:videoState];
    return video1;
}
+(videoInfo *)initWithvideoName:(NSString *)videoName andVideoUpLoadUserName:(NSString *)videoUploadUserName andVideoURL:(NSString *)videoURL andVideoState:(BOOL)videoState andVideoPlayURL:(NSString *)videoPlayURL{
    videoInfo *video = [[videoInfo alloc]initWithvideoName:videoName andVideoUpLoadUserName:videoUploadUserName andVideoURL:videoURL andVideoState:videoState andVideoPlayURL:videoPlayURL];
    return video;
}

-(NSString *)getUpLoadUserName:(NSString *)videoUploadUserName{
    NSString *string = [[NSString alloc]initWithFormat:@"上传者：%@",videoUploadUserName];
    //[NSString stringWithFormat:@"上传者：%a",videoUploadUserName];
    return string;
}
@end

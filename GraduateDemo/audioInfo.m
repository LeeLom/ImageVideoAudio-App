//
//  audioInfo.m
//  GraduateDemo
//
//  Created by LeeLom on 16/3/30.
//  Copyright © 2016年 LeeLom. All rights reserved.
//

#import "audioInfo.h"

@implementation audioInfo

@synthesize audioName = _audioName;
@synthesize audioUpLoadUserName = _audioUpLoadUserName;
@synthesize audioURL = _audioURL;
@synthesize audioState = _audioState;
@synthesize audioPlayURL = _audioPlayURL;

-(audioInfo *)initWithAudioName:(NSString *)audioName andAudioUpLoadUserName:(NSString *)audioUpLoadUserName andAudioURL:(NSString *)audioURL andAudioState:(BOOL)audioState{
    if (self = [super init]) {
        self.audioName = audioName;
        self.audioUpLoadUserName = audioUpLoadUserName;
        self.audioURL = audioURL;
        self.audioState = audioState;
    }
    return self;
}

+(audioInfo *)initWithAudioName:(NSString *)audioName andAudioUpLoadUserName:(NSString *)audioUpLoadUserName andAudioURL:(NSString *)audioURL andAudioState:(BOOL)audioState{
    
    audioInfo *audio1 = [[audioInfo alloc]initWithAudioName:audioName andAudioUpLoadUserName:audioUpLoadUserName andAudioURL:audioURL andAudioState:audioState];
    return audio1;
}

-(NSString *)getAudioUpLoadUserName:(NSString *)audioUpLoadUserName{
    return [[NSString alloc]initWithFormat:@"上传者：%@",audioUpLoadUserName];
}
@end

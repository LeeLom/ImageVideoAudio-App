//
//  audioInfo.h
//  GraduateDemo
//
//  Created by LeeLom on 16/3/30.
//  Copyright © 2016年 LeeLom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface audioInfo : NSObject

@property (nonatomic,strong) NSString *audioName;
@property (nonatomic,strong) NSString *audioUpLoadUserName;
@property (nonatomic,strong) NSString *audioURL;
@property (nonatomic) BOOL audioState;

@property (nonatomic,strong) NSString *audioPlayURL; //填坑 播放url

//带参数的构造函数
-(audioInfo *)initWithAudioName:(NSString *)audioName andAudioUpLoadUserName:(NSString *)audioUpLoadUserName andAudioURL:(NSString *)audioURL andAudioState:(BOOL)audioState;
//带参数的静态对象初始化方法
+(audioInfo *)initWithAudioName:(NSString *)audioName andAudioUpLoadUserName:(NSString *)audioUpLoadUserName andAudioURL:(NSString *)audioURL andAudioState:(BOOL)audioState;

-(NSString *)getAudioUpLoadUserName:(NSString *)audioUpLoadUserName;

@end

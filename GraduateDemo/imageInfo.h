//
//  imageInfo.h
//  GraduateDemo
//
//  Created by LeeLom on 16/3/30.
//  Copyright © 2016年 LeeLom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface imageInfo : NSObject

@property (strong,nonatomic) NSString *imageName;
@property (strong,nonatomic) NSString *imageUpLoadUserName;
@property (strong,nonatomic) NSString *imageURL;
@property (nonatomic) BOOL imageState;

@property (nonatomic,strong) NSString *imagePlayURL; //填坑 播放url

//带参数的构造函数
-(imageInfo *)initWithImageName:(NSString *)imageName andImageUpLoadUserName:(NSString *)imageUpLoadUserName andImageURL:(NSString *)imageURL andImageState:(BOOL) imageState;

//带参数的静态对象初始化方法
+(imageInfo *)initWithImageName:(NSString *)imageName andImageUpLoadUserName:(NSString *)imageUpLoadUserName andImageURL:(NSString *)imageURL andImageState:(BOOL) imageState;

-(NSString *)getImageUpLoadUserName:(NSString *)imageUpLoadUserName;


@end

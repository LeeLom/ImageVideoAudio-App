//
//  imageInfo.m
//  GraduateDemo
//
//  Created by LeeLom on 16/3/30.
//  Copyright © 2016年 LeeLom. All rights reserved.
//

#import "imageInfo.h"

@implementation imageInfo

@synthesize imageName = _imageName;
@synthesize imageUpLoadUserName = _imageUpLoadUserName;
@synthesize imageURL = _imageURL;
@synthesize imageState = _imageState;
@synthesize imagePlayURL = _imagePlayURL;

-(imageInfo *)initWithImageName:(NSString *)imageName andImageUpLoadUserName:(NSString *)imageUpLoadUserName andImageURL:(NSString *)imageURL andImageState:(BOOL)imageState{
    if (self = [super init]) {
        self.imageName = imageName;
        self.imageUpLoadUserName = imageUpLoadUserName;
        self.imageURL = imageURL;
        self.imageState = imageState;
    }
    return self;
}

+(imageInfo *)initWithImageName:(NSString *)imageName andImageUpLoadUserName:(NSString *)imageUpLoadUserName andImageURL:(NSString *)imageURL andImageState:(BOOL)imageState{
    
    imageInfo *image1 = [[imageInfo alloc]initWithImageName:imageName andImageUpLoadUserName:imageUpLoadUserName andImageURL:imageURL andImageState:imageState];
    return image1;
}

-(NSString *)getImageUpLoadUserName:(NSString *)imageUpLoadUserName{
    return [[NSString alloc]initWithFormat:@"上传者：%@",imageUpLoadUserName];
}

@end

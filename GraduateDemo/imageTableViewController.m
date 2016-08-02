//
//  imageTableViewController.m
//  GraduateDemo
//
//  Created by LeeLom on 16/3/30.
//  Copyright © 2016年 LeeLom. All rights reserved.
//

#import "imageTableViewController.h"
#import "imageInfo.h"
#import "takeImageAudioVideoViewController.h"
#import "personInfoViewController.h"
#import "videoPlayViewController.h"
#import "AFNetworking.h"

#define imageInfoURL @"http://10.102.14.107:8000/imageJson.php"
#define personalURL @"http://10.102.14.107:8000/personalJson.php"

@interface imageTableViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    
    UITableView *_tableView;
    NSMutableArray *_images;//图片模型数组
    NSMutableArray *_imagesShow;//网络Json数据
}

@end

@implementation imageTableViewController

-(void) viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title = @"图片浏览";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"我" style:UIBarButtonItemStylePlain target:self action:@selector(toPersonInfoViewController)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(toTakeImageVideoAudioViewController)];
    
    [self initImageData];
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
    
    
    
    //以下纯属测试文件
    /*
    NSString *str = [NSString stringWithFormat:@"http://10.102.14.107:8000/videoJson.php"];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //从url中获取json数据
    */
     
    /*
     NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
     AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
     
     NSURL *URL = [NSURL URLWithString:@"http://example.com/download.zip"];
     NSURLRequest *request = [NSURLRequest requestWithURL:URL];
     
     NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
     NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
     return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
     } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
     NSLog(@"File downloaded to: %@", filePath);
     }];
     [downloadTask resume];
     */

    
    /*[manager GET:@"http://10.102.14.107:8000/videoJson.php" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];*/
    
    /*
    [manager GET:@"http://10.102.14.107:8000/audioJson.php" parameters:nil success:^(NSURLSessionDataTask * task, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        // NSDictionary *dic = (NSDictionary *)responseObject;
        // NSArray *arrData = (NSArray *)dic[@"videoJson"];
        // NSDictionary *dicRoot = (NSDictionary *)arrData;
        // NSString *value1 = [dicRoot valueForKey:@"videoName"];
        // NSLog(value1);
        NSString *haha = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"+++++%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
        NSError *error = nil;
        NSDictionary *string = [NSJSONSerialization JSONObjectWithData:[haha dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        //NSLog(@"_+_+_+%@", string);
        
        
        NSData *data = [haha dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        //NSLog(@"%@",[json objectForKey:@"audioJson"]);
        NSArray *arrayVideo = [json objectForKey:@"audioJson"];
        //NSLog(@"%@",[arrayVideo[2] objectForKey:@"audioURL"]);
    } failure:^(NSURLSessionDataTask * task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    */
}

#pragma mark 加载图片数据
-(void)initImageData{
    
    /*本地数据加载方式
     改用网络请求
    _images = [[NSMutableArray alloc]init];
    
    imageInfo *image1 = [[imageInfo alloc]initWithImageName:@"ImagePic1" andImageUpLoadUserName:@"LeeLom" andImageURL:@"1.jpg" andImageState:YES];
    imageInfo *image2 = [[imageInfo alloc]initWithImageName:@"ImagePic2" andImageUpLoadUserName:@"LeeLom" andImageURL:@"2.jpg" andImageState:YES];
    
    [_images addObject:image1];
    [_images addObject:image2];
    NSLog(@"_iamges:%@",_images);
     */
    
    //下面用AFNetworking 网络请求数据进行访问
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:imageInfoURL parameters:nil progress:nil success:^(NSURLSessionDataTask * task, id responseObject) {
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        _imagesShow = [[json objectForKey:@"imageJson"]mutableCopy];
        //NSLog(@"_imageShow:",_imagesShow);
        _images = [[NSMutableArray alloc]init];
        NSLog(@"Number of _imageShow:%i",[_imagesShow count]);
        
        for (int i=0; i<[_imagesShow count]; i++) {
            NSString *imageNameTmp = [_imagesShow[i] objectForKey:@"imageName"];
            NSString *imageUploadUserNameTmp = [_imagesShow[i] objectForKey:@"imageUserName"];
            NSString *imageURLTmp = [_imagesShow[i] objectForKey:@"imageURL"];//@"1.jpg";
            NSString *imageStateTmp = [_imagesShow[i] objectForKey:@"imageState"];
            NSString *imageURLPlayTmp = [_imagesShow[i] objectForKey:@"imageURL"];
            
            imageInfo *image1 = [[imageInfo alloc]initWithImageName:imageNameTmp andImageUpLoadUserName:imageUploadUserNameTmp andImageURL:imageURLTmp andImageState:imageStateTmp];
            image1.imagePlayURL = imageURLPlayTmp;
            
            [_images addObject:image1];
        }
            [_tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        NSLog(@"Error:%@",error);
    }];
}

#pragma mark 数据源方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"返回行数");
    return _images.count;
}

#pragma mark 返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    imageInfo *image = _images[indexPath.row];
    
    //由于此方法调用十分频繁，cell的标识声明静态变量有利于性能优化
    static NSString *cellIdentifier = @"UITableViewIndentifierKey1";
    //根据标识符先去缓存池取
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //如果缓存池中没有则宠幸创建并放到缓存池当中
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = image.imageName;
    cell.detailTextLabel.text = [image getImageUpLoadUserName:image.imageUpLoadUserName];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    /*修改imageView的frame和bounds 没有用；
    CGRect temp = cell.imageView.frame;
    temp.size.width = 80;
    temp.size.height = 80;
    cell.imageView.frame = temp;
    
    cell.imageView.bounds = CGRectMake(0, 0, 80, 80);
    */

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
    
    /*修改图片size没有用
    CGSize temp2 = image1.size;
    temp2.height = 80;
    temp2.width = 80;
    */
    
    //[cell.imageView setImage:image1];
    //cell.imageView.image = [UIImage imageNamed:image.imageURL];
    
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

/*
#pragma mark 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    videoPlayViewController *viewController = [[videoPlayViewController alloc]init];
    [self.navigationController  pushViewController:viewController animated:NO];
}
*/


@end

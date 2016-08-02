//
//  imageUploadViewController.m
//  GraduateDemo
//
//  Created by LeeLom on 16/5/21.
//  Copyright © 2016年 LeeLom. All rights reserved.
//

#import "imageUploadViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AFNetworking.h>

@interface imageUploadViewController ()<NSURLConnectionDelegate>{
    UIView *mediaView;
    UIProgressView *mediaProgressView;
    UIButton *uploadButton;
    UIImageView *imageView;
    
    NSMutableData *_responseData;
    NSString *picName;
}

@end

@implementation imageUploadViewController{
    NSData *pngData;
    NSData *syncResData;
    NSMutableURLRequest *request;
    UIActivityIndicatorView *indicator;
    
#define URL            @"http://10.102.14.107:8000/Upload_Image.php"  // change this URL
#define NO_CONNECTION  @"No Connection"
#define NO_IMAGE      @"NO IMAGE SELECTED"
}
@synthesize meidaPathtoUpload = _meidaPathtoUpload;
@synthesize imageToUpload = _imageToUpload;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //界面设计
    self.navigationItem.title = @"资源上传";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat viewY = 20 + self.navigationController.navigationBar.frame.size.height;
    CGFloat viewWidth = self.view.frame.size.width - 60;//屏幕去掉左右30的宽度
    
    CGRect mediaFrame = CGRectMake(30, viewY+20 , viewWidth, viewWidth);
    CGRect buttonFrame = CGRectMake(30, viewY+30+20+30+viewWidth, viewWidth, 30);
    CGRect progressFrame = CGRectMake(30, viewY+30+20+viewWidth,viewWidth,2);
    
    mediaView = [[UIView alloc]initWithFrame:mediaFrame];
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, viewWidth, viewWidth)];
    UIImage *imageDefault = [UIImage imageNamed:@"1.jpg"];
    imageView.image = imageDefault;
    
    //pngData = UIImagePNGRepresentation(_imageToUpload);
    pngData = UIImageJPEGRepresentation(_imageToUpload, 0.3);
    imageView.image = _imageToUpload;
    [mediaView addSubview:imageView];
    [self.view addSubview:mediaView];
    
    mediaProgressView = [[UIProgressView alloc]initWithFrame:progressFrame];
    mediaProgressView.progress = 0.5;
    [self.view addSubview:mediaProgressView];
    
    //uploadButton = [[UIButton alloc]initWithFrame:buttonFrame];
    uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadButton.backgroundColor = [UIColor whiteColor];
    uploadButton.frame = buttonFrame;
    [uploadButton.layer setMasksToBounds:YES];
    uploadButton.layer.cornerRadius = 10;
    uploadButton.layer.borderWidth = 1.0;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.0, 120.0/255.0, 1.0, 1.0 });
    
    UIColor *systemBlue = [UIColor colorWithRed:0.0 green:120.0/255.0 blue:1.0 alpha:1.0];
    uploadButton.layer.borderColor = colorref;
    //uploadButton.backgroundColor = [UIColor whiteColor];
    [uploadButton setTitle:@"确认上传" forState:UIControlStateNormal];
    [uploadButton setTitleColor:systemBlue forState:UIControlStateNormal];
    [uploadButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    [uploadButton addTarget:self action:@selector(didUpload) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:uploadButton];
    
    //图片名字；
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    picName = str;
    
    [self initPB];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL) setParams{
    
    if(pngData != nil){
        
        [indicator startAnimating];
        
        request = [NSMutableURLRequest new];
        request.timeoutInterval = 20.0;
        [request setURL:[NSURL URLWithString:URL]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
        [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/536.26.14 (KHTML, like Gecko) Version/6.0.1 Safari/536.26.14" forHTTPHeaderField:@"User-Agent"];
        
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploaded_file\"; filename=\"%@.png\"\r\n", @"Uploaded_file"] dataUsingEncoding:NSUTF8StringEncoding]];
        //[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploaded_file\"; filename=\"%@.png\"\r\n", picName] dataUsingEncoding:NSUTF8StringEncoding]];//改变时间的名字
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploaded_file\"; filename=\"%@.png\"\r\n", picName] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[NSData dataWithData:pngData]];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [request setHTTPBody:body];
        [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
        
        return TRUE;
        
    }else{
        
        //response.text = NO_IMAGE;
        
        return FALSE;
    }
}
- (void)didUpload {
    if( [self setParams]){
        
        NSError *error = nil;
        NSURLResponse *responseStr = nil;
        syncResData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseStr error:&error];
        NSString *returnString = [[NSString alloc] initWithData:syncResData encoding:NSUTF8StringEncoding];
        
        NSLog(@"pngData:%@",pngData);
        NSLog(@"ERROR %@", error);
        NSLog(@"RES %@", responseStr);
        
        NSLog(@"%@", returnString);
        
        if(error == nil){
            //response.text = returnString;
        }
        
        [indicator stopAnimating];
        
    }else{
        NSLog(@"Somet thing wrong when didUplaod");
    }
    
    
}

-(void) initPB{
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width)/2, ([UIScreen mainScreen].bounds.size.height)/2 , 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
}
#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    
    //response.text = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    //NSLog(@"_responseData %@", response.text);
    
    [indicator stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    
    NSLog(@"didFailWithError %@", error);
    
}


@end


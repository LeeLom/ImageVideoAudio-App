//
//  audioRecordViewController.m
//  GraduateDemo
//
//  Created by LeeLom on 16/3/31.
//  Copyright © 2016年 LeeLom. All rights reserved.
//

#import "audioRecordViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AFNetworking.h>
#define kRecordAudioFile @"myRecord.caf"

@interface audioRecordViewController() <AVAudioRecorderDelegate>{
    UIButton *uploadButton;
    
    NSMutableData *_responseData;
    NSString *picName;
    NSString *audioPath;
}

@property (nonatomic,strong) AVAudioRecorder *audioRecorder;//音频录音机
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;//音频播放器，用于播放录音文件
@property (nonatomic,strong) NSTimer *timer;//录音声波监控

/*
@property (weak,nonatomic) UIButton *record;
@property (weak,nonatomic) UIButton *pause;
@property (weak,nonatomic) UIButton *resume;
 @property (weak,nonatomic) UIButton *stop; */

@end

@implementation audioRecordViewController{
    NSData *pngData;
    NSData *syncResData;
    NSMutableURLRequest *request;
    UIActivityIndicatorView *indicator;
    
#define URL            @"http://10.102.14.107:8000/Upload_Audio.php"  // change this URL
#define NO_CONNECTION  @"No Connection"
#define NO_IMAGE      @"NO IMAGE SELECTED"
}


/*
@synthesize record = _record;
@synthesize pause = _pause;
@synthesize resume = _resume;
@synthesize stop = _stop;
@synthesize audioPower = _audioPower;
*/
@synthesize audioPower = _audioPower;


-(void) viewDidLoad{
    [super viewDidLoad];
    //设置背景色
    self.view.backgroundColor = [UIColor colorWithRed:227/255.0 green:238/255.0 blue:223/255.0 alpha:1.0];
    self.navigationItem.title = @"录音页面";
    
    CGFloat viewWidth = self.view.bounds.size.width;
    CGFloat btnWidth = (viewWidth-40-30)/4;
    
    UIButton *recordButton = [[UIButton alloc]init];
    recordButton.frame = CGRectMake(20, 376, btnWidth, 30);
    recordButton.backgroundColor = [UIColor lightGrayColor];
    recordButton.titleLabel.font = [UIFont systemFontOfSize:12.5];
    [recordButton setTintColor:[UIColor whiteColor]];
    [recordButton setTitle:@"开始录音" forState:UIControlStateNormal];
    [recordButton addTarget:self action:@selector(recordClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recordButton];
    
    UIButton *pauseButton = [[UIButton alloc]init];
    pauseButton.frame = CGRectMake(30 + btnWidth, 376, btnWidth, 30);
    pauseButton.backgroundColor = [UIColor lightGrayColor];
    pauseButton.titleLabel.font = [UIFont systemFontOfSize:12.5];
    [pauseButton setTintColor:[UIColor whiteColor]];
    [pauseButton setTitle:@"暂停录音" forState:UIControlStateNormal];
    [pauseButton addTarget:self action:@selector(pauseClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pauseButton];
    
    UIButton *resumeButton = [[UIButton alloc]init];
    resumeButton.frame = CGRectMake(40 + 2*btnWidth, 376, btnWidth, 30);
    resumeButton.backgroundColor = [UIColor lightGrayColor];
    resumeButton.titleLabel.font = [UIFont systemFontOfSize:12.5];
    [resumeButton setTintColor:[UIColor whiteColor]];
    [resumeButton setTitle:@"恢复录音" forState:UIControlStateNormal];
    [resumeButton addTarget:self action:@selector(resumeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resumeButton];
    
    UIButton *stopButton = [[UIButton alloc]init];
    stopButton.frame = CGRectMake(50 + 3*btnWidth, 376, btnWidth, 30);
    stopButton.backgroundColor = [UIColor lightGrayColor];
    stopButton.titleLabel.font = [UIFont systemFontOfSize:12.5];
    [stopButton setTintColor:[UIColor whiteColor]];
    [stopButton setTitle:@"停止录音" forState:UIControlStateNormal];
    [stopButton addTarget:self action:@selector(stopClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopButton];
    
    uploadButton = [[UIButton alloc]init];
    uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadButton.backgroundColor = [UIColor whiteColor];
    CGRect buttonFrame = CGRectMake(20, 376 + 60, self.view.frame.size.width - 40, 30);
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
    uploadButton.hidden = YES;
    [self.view addSubview:uploadButton];
    
    _audioPower = [[UIProgressView alloc]init];
    self.audioPower.frame = CGRectMake(20, 198, viewWidth-40, 2);
    [_audioPower setProgressViewStyle:UIProgressViewStyleDefault];
    [self.view addSubview:self.audioPower];
    
    //图片名字；
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    picName = str;
    
    [self setAudioSession];
    
}
-(void) didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


#pragma mark - 私有方法
/**
 *  设置音频会话
 */
-(void)setAudioSession{
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}

/**
 *  取得录音文件保存路径
 *
 *  @return 录音文件路径
 */
-(NSURL *)getSavePath{
    NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr=[urlStr stringByAppendingPathComponent:kRecordAudioFile];
    NSLog(@"file path:%@",urlStr);
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    return url;
}

/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
-(NSDictionary *)getAudioSetting{
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
    return dicM;
}

/**
 *  获得录音机对象
 *
 *  @return 录音机对象
 */
-(AVAudioRecorder *)audioRecorder{
    if (!_audioRecorder) {
        //创建录音文件保存路径
        NSURL *url=[self getSavePath];
        //创建录音格式设置
        NSDictionary *setting=[self getAudioSetting];
        //创建录音机
        NSError *error=nil;
        _audioRecorder=[[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate=self;
        _audioRecorder.meteringEnabled=YES;//如果要监控声波则必须设置为YES
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}

/**
 *  创建播放器
 *
 *  @return 播放器
 */
-(AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        NSURL *url=[self getSavePath];
        NSError *error=nil;
        _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        _audioPlayer.numberOfLoops=0;
        [_audioPlayer prepareToPlay];
        if (error) {
            NSLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioPlayer;
}

/**
 *  录音声波监控定制器
 *
 *  @return 定时器
 */
-(NSTimer *)timer{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
    }
    return _timer;
}

/**
 *  录音声波状态设置
 */
-(void)audioPowerChange{
    [self.audioRecorder updateMeters];//更新测量值
    float power= [self.audioRecorder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0
    CGFloat progress=(1.0/160.0)*(power+160.0);
    [self.audioPower setProgress:progress];
}
#pragma mark - UI事件
- (void)recordClick {
    if (![self.audioRecorder isRecording]) {
        [self.audioRecorder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
        self.timer.fireDate=[NSDate distantPast];
    }
}

- (void)pauseClick {
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder pause];
        self.timer.fireDate=[NSDate distantFuture];
    }
}


- (void)resumeClick {
    [self recordClick];
}
- (void)stopClick{
    [self.audioRecorder stop];
    self.timer.fireDate=[NSDate distantFuture];
    self.audioPower.progress=0.0;
}

#pragma mark - 录音机代理方法
/**
 *  录音完成，录音完成后播放录音
 *
 *  @param recorder 录音机对象
 *  @param flag     是否成功
 */
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    if (![self.audioPlayer isPlaying]) {
        [self.audioPlayer play];
    }
    NSLog(@"录音完成!");
    uploadButton.hidden = NO;
    pngData = [NSData dataWithContentsOfURL:[self getSavePath]];
}

//上传代码
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
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploaded_file\"; filename=\"%@.caf\"\r\n", picName] dataUsingEncoding:NSUTF8StringEncoding]];
        
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
        
        NSLog(@"pngData:%@",@"hehehehhe");
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

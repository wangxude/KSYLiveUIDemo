//
//  KSYBackgroundPushVC.m
//  KSYLiveUIDemo
//
//  Created by 王旭 on 2017/11/17.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import "KSYBackgroundPushVC.h"
//九宫格View
#import "KSYCustomCollectView.h"
//头部的头像和名称
#import "KSYHeadControl.h"
//数据模型
#import "KSYSettingModel.h"
//点击空白视图
#import "KSYSubBlackView.h"
//截图提示框
#import "KSYToolTipsView.h"

#import "KSYQRCode.h"

@interface KSYBackgroundPushVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

//底部bottomView
@property(nonatomic,strong)UIView* bottomView;
//底部的录屏按钮的view
@property(nonatomic,strong)KSYSubBlackView* recordView;
//功能视图的view
@property(nonatomic,strong)KSYCustomCollectView * collectView;
//美颜的二级视图的view
@property(nonatomic,strong)KSYSecondView* skinCareView;
//顶部视图的view
@property(nonatomic,strong)UIView* topView;

//旁路录像文件的路径
@property(nonatomic,copy)NSString* byPassFilePath;

//镜像状态
@property(nonatomic,assign)BOOL mirrorState;
//静音状态
@property(nonatomic,assign)BOOL muteState;
@end

@implementation KSYBackgroundPushVC


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (!_wxStreamerKit) {
        _wxStreamerKit = [[KSYGPUBgpStreamerKit alloc]init];
    }
    
    KSYSettingModel* model = [KSYSettingModel modelWithDictionary:self.modelSenderDic];
    //音频编码器类型
    _wxStreamerKit.streamerBase.audioCodec = model.audioCodecType;
    //视频编码器类型
    _wxStreamerKit.streamerBase.videoCodec = model.videoCodecTpye;
    //推流分辨率
    //_wxStreamerKit.previewDimension = model.strResolutionSize;
    //背景图片设置参数
    CGSize streamSize = model.strResolutionSize;
    _wxStreamerKit.streamDimension =  CGSizeMake(streamSize.height, streamSize.width);
    //性能模式
    _wxStreamerKit.streamerBase.videoEncodePerf = model.performanceModel;
    //直播场景
    _wxStreamerKit.streamerBase.liveScene = model.liveSence;
    
    //videoFPS (测试)
    _wxStreamerKit.streamerBase.videoFPS = 20;
    //扩展增强美颜滤镜
   // _currentFilter = [[KSYGPUBeautifyExtFilter alloc]init];
    //摄像头的位置
 //   _wxStreamerKit.cameraPosition = AVCaptureDevicePositionBack;
    //视频输出格式
    _wxStreamerKit.gpuOutputPixelFormat = kCVPixelFormatType_32BGRA;
    //采集格式
 //   _wxStreamerKit.capturePixelFormat = kCVPixelFormatType_32BGRA;
    
    //视频编码
    _wxStreamerKit.streamerBase.videoInitBitrate =  800;
    _wxStreamerKit.streamerBase.videoMaxBitrate  = 1000;
    _wxStreamerKit.streamerBase.videoMinBitrate  =    0;
    _wxStreamerKit.streamerBase.audiokBPS        =   48;
    // 设置编码码率控制
    _wxStreamerKit.streamerBase.recScene     = KSYRecScene_ConstantQuality;
    //旁路录制会回调该block
    UIImage* image = [UIImage imageNamed:@"背景图片.jpg"];
    _wxStreamerKit.bgPic  = [[GPUImagePicture alloc] initWithImage:image];
    self.byPassFilePath =[NSHomeDirectory() stringByAppendingString:@"/Library/Caches/rec.mp4"];
    weakObj(self);
    _wxStreamerKit.streamerBase.bypassRecordStateChange = ^(KSYRecordState recordState) {
        [selfWeak onBypassRecordStateChange:recordState];
    };
    //开始采集的代码
    [self beginCapture];
    //开始推流
    [self streamFunc];
    //开启视频配置和采集
    [_wxStreamerKit startVideoCap];
    //添加布局的代码
    [self addTopSubView];
    [self addCenterView];
    [self addBottomSubView];
    
}
-(void)displayBottom:(NSNotification*)notice{
    self.bottomView.alpha = 1;
}
#pragma mark - 自定义的方法
/**
 添加观察者,监听推流状态改变的通知
 */
-(void)addObserver{
    
    //监听底部按钮的view
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayBottom:) name:@"displayBottomView" object:nil];
    //监听推流状态
    NSNotificationCenter* notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(streamStateChange:) name:KSYStreamStateDidChangeNotification object:nil];
    //监听采集状态的改变
    //    [notification addObserver:self selector:@selector(onCaptureStateChange:) name:KSYCaptureStateDidChangeNotification object:nil];
    
}
/**
 移除观察者
 */

-(void)removeObserver{
    [[NSNotificationCenter defaultCenter]removeObserver: self];
}

-(void)streamStateChange:(NSNotification*)notice{
    switch (_wxStreamerKit.streamerBase.streamState) {
        case KSYStreamStateIdle:
            NSLog(@"-----%@",@"空闲状态");
            break;
        case KSYStreamStateConnected:
            NSLog(@"----%@",@"连接中");
            break;
        case KSYStreamStateDisconnecting:
            NSLog(@"----%@",@"断开连接中");
        default:
            NSLog(@"----%@",@"发生错误");
            break;
    }
}

#pragma mark - 旁路录制状态的改变
- (void) onBypassRecordStateChange: (KSYRecordState) newState {
    if (newState == KSYRecordStateRecording){
        NSLog(@"start bypass record");
    }
    else if (newState == KSYRecordStateStopped) {
        NSLog(@"stop bypass record");
        [self saveVideoToAlbum:_byPassFilePath];
        // _miscView.swBypassRec.on = NO;
    }
    else if (newState == KSYRecordStateError) {
        NSLog(@"bypass record error %@", _wxStreamerKit.streamerBase.bypassRecordErrorName);
    }
}
#pragma mark - bypass record & record
-(void) onBypassRecord:(BOOL)selectState{
    BOOL bRec = _wxStreamerKit.streamerBase.bypassRecordState == KSYRecordStateRecording;
    if (selectState){
        if ( _wxStreamerKit.streamerBase.isStreaming && !bRec){
            // 如果启动录像时使用和上次相同的路径,则会覆盖掉上一次录像的文件内容
            [KSYBackgroundPushVC deleteFile:_byPassFilePath];
            NSURL *url =[[NSURL alloc] initFileURLWithPath:self.byPassFilePath];
            [_wxStreamerKit.streamerBase startBypassRecord:url];
           // [[KSYToolTipsView shareInstance] showLabelLongTime:@"00:00"];
        }
        else {
            NSString * msg = @"推流过程中才能旁路录像";
            [self toast:msg time:1];
        }
    }
    else{
       // [[KSYToolTipsView shareInstance] stopTimer];
        [_wxStreamerKit.streamerBase stopBypassRecord];
    }
}
/**
 开始预览
 */
-(void)beginCapture{
//    if (!_wxStreamerKit.vCapDev.isRunning) {
//        _wxStreamerKit.videoOrientation = [[UIApplication sharedApplication]statusBarOrientation];
        [_wxStreamerKit setupFilter:_currentFilter];
        //启动预览
        [_wxStreamerKit startPreview:self.view];
//    }
//    else{
//        [_wxStreamerKit stopPreview];
//    }
}

/**
 开始推流
 */
-(void)streamFunc{
    if (_wxStreamerKit.streamerBase.streamState == KSYStreamStateIdle || _wxStreamerKit.streamerBase.streamState == KSYStreamStateError) {
        //启动推流
        [_wxStreamerKit.streamerBase startStream:self.rtmpUrl];
    }
    else{
        [_wxStreamerKit stopPreview];
    }
}
#pragma mark - 添加顶部视图
/** 添加顶部的按钮*/
-(void)addTopSubView{
    
    self.topView = [[UIView alloc]initWithFrame:KSYScreen_Frame(0, 0, KSYScreenWidth, KSYScreenHeight)];
    [self.view addSubview:self.topView];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.view).offset(30);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(@40);
    }];
    
    KSYHeadControl* control = [[KSYHeadControl alloc]init];
    [self.topView addSubview:control];
    [control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView).offset(10);
        make.top.equalTo(self.topView);
        make.width.mas_equalTo(@120);
        make.height.mas_equalTo(@40);
    }];
    
    
    
    UIButton* closeBtn = [[UIButton alloc]initButtonWithTitle:@"" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
        NSLog(@"%@",@"关闭");
        //从父视图中移除
        [self.collectView removeFromSuperview];
        //移除美颜的二级视图
        [self.skinCareView removeFromSuperview];
        [self removeObserver];
        [_wxStreamerKit stopPreview];
        _wxStreamerKit = nil;
        [self dismissViewControllerAnimated:YES completion:nil];
      //  [[KSYToolTipsView shareInstance]removeSubView];
    }];
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.topView addSubview:closeBtn];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView).offset(-10);
        make.top.equalTo(control.mas_top);
        make.width.mas_equalTo(@40);
        make.height.equalTo(control.mas_height);
    }];
    
    UIButton* flowAddressBtn = [[UIButton alloc]initButtonWithTitle:@"拉流地址" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
        KSYQRCode *playUrlQRCodeVc = [[KSYQRCode alloc] init];
        //状态为直播视频
        //推流地址对应的拉流地址
        NSString * uuidStr =[[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSString *devCode  = [[uuidStr substringToIndex:3] lowercaseString];
        NSString *streamPlaySrv = @"http://test.hdllive.ks-cdn.com/live";
        NSString *streamPlayPostfix = @".flv";
        playUrlQRCodeVc.url = [ NSString stringWithFormat:@"%@/%@%@", streamPlaySrv, devCode,streamPlayPostfix];
        [self presentViewController:playUrlQRCodeVc animated:YES completion:nil];
    }];
    [self.topView addSubview:flowAddressBtn];
    
    [flowAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(closeBtn.mas_left).offset(-10);
        make.top.equalTo(control.mas_top);
        make.width.mas_equalTo(@80);
        make.height.equalTo(control.mas_height);
    }];
}

/** 添加中间的按钮 */
-(void)addCenterView{
    UIButton* backGroundPicBtn = [[UIButton alloc]initButtonWithTitle:@"  切换\n背景图" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
       // sender.selected = !sender.selected;
//        if (sender.selected) {
            [self selectPictureToView];
//        }
//        else{
//
//        }
    }];
    backGroundPicBtn.titleLabel.lineBreakMode = 0;
//    [backGroundPicBtn setTitle:@"  关闭\n背景图" forState:UIControlStateSelected];
//    backGroundPicBtn.selected = YES;
    [self.view addSubview:backGroundPicBtn];
    
    [backGroundPicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.centerY.equalTo(self.view);
        make.width.mas_equalTo(@50);
        make.height.mas_equalTo(@40);
    }];
}

#pragma mark -  添加底部的按钮
-(void)addBottomSubView{
#pragma mark - 录屏的view
    //录屏的view
    self.recordView = [[KSYSubBlackView alloc]initWithFrame:KSYScreen_Frame(0, 0, KSYScreenWidth, KSYScreenHeight)];
    [self.view addSubview:self.recordView];
    
    //摄像头切换
    UIButton* screenShotBtn = [[UIButton alloc]initButtonWithTitle:@"截屏" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
        
        //  如果有美颜滤镜, 可以从滤镜上获取截图(UIImage) 不带水印
        //GPUImageOutput * filter = self.ksyFilterView.curFilter;
        //  直接从预览mixer上获取截图(UIImage) 带水印
//        GPUImageOutput * filter = _wxStreamerKit.vPreviewMixer;
//        if (filter){
//            [filter useNextFrameForImageCapture];
//            UIImage * img =  filter.imageFromCurrentFramebuffer;
//            [KSYUIBaseViewController saveImage: img
//                                            to: @"snap2.png" ];
//            UIImageWriteToSavedPhotosAlbum(img,nil,nil,nil);
//            [[KSYToolTipsView shareInstance] showLabelWithString:@"截图已保存至手机相册"];
//        }
    }];
    [self.recordView addSubview:screenShotBtn];
    
    
    
    
    weakObj(self);
    UIButton* recordScreenBtn = [[UIButton alloc]initButtonWithTitle:@"" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
        // 省略了部分非关键代码
        sender.selected = !sender.selected;
        if (sender.selected) {
            [selfWeak onBypassRecord:YES];
        }
        else{
            [selfWeak onBypassRecord:NO];
        }
    }];
    
    [recordScreenBtn setImage:[UIImage imageNamed:@"录屏白"] forState:UIControlStateNormal];
    [recordScreenBtn setImage:[UIImage imageNamed:@"录屏红"] forState:UIControlStateSelected];
    [self.recordView addSubview:recordScreenBtn];
    
    UIButton* cancelBtn = [[UIButton alloc]initButtonWithTitle:@"返回" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
        recordScreenBtn.selected = NO;
        //[[KSYToolTipsView shareInstance] stopTimer];
        self.recordView.alpha = 0;
        self.topView.alpha = 1;
        self.bottomView.alpha = 1;
    }];
    [self.recordView addSubview:cancelBtn];
    
    [screenShotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.recordView).offset(10);
        make.width.mas_equalTo(@80);
        make.bottom.equalTo(self.recordView.mas_bottom).offset(-10);
        make.height.mas_equalTo(@40);
    }];
    [recordScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.recordView);
        make.width.mas_equalTo(@80);
        make.bottom.equalTo(screenShotBtn.mas_bottom);
        make.height.equalTo(screenShotBtn.mas_height);
    }];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        
        make.width.mas_equalTo(@80);
        make.bottom.equalTo(screenShotBtn.mas_bottom);
        make.height.equalTo(screenShotBtn.mas_height);
    }];
    
    self.recordView.alpha = 0;
#pragma 底部视图
    
    self.bottomView = [[UIView alloc]init];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    //美颜按钮
    
    UIButton* skinCareBtn = [[UIButton alloc]initButtonWithTitle:@"美颜" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
//        NSLog(@"%@",@"美颜");
//        self.skinCareView = [[KSYSecondView alloc]init];
//        self.skinCareView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.2];
//        NSArray* titleArray = @[@"美颜",@"滤镜",@"贴纸"];
//        
//        [self.skinCareView setUpSubView:titleArray viewHeight:210];
//        
//        self.skinCareView.voiceArray =  [[NSArray alloc]initWithObjects:@"无",@"粉嫩",@"自然",@"白皙",nil];
//        self.skinCareView.pictureArray =  [[NSArray alloc]initWithObjects:@"ksy_media_edit_record_beauty_origin",@"ksy_media_edit_record_beauty_NaturalFitler_fennen",@"ksy_media_edit_record_beauty_ExtTilter_ziran",@"ksy_media_edit_record_beauty_ProFitler_baixi",nil];
//        [self.skinCareView showSecondView];
//        //隐藏底部视图
//        self.bottomView.alpha = 0;
        
    }];
    [self.bottomView addSubview:skinCareBtn];
    
    //摄像头切换
    UIButton* caremaBtn = [[UIButton alloc]initButtonWithTitle:@"摄像头切换" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
        NSLog(@"摄像头切换");
       // [_wxStreamerKit switchCamera];
        
    }];
    [self.bottomView addSubview:caremaBtn];
    
    //录屏
    UIButton* recordBtn = [[UIButton alloc]initButtonWithTitle:@"录屏/截屏" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
        NSLog(@"录屏");
        //隐藏底部的视图和顶部的视图  显示录屏界面
        self.bottomView.alpha = 0;
        self.topView.alpha = 0;
        self.recordView.alpha = 1;
    }];
    [self.bottomView addSubview:recordBtn];
    
    float buttonWidth = (KSYScreenWidth-20)/4;
    //功能
    UIButton* funcButton =[[UIButton alloc]initButtonWithTitle:@"功能" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
        NSLog(@"功能");
        //隐藏  底部按钮
        self.bottomView.alpha = 0;
        //镜像状态
        self.mirrorState = NO;
        //静音状态
        self.muteState = NO;
        self.collectView = [[KSYCustomCollectView alloc]init];
        self.collectView.titleBlock = ^(NSString *title) {
            if ([title isEqualToString:@"镜像"]) {
                selfWeak.mirrorState = !selfWeak.mirrorState;
              //  selfWeak.wxStreamerKit.streamerMirrored = selfWeak.mirrorState;
            }
            else if ([title isEqualToString:@"闪光灯"]){
               // [selfWeak.wxStreamerKit toggleTorch];
            }
            else if([title isEqualToString:@"静音"]){
                selfWeak.muteState = !selfWeak.muteState;
                [selfWeak.wxStreamerKit.streamerBase muteStream:selfWeak.muteState];
            }
            else if ([title isEqualToString:@"背景图"]){
                // [selfWeak ]
            }
        };
        
        self.collectView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.2];
        [self.collectView showView];
    }];
    [self.bottomView addSubview:funcButton];
    
    //布局代码
    [skinCareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(5);
        make.bottom.equalTo(self.bottomView).offset(-10);
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(@40);
    }];
    [caremaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(skinCareBtn.mas_right).offset(5);
        make.width.mas_equalTo(buttonWidth);
        make.bottom.equalTo(skinCareBtn.mas_bottom);
        make.height.equalTo(skinCareBtn.mas_height);
    }];
    [recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(caremaBtn.mas_right).offset(5);
        
        make.width.mas_equalTo(buttonWidth);
        make.bottom.equalTo(skinCareBtn.mas_bottom);
        make.height.equalTo(skinCareBtn.mas_height);
    }];
    [funcButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-5);
        
        make.width.mas_equalTo(buttonWidth);
        make.bottom.equalTo(skinCareBtn.mas_bottom);
        make.height.equalTo(skinCareBtn.mas_height);
    }];
    
}

#pragma mark - 选择图片
-(void)selectPictureToView{
    UIImagePickerController* picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //原始图片
   UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

    if (_wxStreamerKit.bgPic) {
        [_wxStreamerKit.bgPic removeAllTargets];
        _wxStreamerKit.bgPic = nil;
    }
    //设置输出图像的像素格式
    _wxStreamerKit.bgPic = [[GPUImagePicture alloc]initWithImage:image];
    _wxStreamerKit.gpuOutputPixelFormat = kCVPixelFormatType_32BGRA;
    //校正图片朝向
    _wxStreamerKit.bgPicRotate = [[_wxStreamerKit class] getRotationMode:image];
    if (image.imageOrientation == UIImageOrientationLeft || image.imageOrientation == UIImageOrientationRight){
        _wxStreamerKit.previewDimension = CGSizeMake(_wxStreamerKit.bgPic.outputImageSize.height, _wxStreamerKit.bgPic.outputImageSize.width);
    }else{
        _wxStreamerKit.previewDimension = _wxStreamerKit.bgPic.outputImageSize;
    }
    //推流过程中切换图片

    //开始预览（启动推流前必须开始预览）
    [_wxStreamerKit startPreview:self.view];

    //开启视频配置和采集
    [_wxStreamerKit startVideoCap];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 点击当前view视图的touch事件
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //判断当前视图是不是录屏视图
    if (self.recordView.alpha == 1) {
        
    }
    else{
        [self.collectView removeFromSuperview];
        [self.skinCareView removeFromSuperview];
        self.bottomView.alpha = 1;
        self.recordView.alpha = 0;
        self.topView.alpha = 1;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

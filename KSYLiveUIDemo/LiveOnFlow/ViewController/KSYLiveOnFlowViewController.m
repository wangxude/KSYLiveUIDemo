//
//  KSYLiveOnFlowViewController.m
//  KSYLiveUIDemo
//
//  Created by 王旭 on 2017/11/6.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import "KSYLiveOnFlowViewController.h"

#import "ViewController.h"
//下拉列表
#import "KSYDropDownMenu.h"
//扫描二维码
#import "KSYQRViewController.h"
//推流设置界面
#import "KSYParameterSettingVC.h"

//推流功能界面
#import "KSYUIStreamerVC.h"
@interface KSYLiveOnFlowViewController ()<KSYDropDownMenuDelegate>

@property(nonatomic,strong) KSYDropDownMenu* dropDownMenu;

@end

@implementation KSYLiveOnFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置背景图片
   self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"u11.jpg"]];
    
    [self setUpChildView];
    
   
   
}

/**
 布局子控件
 */
-(void)setUpChildView{
    
    UIBarButtonItem* fixButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixButtonItem.width = 10;
    
    UIBarButtonItem* scanButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"scan" frame:KSYScreen_Frame(0, 0, 30, 30) target:self action:@selector(scanQRCodeAction:)];

    UIBarButtonItem* settingButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"setting" frame:KSYScreen_Frame(0, 0, 30, 30) target:self action:@selector(jumpSetting)];
    self.navigationItem.rightBarButtonItems = @[settingButtonItem,fixButtonItem,scanButtonItem];
    //设置导航栏的按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigationbar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(close)];
    
    self.dropDownMenu= [[KSYDropDownMenu alloc]initWithFrame:KSYScreen_Frame(20, 350, 110, 40)];
    NSArray* titleArray = @[@"普通直播",@"画中画直播",@"涂鸦直播",@"背景图直播"];
    [self.dropDownMenu setMenuTitles:titleArray rowHeight:40];
    self.dropDownMenu.delegate = self;
    [self.view addSubview:self.dropDownMenu];
    
    UIButton * beginLiveBtn = [UIButton buttonWithTitle:LocalString(@"Begin_Live") titleColor:[UIColor whiteColor] font:KSYUIFont(15) backGroundColor:KSYRGB(236, 69, 84) target:self action:@selector(beginLiveToEvent) backImageName:nil];
    [self.view addSubview:beginLiveBtn];
    
//    [self.dropDownMenu mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).offset(50);
//        make.bottom.equalTo(self.view).offset(-100);
//    }];
    
    [beginLiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-30);
        make.top.equalTo(self.dropDownMenu.mas_top);
        make.left.equalTo(self.dropDownMenu.mas_right).offset(30);
        make.height.equalTo(self.dropDownMenu.mas_height);
    }];
}

/**
 开始直播
 */
-(void)beginLiveToEvent{
    NSString * uuidStr =[[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *devCode  = [[uuidStr substringToIndex:3] lowercaseString];
    NSLog(@"%@",devCode);
    //推流地址
    NSString *streamSrv  = @"rtmp://test.uplive.ks-cdn.com/live";
    NSString *streamUrl      = [ NSString stringWithFormat:@"%@/%@", streamSrv, devCode];
    NSURL* rtmpUrl = [NSURL URLWithString:streamUrl];
    KSYUIStreamerVC* vc =  [[KSYUIStreamerVC alloc] initWithUrl:rtmpUrl];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}
// 关闭
- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 扫描二维码

 @param sender 按钮
 */
-(void)scanQRCodeAction:(UIButton*)sender{
    __weak __typeof(self)wself = self;
    KSYQRViewController *QRview = [[KSYQRViewController alloc]init];
    QRview.getQrCode = ^(NSString *stringQR){
        //扫描完成后显示地址
        NSString *QRUrl = stringQR;
        //得到二维码扫描的地址添加到播放地址的数组中
        //        if (_type == KSYDemoMenuType_PLAY) {
        ////            [_arrayPlayAddress insertObject:QRUrl atIndex:0];
        ////            _currentSelectUrl = _arrayPlayAddress[0];
        //        }else if(_type == KSYDemoMenuType_STREAM){
        ////            [_arrayStreamAddress insertObject:QRUrl atIndex:0];
        ////            _currentSelectUrl = _arrayStreamAddress[0];
        //        }else if(_type == KSYDemoMenuType_RECORD){
        ////            [_arrayRecordFileName insertObject:QRUrl atIndex:0];
        ////            _currentSelectUrl = _arrayRecordFileName[0];
        //        }
        
        [wself dismissViewControllerAnimated:FALSE completion:nil];
    };
    [self presentViewController:QRview animated:YES completion:nil];
}

/**
 设置界面
 */
-(void)jumpSetting{
    KSYParameterSettingVC* settingVC = [[KSYParameterSettingVC alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
}
#pragma mark - KSYDropDownMenu delegate

-(void)dropDownMenu:(KSYDropDownMenu *)menu selectedCellNumber:(NSInteger)number{
     NSLog(@"你选择了：%ld",number);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //点击视图空白处 ,隐藏下拉列表
    [self.dropDownMenu hideDropDown];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

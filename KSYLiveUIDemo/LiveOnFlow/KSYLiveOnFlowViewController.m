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
    
//    UIButton* button = [[UIButton alloc]init];
//    button.frame = CGRectMake(0, 100, 100, 100);
//    [button setTitle:@"跳转" forState: UIControlStateNormal];
//    [button setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(qqq) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    
   
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
    
    self.dropDownMenu= [[KSYDropDownMenu alloc]initWithFrame:KSYScreen_Frame(20, 350, 100, 40)];
    NSArray* titleArray = @[@"横屏推流",@"竖屏推流"];
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
    
}

/**
 设置界面
 */
-(void)jumpSetting{
    
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

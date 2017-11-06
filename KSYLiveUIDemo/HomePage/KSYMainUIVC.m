//
//  KSYMainUIVC.m
//  KSYLiveUIDemo
//
//  Created by 王旭 on 2017/11/3.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import "KSYMainUIVC.h"
//自定义label
#import "KSYCustomLabel.h"

#import "KSYTabBarViewController.h"
@interface KSYMainUIVC ()

@end

@implementation KSYMainUIVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpChildView];
    // Do any additional setup after loading the view.
}

-(void)setUpChildView{
    
    KSYCustomLabel* sdkLabel = [KSYCustomLabel labelWithText:LocalString(@"Live_BroadCast_SDK") textColor:KSYRGB(121, 121, 121) font:KSYUIFont(20) textAlignment:NSTextAlignmentCenter backgroundColor:nil];
    [self.view addSubview:sdkLabel];
    
    KSYCustomLabel* serviceLabel = [KSYCustomLabel labelWithText:LocalString(@"Provides_Services") textColor:KSYRGB(121, 121, 121) font:KSYUIFont(15) textAlignment:NSTextAlignmentCenter backgroundColor:nil];
    [self.view addSubview:serviceLabel];
    
    UIButton* liveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [liveButton setTitle:LocalString(@"Open_A_Live") forState:UIControlStateNormal];
    [liveButton setBackgroundColor:KSYRGB(236, 69, 84)];
    [liveButton addTarget:self action:@selector(beginLiveToEvent) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:liveButton];
    
     KSYCustomLabel* versionLabel = [KSYCustomLabel labelWithText:LocalString(@"SDK_Version") textColor:KSYRGB(121, 121, 121) font:KSYUIFont(14) textAlignment:NSTextAlignmentCenter backgroundColor:nil];
    [self.view addSubview:versionLabel];
    
     KSYCustomLabel* companyNameLabel = [KSYCustomLabel labelWithText:LocalString(@"Company_Name") textColor:KSYRGB(121, 121, 121) font:KSYUIFont(15) textAlignment:NSTextAlignmentCenter backgroundColor:nil];
    [self.view addSubview:companyNameLabel];
    
    [sdkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(200);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200,50));
    }];
    
    [serviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sdkLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(250,40));
        
    }];
    
    [companyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(-20);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
    
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.bottom.mas_equalTo(companyNameLabel.mas_top).offset(-50);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
    
    [liveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(versionLabel.mas_top).offset(-10);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)beginLiveToEvent{
    
    KSYTabBarViewController* tabBarVC = [[KSYTabBarViewController alloc]init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVC;
    
    self.navigationController.navigationBarHidden = NO;
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

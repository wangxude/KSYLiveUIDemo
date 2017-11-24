//
//  KSYUIWindowVC.m
//  KSYLiveUIDemo
//
//  Created by 王旭 on 2017/11/23.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import "KSYUIWindowVC.h"

@interface KSYUIWindowVC ()

@property KSYGPUView * preView;

@property CGPoint loc_in;

@end

@implementation KSYUIWindowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor redColor];
    //初始化视图
    _preView = [[KSYGPUView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_preView addGestureRecognizer:panGes];
    
    [self.view addSubview:_preView];
    
    
    UIButton* closeBtn = [[UIButton alloc]initButtonWithTitle:@"" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
        NSLog(@"%@",@"关闭");
        [_streamerVC.wxStreamerKit.vPreviewMixer removeTarget:_preView];
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
    }];
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.view addSubview:closeBtn];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.view).offset(64);
        make.width.mas_equalTo(@40);
        make.height.mas_equalTo(@40);
    }];

    // Do any additional setup after loading the view.
}
//添加
- (void)pan:(UIPanGestureRecognizer *)ges{
    CGPoint loc = [ges locationInView:self.view];
    if (ges.state == UIGestureRecognizerStateBegan) {
        _loc_in = [ges locationInView:_preView];
    }
    
    // 坐标矫正，避免画面超出屏幕
    CGFloat x;
    CGFloat y;
    if (_preView.frame.size.width - _loc_in.x + loc.x >= self.view.frame.size.width){
        x = self.view.frame.size.width - _preView.frame.size.width * 0.5;
    }else if (loc.x - _loc_in.x <= 0) {
        x = _preView.frame.size.width * 0.5;
    }else {
        x = _preView.frame.size.width * 0.5 - _loc_in.x + loc.x;
    }
    
    if (_preView.frame.size.height - _loc_in.y + loc.y >= self.view.frame.size.height) {
        y = self.view.frame.size.height - _preView.frame.size.height * 0.5;
    }else if (loc.y - _loc_in.y <= 0){
        y = _preView.frame.size.height * 0.5;
    }else {
        y = _preView.frame.size.height * 0.5 - _loc_in.y + loc.y;
    }
    
    [UIView animateWithDuration:0 animations:^{
        _preView.center = CGPointMake(x, y);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    if (_streamerVC) {
        [_streamerVC.wxStreamerKit.vPreviewMixer addTarget: _preView];
        // 有横竖屏切换的，需要对预览视图混合器的所有targets的transform进行设置
        _preView.transform = _streamerVC.wxStreamerKit.preview.superview.transform;
    }
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

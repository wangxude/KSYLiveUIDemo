//
//  KSYLiveOnFlowViewController.m
//  KSYLiveUIDemo
//
//  Created by 王旭 on 2017/11/6.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import "KSYLiveOnFlowViewController.h"

#import "ViewController.h"

@interface KSYLiveOnFlowViewController ()

@end

@implementation KSYLiveOnFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor purpleColor];
   
    //设置导航栏的按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigationbar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(close)];
    
    UIButton* button = [[UIButton alloc]init];
    button.frame = CGRectMake(0, 100, 100, 100);
    [button setTitle:@"跳转" forState: UIControlStateNormal];
    [button setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(qqq) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
// 关闭
- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)qqq{
    ViewController * vc = [[ViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
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

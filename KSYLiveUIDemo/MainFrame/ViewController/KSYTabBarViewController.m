//
//  KSYTabBarViewController.m
//  KSYLiveUIDemo
//
//  Created by 王旭 on 2017/11/3.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import "KSYTabBarViewController.h"

#import "UIImage+image.h"
#import "WXCustomTabBar.h"
#import "UIView+Extension.h"
#import "KSYLiveListViewController.h"
#import "KSYLiveOnFlowViewController.h"
#import "KSYDemandListViewController.h"
#import "KSYNavigationViewController.h"

#import "VideoListShowController.h"

@interface KSYTabBarViewController (){
       WXCustomTabBar* tabBar;
}
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation KSYTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置TabBar的属性
    [self setUpTabBarItemAttr];
    
    
    // Do any additional setup after loading the view.
    
    //self.view.backgroundColor=[UIColor redColor];
    
    
    [self setUpChildViewController];
    
    [self setUpTabBar];
    
}
- (void)setUpTabBarItemAttr
{  //设置tabbar的颜色
    [[UITabBar appearance]setBackgroundColor:[UIColor whiteColor]];
    [UITabBar appearance].translucent = NO;
    
    UITabBarItem *item = [UITabBarItem appearance];
    
    // UIControlStateNormal状态下的属性
    NSMutableDictionary *normalAttr = [NSMutableDictionary dictionary];
    // 设置字体颜色
    normalAttr[NSForegroundColorAttributeName] = [UIColor grayColor];
    // 设置字体大小
    normalAttr[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    
    // UIControlStateSelected状态下的属性
    NSMutableDictionary *selectAttr = [NSMutableDictionary dictionary];
    selectAttr[NSForegroundColorAttributeName] = [UIColor colorWithRed:240/255.0 green:156/255.0 blue:30/255.0 alpha:1];
    
    [item setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectAttr forState:UIControlStateSelected];
}

//设置自控制器
-(void)setUpChildViewController{
    
    VideoListShowController * listVC = [[VideoListShowController alloc]init];
    listVC.showType = VideoListShowTypeLive;
     [self setUpOneChildViewController:listVC image:[UIImage imageNamed:@"tabBar_icon_schedule_default"] selectedImage:[UIImage imageWithOriginalName:@"tabBar_icon_schedule"] title:@"直播"];
    
    KSYDemandListViewController* demandVC = [[KSYDemandListViewController alloc]init];
    demandVC.ksyShowType = VideoListShowTypeVod;
    [self setUpOneChildViewController:demandVC image:[UIImage imageNamed:@"tabBar_icon_contrast_default"] selectedImage:[UIImage imageWithOriginalName:@"tabBar_icon_contrast"] title:@"点播"];
    
   
    
}
- (void)setUpTabBar
{
    [self setValue:[[WXCustomTabBar alloc] init] forKeyPath:@"tabBar"];
    
}


-(void)setUpOneChildViewController:(UIViewController *)VC image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title{
    
    VC.title = title;
    
    VC.tabBarItem.image = image;
    
    VC.tabBarItem.selectedImage = selectedImage;
    
    
    // 保存tabBarItem模型到数组
    [self.items addObject:VC.tabBarItem];
    KSYNavigationViewController  *nav = [[KSYNavigationViewController alloc] initWithRootViewController:VC];
    [self addChildViewController:nav];
    
    
}
#pragma mark - 当点击tabBar上的按钮调用
//- (void)tabBar:(AXHTabBar *)tabBar didClickButton:(NSInteger)index
//{
//    self.selectedIndex = index;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tabBarDidClickPlusButton:(WXCustomTabBar *)tabBar{
    NSLog(@"点击");
    
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

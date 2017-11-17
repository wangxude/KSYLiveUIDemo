//
//  KSYToolTipsView.m
//  KSYLiveUIDemo
//
//  Created by 王旭 on 2017/11/16.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import "KSYToolTipsView.h"
#import "UIView+Extension.h"

// 为防止将手机存储写满,限制录像时长为30s
#define REC_MAX_TIME 30 //录制视频的最大时间，单位s


@interface KSYToolTipsView(){
    
    int second; //推流的时间
}
//定时器  从00：00开始计时
@property(nonatomic,strong)NSTimer* timer;

@end

@implementation KSYToolTipsView

+(instancetype)shareInstance
{
    static KSYToolTipsView *stateView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stateView = [[KSYToolTipsView alloc]init];
    });
    return stateView;
}
//2.初始化UIWindow
-(instancetype)init
{
    self = [super init];
//    id <UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
//    if ([delegate respondsToSelector:@selector(window)])
//    {
//        self.window = [delegate performSelector:@selector(window)];
//    }
//    else
//    {
//        self.window = [[UIApplication sharedApplication] keyWindow];
//    }
    [self createUI];
    return self;
    
}

//3.创建UILabel,使label唯一
-(void)createUI
{
    if (self.label == nil)
    {
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, -64, KSYScreenWidth, 64)];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.textColor = [UIColor whiteColor];
        self.label.backgroundColor = KSYRGB(138, 138, 138);
        self.label.font = [UIFont systemFontOfSize:17];
        self.label.alpha = 0.f;
    }
    if (self.flashImageView == nil ) {
        self.flashImageView = [[UIImageView alloc]initWithFrame:KSYScreen_Frame(KSYScreenWidth/2-50, 20, 20, 20)];
        self.flashImageView.image = [UIImage imageNamed:@"小红点"];
        self.flashImageView.alpha = 0;
    }
    if (self.label.superview == nil)
    {
        UIWindow*  window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:self.label];
        [self.label addSubview: self.flashImageView];
    }
}

//4.将文字显示在Label上,并且从上面自动下拉,隔段时间(自己设定)在弹回去
-(void)show
{
    if (!self.label.alpha)
    {
        self.label.alpha = 1.f;
        CGRect rect = self.label.frame;
        rect.origin.y = 0;
        [UIView animateWithDuration:0.1 animations:^{
            self.label.frame = rect;
        } completion:^(BOOL finished) {
            CGRect rect = self.label.frame;
            rect.origin.y = -64;
            [UIView animateWithDuration:0.1 delay:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.label.frame = rect;
            } completion:^(BOOL finished) {
                self.label.alpha = 0.f;
            }];
        }];
    }
}

-(void)showLabelLongTime{
    
    if (!self.label.alpha)
    {
        //头部提示框
        self.label.alpha = 1.f;
        CGRect rect = self.label.frame;
        rect.origin.y = 0;
        //闪光灯
        self.flashImageView.alpha = 1;
        //开启定时器
        second = 0;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countUpTime) userInfo:nil repeats:YES];
        //呼吸动画
        CABasicAnimation *animation =[CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.fromValue = [NSNumber numberWithFloat:1.0f];
        animation.toValue = [NSNumber numberWithFloat:0.0f];
        animation.autoreverses = YES;    //回退动画（动画可逆，即循环）
        animation.duration = 1.0f;
        animation.repeatCount = MAXFLOAT;
        animation.removedOnCompletion = NO;
        animation.speed = 2;
        animation.fillMode = kCAFillModeForwards;//removedOnCompletion,fillMode配合使用保持动画完成效果
        animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [self.flashImageView.layer addAnimation:animation forKey:@"aAlpha"];
       
       
        
        [UIView animateWithDuration:0.01 animations:^{
            self.label.frame = rect;
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void)showLabelWithString:(NSString *)string
{
    self.label.text = string;
    [self show];
}

-(void)showLabelLongTime:(NSString *)string{
    self.label.text = string;
    [self showLabelLongTime];
}

/**
 计时器自增
 */
-(void)countUpTime{
    second ++ ;
    if (second>0&&second<=30) {
       // dispatch_async(dispatch_get_main_queue(), ^{
           [self.label setText:[NSString stringWithFormat:@"00:%02d",second]];
        // });
    }
    else{
        [self stopTimer];
    }
}

-(void)stopTimer{
    //移除动画
    [self.flashImageView.layer removeAnimationForKey:@"aAlpha"];
    //定时器失效
    [self.timer invalidate];
   
    [self.label setText:@"视频已保存至手机"];
        //隐藏顶部视图
    CGRect rect = self.label.frame;
    rect.origin.y = -64;
    [UIView animateWithDuration:0.5 animations:^{
        self.label.frame = rect;
        self.label.alpha = 0.f;
        
    }];
}
//移除视图
-(void)removeSubView{
    [self.label removeFromSuperview];
    [self.timer invalidate];
}

@end

//
//  KSYToolTipsView.h
//  KSYLiveUIDemo
//
//  Created by 王旭 on 2017/11/16.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSYToolTipsView : NSObject


//+(instancetype)shareInstance;

//@property(nonatomic,strong)UIWindow* window;
//提示条的label
@property(nonatomic,strong)UILabel* label;
//闪动imageView
@property(nonatomic,strong)UIImageView* flashImageView;
//图片调用方法
-(void)showLabelWithString:(NSString *)string;
//录制视频调用的方法
-(void)showLabelLongTime:(NSString *)string;
//停止计时器
-(void)stopTimer;

-(void)removeSubView;

@end

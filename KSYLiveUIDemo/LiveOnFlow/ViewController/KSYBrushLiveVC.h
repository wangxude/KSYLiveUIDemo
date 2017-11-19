//
//  KSYBrushLiveVC.h
//  KSYLiveUIDemo
//
//  Created by 王旭 on 2017/11/19.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import "KSYUIBaseViewController.h"


typedef void(^buttonBlock)(UIButton* sender);

#import <libksygpulive/KSYGPUBrushStreamerKit.h>

@interface KSYBrushLiveVC : KSYUIBaseViewController
//推流工具类
@property(nonatomic,strong)KSYGPUBrushStreamerKit* wxStreamerKit;


//当前滤镜
@property(nonatomic,strong)GPUImageOutput<GPUImageInput>* currentFilter;
//初始化推流地址
-(id)initWithUrl:(NSURL*)rtmpUrl;

@end

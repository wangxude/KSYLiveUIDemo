//
//  KSYBackgroundPushVC.h
//  KSYLiveUIDemo
//
//  Created by 王旭 on 2017/11/17.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import "KSYUIBaseViewController.h"


typedef void(^buttonBlock)(UIButton* sender);

#import <libksygpulive/KSYGPUBgpStreamerKit.h>

@interface KSYBackgroundPushVC : KSYUIBaseViewController
//推流工具类
@property(nonatomic,strong)KSYGPUBgpStreamerKit* wxStreamerKit;

//当前滤镜
@property(nonatomic,strong)GPUImageOutput<GPUImageInput>* currentFilter;

@end

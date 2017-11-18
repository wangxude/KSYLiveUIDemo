//
//  KSYUIStreamerVC.h
//  KSYLiveUIDemo
//
//  Created by 王旭 on 2017/11/9.
//  Copyright © 2017年 王旭. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "KSYUIBaseViewController.h"
typedef void(^buttonBlock)(UIButton* sender);

#import <libksygpulive/KSYGPUStreamerKit.h>
#import <libksygpulive/KSYGPUBrushStreamerKit.h>

@interface KSYUIStreamerVC : KSYUIBaseViewController
//推流工具类
@property(nonatomic,strong)KSYGPUStreamerKit* wxStreamerKit;


//当前滤镜
@property(nonatomic,strong)GPUImageOutput<GPUImageInput>* currentFilter;
//初始化推流地址
-(id)initWithUrl:(NSURL*)rtmpUrl;

@property(nonatomic,copy)NSString* pushTypeTitle;




@end

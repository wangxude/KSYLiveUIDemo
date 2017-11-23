//
//  KSYPictureInPictureVC.h
//  KSYLiveUIDemo
//
//  Created by 王旭 on 2017/11/19.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import "KSYUIBaseViewController.h"

typedef void(^buttonBlock)(UIButton* sender);

#import <libksygpulive/KSYGPUPipStreamerKit.h>

@interface KSYPictureInPictureVC : KSYUIBaseViewController
//推流工具类
@property(nonatomic,strong)KSYGPUPipStreamerKit* wxStreamerKit;

//当前滤镜
@property(nonatomic,strong)GPUImageOutput<GPUImageInput>* currentFilter;


@end

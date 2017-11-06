//
//  KSYTabBarButton.m
//  KSYLiveUIDemo
//
//  Created by 王旭 on 2017/11/6.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import "KSYTabBarButton.h"

@implementation KSYTabBarButton

#pragma mark 返回按钮内部titlelabel的边框
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 0, contentRect.size.width, contentRect.size.height);
}

#pragma mark 返回按钮内部UIImage的边框
-(CGRect) imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 0, 0,0);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

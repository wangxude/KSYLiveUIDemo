//
//  KSYSliderView.m
//  KSYLiveUIDemo
//
//  Created by 王旭 on 2017/11/20.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import "KSYSliderView.h"

@implementation KSYSliderView

//-(KSYSliderView*)initWithFrame:(CGRect)frame leftTitle:(NSString*)title rightTitle:(NSInteger)number{
//    
//    UISlider* slider = [[UISlider alloc]initWithFrame: KSYScreen_Frame((KSYViewFrame_Size_Width(self)-100)/2, 0, 100, KSYViewFrame_Size_Height(self))];
//    //设置最小值和最大值
//    slider.minimumValue = 0;
//    slider.maximumValue = number;
//    
//    slider.value = (slider.minimumValue + slider.maximumValue)/2;
//    ;
////    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake((SCREENWIDTH - 150) / 2, 0, , 20)];
////    slider.minimumValue = 0;// 设置最小值
////    slider.maximumValue = 100;// 设置最大值
////    slider.value = (slider.minimumValue + slider.maximumValue) / 2;// 设置初始值
////    slider.continuous = YES;// 设置可连续变化
////    slider.tintColor = [UIColor purpleColor];
//////    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
////    [self.view addSubview:slider];
////
////    // 当前值label
////    self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREENWIDTH - 100) / 2, slider.frame.origin.y + 30, 100, 20)];
////    self.valueLabel.textAlignment = NSTextAlignmentCenter;
////    self.valueLabel.text = [NSString stringWithFormat:@"%.1f", slider.value];
////    [self.view addSubview:self.valueLabel];
////
////    // 最小值label
////    UILabel *minLabel = [[UILabel alloc] initWithFrame:CGRectMake(slider.frame.origin.x - 35, slider.frame.origin.y, 30, 20)];
////    minLabel.textAlignment = NSTextAlignmentRight;
////    //    minLabel.text = [NSString stringWithFormat:@"%.1f", slider.minimumValue];
////    minLabel.text = @"音量";
////    minLabel.font = [UIFont systemFontOfSize:13];
////    [self.view addSubview:minLabel];
////
////    // 最大值label
////    UILabel *maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(slider.frame.origin.x + slider.frame.size.width + 5, slider.frame.origin.y, 30, 20)];
////    maxLabel.textAlignment = NSTextAlignmentLeft;
////    maxLabel.text = [NSString stringWithFormat:@"%.1f", slider.maximumValue];
////    [self.view addSubview:maxLabel];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

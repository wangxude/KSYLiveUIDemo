//
//  KSYSliderView.m
//  KSYLiveUIDemo
//
//  Created by 王旭 on 2017/11/20.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import "KSYSliderView.h"

@implementation KSYSliderView

-(instancetype)initWithFrame:(CGRect)frame leftTitle:(NSString*)title rightTitle:(NSInteger)number minimumValue:(float)minValue maxValue:(float)maxValue{
    if (self = [super initWithFrame:frame]) {
        UISlider* slider = [[UISlider alloc]initWithFrame: KSYScreen_Frame((KSYViewFrame_Size_Width(self)-100)/2, 0, 100, KSYViewFrame_Size_Height(self))];
        //设置最小值和最大值
        slider.minimumValue = minValue;
        slider.maximumValue = number;
        
        slider.value = (slider.minimumValue + slider.maximumValue)/2;
        ;
        [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:slider];
        self.sldier = slider;
        
        // 最小值label
        UILabel *minLabel = [[UILabel alloc] initWithFrame:CGRectMake(slider.frame.origin.x - 55, slider.frame.origin.y, 50, 20)];
        minLabel.textAlignment = NSTextAlignmentRight;
        //    minLabel.text = [NSString stringWithFormat:@"%.1f", slider.minimumValue];
        minLabel.text = title;
        minLabel.textColor = [UIColor whiteColor];
        minLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:minLabel];
        
        // 最大值label
        UILabel *maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(slider.frame.origin.x + slider.frame.size.width + 5, slider.frame.origin.y, 50, 20)];
        maxLabel.textAlignment = NSTextAlignmentLeft;
        maxLabel.text = [NSString stringWithFormat:@"%.1f", slider.value];
        maxLabel.textColor = [UIColor whiteColor];
        [self addSubview:maxLabel];
        self.rightLabel = maxLabel;
    }
 
    
    return self;
}

// slider变动时改变label值
- (void)sliderValueChanged:(UISlider *)sender {
//    UISlider *slider = (UISlider *)sender;
    self.rightLabel.text = [NSString stringWithFormat:@"%.1f",sender.value];
    if (self.sliderBlockEvent) {
        self.sliderBlockEvent(sender);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

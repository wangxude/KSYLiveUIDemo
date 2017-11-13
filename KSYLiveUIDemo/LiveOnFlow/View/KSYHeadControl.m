//
//  KSYHeadControl.m
//  KSYLiveUIDemo
//
//  Created by 王旭 on 2017/11/13.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import "KSYHeadControl.h"

@interface KSYHeadControl()

@property(nonatomic,strong)UIButton* headIconBtn;

@property(nonatomic,strong)UILabel* textLabel;

@end

@implementation KSYHeadControl

-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}


-(void)layoutSubviews{
  
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,KSYViewFrame_Size_Width(self), KSYViewFrame_Size_Height(self))];
    textLabel.numberOfLines = 0;
    textLabel.layer.cornerRadius = KSYViewFrame_Size_Height(self)/2;
    textLabel.layer.masksToBounds = YES;
    textLabel.backgroundColor = KSYRGB(178, 178, 178);
    //    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20],};
   
    //    CGSize textSize = [str boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;;
    //    [textLabel setFrame:CGRectMake(100, 100, textSize.width, textSize.height)];
    textLabel.text = [NSString stringWithFormat:@"          %@",@"text111"];
    [self addSubview:textLabel];
    
    UIButton* headIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headIconButton.frame = CGRectMake(0, 0, KSYViewFrame_Size_Height(self), KSYViewFrame_Size_Height(self));
    headIconButton.layer.cornerRadius = KSYViewFrame_Size_Height(self)/2;
    headIconButton.layer.masksToBounds = YES;
    [headIconButton setImage:[UIImage imageNamed:@"头像.jpg"] forState: UIControlStateNormal];
    [self addSubview:headIconButton];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

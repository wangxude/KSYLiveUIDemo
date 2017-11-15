//
//  KSYCustomCollectView.m
//  KSYLiveUIDemo
//
//  Created by 王旭 on 2017/11/13.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import "KSYCustomCollectView.h"
//cell
#import "KSYLabelCollectionViewCell.h"

@interface KSYCustomCollectView (){
    NSArray* titleArray;
}

@end

@implementation KSYCustomCollectView

-(instancetype)init{
    self = [super initWithFrame:CGRectMake(0,KSYScreenHeight-120,KSYScreenWidth , 120)];
    if (self) {
        //添加布局
        [self addCollectView];
    }
    return self;
}


-(void)addCollectView{
    //UIButton
    
    //弱引用
    __weak typeof(self)weakSelf = self;
    
    self.secondView = [[KSYSecondView alloc]init];
    
    self.secondView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.2];
    self.secondView.alpha = 0;
    self.secondView.returnBtnBlock = ^(UIButton *sender) {
        if ([sender.titleLabel.text isEqualToString: @"返回"]) {
            [weakSelf transformDirection:NO withCurrentView:weakSelf.secondView withLastView:weakSelf.scratchableLatexView];
        }
        else{
            [weakSelf dismissWithCurrentView:weakSelf.secondView];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"displayBottomView" object:nil];
        }
    };
    [self addSubview:self.secondView];
    
    [self.secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.width.equalTo(self);
        make.left.equalTo(self);
        make.height.mas_equalTo(@160);
        //[self.scratchableLatexView reloadData];
    }];
    
    titleArray = @[@"镜像",@"闪光灯",@"静音",@"音效",@"背景音乐",@"LOGO",@"画中画",@"画笔/涂鸦",@"背景图"];
    //初始化布局类
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
   // layout.itemSize = CGSizeMake(KSYScreenWidth/3, 40);
    //初始化collectView
    self.scratchableLatexView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout: layout];
    [self.scratchableLatexView registerNib:[UINib nibWithNibName:@"KSYLabelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    self.scratchableLatexView.delegate = self;
    self.scratchableLatexView.dataSource = self;
    [self addSubview:self.scratchableLatexView];
//    self.scratchableLatexView.backgroundColor = KSYRGBAlpha(0.5, 114, 105, 95);
    self.scratchableLatexView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.2];
    //self.scratchableLatexView.opaque = NO;
  
//    //取消按钮
//    UIButton* cancelButton =[[UIButton alloc]initButtonWithTitle:@"关闭" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
//
//        [weakSelf dismissWithCurrentView:self.scratchableLatexView];
//
//    }];
//    [self addSubview:cancelButton];
    
//    //控件布局
//    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.scratchableLatexView.mas_top);
//        make.width.mas_equalTo(@50);
//        make.right.equalTo(self).offset(-10);
//        make.height.mas_equalTo(@40);
//    }];
    
    [self.scratchableLatexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.width.equalTo(self);
        make.left.equalTo(self);
        make.height.mas_equalTo(@120);
        [self.scratchableLatexView reloadData];
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 9;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier = @"cell";
    KSYLabelCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.TextLabel.text = [NSString stringWithFormat:@"%@",titleArray[indexPath.item]];
    cell.TextLabel.textColor = [UIColor whiteColor];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(KSYScreenWidth/3, 40);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"collectionView");
    
   
    //点击切换
    KSYLabelCollectionViewCell* collectCell = (KSYLabelCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    NSString* title = collectCell.TextLabel.text;

   if ([title isEqualToString:@"镜像"]) {
        
    }
   else if ([title isEqualToString:@"闪光灯"]) {
        
    }
   else if ([title isEqualToString:@"静音"]) {
       
   }
   else if ([title isEqualToString:@"音效"]) {
      NSArray* array = @[@"混响",@"变声"];
      [self.secondView setUpSubView:array];
       self.secondView.voiceArray = [[NSArray alloc]initWithObjects:@"无",@"录音棚",@"演唱会",@"KTV",@"小舞台",nil];
       self.secondView.alpha = 1;
       [self transformDirection:YES withCurrentView:self.scratchableLatexView withLastView:self.secondView];
   }
   else if ([title isEqualToString:@"背景音乐"]) {
       NSArray* array = @[@"背景音乐"];
       [self.secondView setUpSubView:array];
       self.secondView.alpha = 1;
       self.secondView.voiceArray = [[NSArray alloc]initWithObjects:@"无",@"music1",@"music2",@"music3",@"music4",nil];
       [self transformDirection:YES withCurrentView:self.scratchableLatexView withLastView:self.secondView];
   }
   else if ([title isEqualToString:@"LOGO"]) {
       NSArray* array = @[@"LOGO"];
       [self.secondView setUpSubView:array];
       self.secondView.voiceArray = [[NSArray alloc]initWithObjects:@"无",@"静态LOGO",@"动态LOGO",nil];
       self.secondView.alpha = 1;
       [self transformDirection:YES withCurrentView:self.scratchableLatexView withLastView:self.secondView];
   }
   else if ([title isEqualToString:@"画中画"]) {
       
   }
   else if ([title isEqualToString:@"背景图"]) {
       
   }
    
}

-(void)showView{
    UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    self.scratchableLatexView.transform = CGAffineTransformMakeScale(1.21, 1.21);
    self.scratchableLatexView.alpha = 0;
//    [UIView animateWithDuration:0.7 animations:^{
//        self.scratchableLatexView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
//        self.scratchableLatexView.alpha = 1.0;
//    }];
    [UIView animateWithDuration:.7f delay:0.f usingSpringWithDamping:.7f initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
       
        self.scratchableLatexView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        self.scratchableLatexView.alpha = 1.0;
    } completion:nil];
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

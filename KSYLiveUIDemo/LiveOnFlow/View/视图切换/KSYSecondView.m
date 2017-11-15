//
//  KSYSecondView.m
//  KSYLiveUIDemo
//
//  Created by 王旭 on 2017/11/14.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import "KSYSecondView.h"

#import "KSYPictureAndLabelCell.h"

#import "KSYSelectBottomButton.h"

@interface KSYSecondView()<KSYSelectBottomButtonDelegate>



@end

@implementation KSYSecondView



-(void)didSelectedBottomButton:(KSYSelectBottomButton *)button groupId:(NSString *)groupId{
    if ([button.titleLabel.text isEqualToString:@"变声"]) {
        self.voiceArray = [[NSArray alloc]initWithObjects:@"无",@"录音棚",@"演唱会",@"KTV",@"小舞台",nil];
        [self.secondCollectView reloadData];
    }
    else if([button.titleLabel.text isEqualToString:@"混响"]){
      self.voiceArray = [[NSArray alloc]initWithObjects:@"无",@"大叔",@"萝莉",@"庄严",@"机器人",nil];
        [self.secondCollectView reloadData];
    }
    else if([button.titleLabel.text isEqualToString:@"背景音乐"]){
        self.voiceArray = [[NSArray alloc]initWithObjects:@"无",@"music1",@"music2",@"music3",@"music4",nil];
        [self.secondCollectView reloadData];
    }
    else if([button.titleLabel.text isEqualToString:@"LOGO"]){
        self.voiceArray = [[NSArray alloc]initWithObjects:@"无",@"静态LOGO",@"动态LOGO",nil];
        [self.secondCollectView reloadData];
    }
    else if([button.titleLabel.text isEqualToString:@"美颜"]){
        self.voiceArray = [[NSArray alloc]initWithObjects:@"无",@"粉嫩",@"natural",@"白皙",nil];
        [self.secondCollectView reloadData];
    }
    else if([button.titleLabel.text isEqualToString:@"滤镜"]){
        self.voiceArray = [[NSArray alloc]initWithObjects:@"无",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",nil];
        [self.secondCollectView reloadData];
    }
    else if([button.titleLabel.text isEqualToString:@"贴纸"]){
        self.voiceArray = [[NSArray alloc]initWithObjects:@"无",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",nil];
        [self.secondCollectView reloadData];
    }
    
}

-(instancetype)init{
    self = [super initWithFrame:CGRectMake(0,KSYScreenHeight-160,KSYScreenWidth , 160)];
    if (self) {
        //默认是变声
       //self.voiceArray = @[@"无",@"录音棚",@"演唱会",@"KTV",@"小舞台"];
    }
    return self;
}
-(void)setUpSubView:(NSArray*)titleArray{
   
    self.bottomButtonView = [[KSYSecondVCBottomView alloc]init];
    [self.bottomButtonView setUpRadioTitleArray:titleArray radioGroupId:@"lujing" delegate:self];

    [self addSubview:self.bottomButtonView];
    
    
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.secondCollectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.secondCollectView registerNib:[UINib nibWithNibName:@"KSYPictureAndLabelCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    //        [self.secondCollectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"footer"];
    self.secondCollectView.delegate = self;
    self.secondCollectView.dataSource = self;
    self.secondCollectView.allowsMultipleSelection = NO;
    [self addSubview:self.secondCollectView];
    //    self.scratchableLatexView.backgroundColor = KSYRGBAlpha(0.5, 114, 105, 95);
    self.secondCollectView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.2];
    
    [self.bottomButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.width.equalTo(self);
        make.left.equalTo(self);
        make.height.mas_equalTo(@40);
        //[self.secondCollectView reloadData];
    }];
    
    [self.secondCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomButtonView.mas_top);
        make.width.equalTo(self);
        make.left.equalTo(self);
        make.height.mas_equalTo(@120);
        [self.secondCollectView reloadData];
    }];
    
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.voiceArray.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier = @"cell";
    KSYPictureAndLabelCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.titleNameLabel.text = self.voiceArray[indexPath.item];

    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.frame.size.width/3,self.frame.size.width/3+10);
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
    KSYPictureAndLabelCell* cell=(KSYPictureAndLabelCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.backGroundImageView.image=[UIImage imageNamed:@"红色图标"];
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    KSYPictureAndLabelCell* cell=(KSYPictureAndLabelCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.backGroundImageView.image=[UIImage imageNamed:@"白色图标"];
}


//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//#warning 如果在storboard中设置了组头或组尾, 必须设置 重用标识符
//    static NSString *headerIdentifier = @"footer";
//   // headerIdentifier = (kind == UICollectionElementKindSectionHeader) ? @"header" : @"footer";
//    UICollectionReusableView *resuableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
//    if (kind == UICollectionElementKindSectionHeader) {
//        resuableView.backgroundColor = [UIColor redColor];
//        resuableView.frame = CGRectMake(0, 0, KSYScreenWidth, 30);
//    }
//    return resuableView;
//}
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
//    return CGSizeMake(KSYScreenWidth, 30);
//}


-(void)showSecondView{
    UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    self.alpha = 1;
    self.transform = CGAffineTransformMakeScale(1.21, 1.21);
   
    //    [UIView animateWithDuration:0.7 animations:^{
    //        self.scratchableLatexView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    //        self.scratchableLatexView.alpha = 1.0;
    //    }];
    [UIView animateWithDuration:.7f delay:0.f usingSpringWithDamping:.7f initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        
    } completion:nil];
}

@end

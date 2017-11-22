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



#import "KSYPictureAndLabelModel.h"

@interface KSYSecondView()<KSYSelectBottomButtonDelegate>

@property(nonatomic,assign)NSInteger selectItemIndex;

@property(nonatomic,strong)NSDictionary* allModelDic;

@property(nonatomic,strong)NSMutableArray* dataArray;

@end

@implementation KSYSecondView

-(NSDictionary*)allModelDic{
    if (!_allModelDic) {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"ArrayResourceList.plist" ofType:nil];
        _allModelDic = [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:path]];
    }
    return _allModelDic;
}



-(void)didSelectedBottomButton:(KSYSelectBottomButton *)button groupId:(NSString *)groupId{
    
     self.selectedTitle = button.titleLabel.text;
    
    //发送隐藏滑块的通知
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",[NSString stringWithFormat:@"%@",self.selectedTitle],nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:KSYSliderHideNotice object:self userInfo:dic];
    
    //选中的cell的索引
    YYCache* cache = [YYCache cacheWithName:@"mydb"];
    KSYPictureAndLabelModel* model = (KSYPictureAndLabelModel*)[cache objectForKey:self.selectedTitle];
    self.selectItemIndex = model.selectIndex;
    
    self.dataArray = [[NSMutableArray alloc]init];
    NSArray* dataArray = [self.allModelDic valueForKey:self.selectedTitle];
    
    [dataArray enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL* stop){
        NSDictionary* dic = obj;
        KSYPictureAndLabelModel* model = [KSYPictureAndLabelModel modelWithDictionary:dic];
        [self.dataArray addObject:model];
    }];
    [self.secondCollectView reloadData];

    
}

-(instancetype)init{
    self = [super initWithFrame:CGRectMake(0,KSYScreenHeight-130,KSYScreenWidth , 130)];
    if (self) {
        
       //self.selectItemIndex = 0;
       //默认是变声
    }
    return self;
}
-(void)setUpSubView:(NSArray*)titleArray viewHeight:(CGFloat)height{
   
    self.bottomButtonView = [[KSYSecondVCBottomView alloc]init];
    [self.bottomButtonView setUpRadioTitleArray:titleArray radioGroupId:@"lujing" delegate:self];
    self.selectedTitle = titleArray[0];

    [self addSubview:self.bottomButtonView];
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.secondCollectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.secondCollectView registerNib:[UINib nibWithNibName:@"KSYPictureAndLabelCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
  
    self.secondCollectView.delegate = self;
    self.secondCollectView.dataSource = self;
    self.secondCollectView.allowsMultipleSelection = NO;
    //选中的cell
    //self.selectItemIndex = 0;
    [self addSubview:self.secondCollectView];
    self.secondCollectView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.2];
    
    [self.bottomButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.width.equalTo(self);
        make.left.equalTo(self);
        make.height.mas_equalTo(@40);
    }];
    
    [self.secondCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomButtonView.mas_top);
        make.width.equalTo(self);
        make.left.equalTo(self);
        make.height.mas_equalTo(@90);
        [self.secondCollectView reloadData];
    }];
    

    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier = @"cell";
    KSYPictureAndLabelCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.model = self.dataArray[indexPath.item];

   if (indexPath.item == self.selectItemIndex){
     
     cell.backGroundImageView.layer.borderColor = [UIColor redColor].CGColor;
     
//     NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)indexPath.item],[NSString stringWithFormat:@"%@",self.selectedTitle],nil];
//     [[NSNotificationCenter defaultCenter]postNotificationName:KYSStreamChangeNotice object:self userInfo:dic];
    }
    else{
        cell.backGroundImageView.layer.borderColor = [UIColor whiteColor].CGColor;
       
    }
  
   
    
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(70,90);
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
    
    self.selectItemIndex = indexPath.item;
    
    KSYPictureAndLabelCell* cell=(KSYPictureAndLabelCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
   cell.backGroundImageView.layer.borderColor = [UIColor redColor].CGColor;
    
   
    YYCache* cache = [YYCache cacheWithName:@"mydb"];
    [cache setObject:self.dataArray[indexPath.item] forKey:self.selectedTitle];
    //发送通知
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)indexPath.item],[NSString stringWithFormat:@"%@",self.selectedTitle],nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:KYSStreamChangeNotice object:self userInfo:dic];
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [collectionView reloadData];
    
}



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

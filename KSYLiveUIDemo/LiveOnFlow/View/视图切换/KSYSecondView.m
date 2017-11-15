//
//  KSYSecondView.m
//  KSYLiveUIDemo
//
//  Created by 王旭 on 2017/11/14.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import "KSYSecondView.h"

#import "KSYPictureAndLabelCell.h"

@interface KSYSecondView()


@end

@implementation KSYSecondView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        UIButton* cancelButton =[[UIButton alloc]initButtonWithTitle:@"关闭" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
//            
//            if (self.returnBtnBlock) {
//                self.returnBtnBlock(sender);
//            }
//          
//        }];
//        cancelButton.frame = CGRectMake(100, 20, 40, 40);
//        [self addSubview:cancelButton];
//        
//        UIButton* returnButton =[[UIButton alloc]initButtonWithTitle:@"返回" titleColor:[UIColor whiteColor] font:KSYUIFont(14) backGroundColor:KSYRGB(112,87,78)  callBack:^(UIButton *sender) {
//            if (self.returnBtnBlock) {
//                self.returnBtnBlock(sender);
//            }
//        }];
//        returnButton.frame = CGRectMake(200, 20,40, 40);
//        [self addSubview:returnButton];
        self.bottomButtonView = [[KSYSecondVCBottomView alloc]init];
        NSArray* titleArray = @[@"美颜"];
        [self.bottomButtonView setUpRadioTitleArray:titleArray radioGroupId:@"lujing" delegate:self];
        //self.bottomButtonView.backgroundColor = [UIColor redColor];
        [self addSubview:self.bottomButtonView];
        
      
        
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.secondCollectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [self.secondCollectView registerNib:[UINib nibWithNibName:@"KSYPictureAndLabelCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
//        [self.secondCollectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"footer"];
        self.secondCollectView.delegate = self;
        self.secondCollectView.dataSource = self;
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
    return self;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 9;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier = @"cell";
    KSYPictureAndLabelCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//    cell.TextLabel.text = [NSString stringWithFormat:@"%@",titleArray[indexPath.item]];
//    cell.TextLabel.textColor = [UIColor whiteColor];
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
    NSLog(@"collectionView");
    
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",)
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

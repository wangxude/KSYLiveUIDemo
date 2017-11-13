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
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        //添加布局
        [self addCollectView];
    }
    return self;
}


-(void)addCollectView{
    
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
    self.scratchableLatexView.backgroundColor = KSYRGBAlpha(0.5, 114, 105, 95);
    //self.scratchableLatexView.opaque = NO;
    
    
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

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
    if (self = [super init]) {
        //添加布局
        [self addCollectView];
    }
    return self;
}

-(void)addCollectView{
    
    titleArray = @[@"镜像",@"闪光灯",@"静音",@"音效",@"背景音乐",@"LOGO",@"画中画",@"画笔/涂鸦",@"背景图"];
    //初始化布局类
    UICollectionViewLayout *layout = [[UICollectionViewLayout alloc]init];
    //初始化collectView
    self.scratchableLatexView = [[UICollectionView alloc]initWithFrame:self.frame collectionViewLayout: layout];
    [self.scratchableLatexView registerNib:[UINib nibWithNibName:@"KSYLabelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    self.scratchableLatexView.delegate = self;
    self.scratchableLatexView.dataSource = self;
    [self addSubview:self.scratchableLatexView];
    
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
    cell.TextLabel = [KSYCustomLabel labelWithText:titleArray[indexPath.item] textColor:KSYRGB(121, 121, 121) font:KSYUIFont(15) textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor whiteColor]];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(KSYScreenWidth/3, 40);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"collectionView");
}

-(void)showView{
    UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

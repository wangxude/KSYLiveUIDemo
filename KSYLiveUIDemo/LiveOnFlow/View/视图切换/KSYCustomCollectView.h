//
//  KSYCustomCollectView.h
//  KSYLiveUIDemo
//
//  Created by 王旭 on 2017/11/13.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import "KSYTransViewAfterView.h"

@interface KSYCustomCollectView : KSYTransViewAfterView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/**
 九宫格view
 */
@property(nonatomic,strong)UICollectionView*  scratchableLatexView;

/**
 展现视图
 */
-(void)showView;

@end

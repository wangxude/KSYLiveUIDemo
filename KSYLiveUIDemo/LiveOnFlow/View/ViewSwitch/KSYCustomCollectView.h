//
//  KSYCustomCollectView.h
//  KSYLiveUIDemo
//
//  Created by 王旭 on 2017/11/13.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import "KSYTransViewAfterView.h"

#import "KSYSecondView.h"

typedef void(^collectViewBlock)(NSString* title);


@interface KSYCustomCollectView : KSYTransViewAfterView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/**
 九宫格view
 */
@property(nonatomic,strong)UICollectionView*  scratchableLatexView;

@property(nonatomic,strong)KSYSecondView* secondView;

/**
 展现视图
 */
-(void)showView;

@property(nonatomic,copy)collectViewBlock titleBlock;

@end

//
//  KSYSecondView.h
//  KSYLiveUIDemo
//
//  Created by 王旭 on 2017/11/14.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSYSecondVCBottomView.h"
//返回
typedef void (^returnBlock) (UIButton* sender);




@interface KSYSecondView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

//返回按钮
@property (nonatomic,copy)returnBlock returnBtnBlock;

//二级视图 
@property(nonatomic,strong)UICollectionView* secondCollectView;
//底部按钮视图
@property(nonatomic,strong)KSYSecondVCBottomView* bottomButtonView;



@end

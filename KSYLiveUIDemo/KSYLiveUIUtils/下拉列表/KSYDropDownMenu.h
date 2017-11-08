//
//  KSYDropDownMenu.h
//  KSYLiveUIDemo
//
//  Created by 王旭 on 2017/11/7.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KSYDropDownMenu;

@protocol KSYDropDownMenuDelegate <NSObject>

@optional

//当下拉列表将要显示时调用
-(void)dropDownMenuWillShow:(KSYDropDownMenu*)menu;
//当下拉列表显示时调用
-(void)dropDownMenuDidShow:(KSYDropDownMenu*)menu;
//当下拉列表将要收起时调用
-(void)dropDownMenuWillHide:(KSYDropDownMenu*)menu;
//当下拉列表已经收起时调用
-(void)dropDownMenuDidHide:(KSYDropDownMenu*)menu;
//当选择某个选项时调用
-(void)dropDownMenu:(KSYDropDownMenu * )menu selectedCellNumber:(NSInteger)number;

@end

@interface KSYDropDownMenu : UIView<UITableViewDelegate,UITableViewDataSource>

/**
 主按钮  可以自定义样式 也可在 .m文件中 修改默认的一些属性
 */
@property(nonatomic,strong) UIButton* mainBtn;
//协议
@property(nonatomic,assign)id <KSYDropDownMenuDelegate>delegate;

/**
  设置下拉菜单控件样式

 @param titlesArr 下拉菜单内容
 @param rowHeight 行高
 */
- (void)setMenuTitles:(NSArray *)titlesArr rowHeight:(CGFloat)rowHeight;
/**
 显示下拉菜单
 */
-(void)showDropDown;

/**
 隐藏下拉菜单
 */
-(void)hideDropDown;

@end

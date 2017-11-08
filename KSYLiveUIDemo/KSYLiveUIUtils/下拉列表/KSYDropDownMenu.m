//
//  KSYDropDownMenu.m
//  KSYLiveUIDemo
//
//  Created by 王旭 on 2017/11/7.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import "KSYDropDownMenu.h"
#import "UIButton+Extension.h"

#define AnimateTime 0.25f // 下拉时间

@interface KSYDropDownMenu(){
    
    UIImageView* _arrowMark; //尖头图标
    UIView* _listView; //下拉列表背景view
    UITableView* _dropDownTableView;
    
    NSArray* _titleArr; //选项数组
    CGFloat  _rowHeight; //下拉列表行高
    
    
}

@end

@implementation KSYDropDownMenu

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //创建选择按钮
        [self createMainBtnWithFrame:frame];
    }
    return self;
}


-(void)createMainBtnWithFrame:(CGRect)frame{
    
    [_mainBtn removeFromSuperview];
    _mainBtn = nil;
    
    //主按钮 显示在界面上的点击按钮
    //样式可以自定义
    _mainBtn = [UIButton buttonWithTitle:@"竖屏推流" titleColor:KSYRGB(239,69,84) font:KSYUIFont(20) target:self action:nil];
    _mainBtn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [_mainBtn addTarget:self action:@selector(clickMainBtn:) forControlEvents:UIControlEventTouchUpInside];
    _mainBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _mainBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _mainBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    _mainBtn.selected = NO;
    _mainBtn.backgroundColor = [UIColor whiteColor];
    _mainBtn.layer.borderColor = [UIColor blackColor].CGColor;
    _mainBtn.layer.borderWidth = 1;
    [self addSubview:_mainBtn];
    
    _arrowMark = [[UIImageView alloc]initWithFrame: KSYScreen_Frame(_mainBtn.frame.size.width-15, 0, 9, 9)];
    _arrowMark.center = CGPointMake(_arrowMark.center.x, _mainBtn.center.y);
    _arrowMark.image = [UIImage imageNamed:@"dropdownMenu_cornerIcon"];
    [_mainBtn addSubview: _arrowMark];
}

-(void)setMenuTitles:(NSArray*)titlesArr rowHeight:(CGFloat)rowHeight{
    if (self == nil) {
        return ;
    }
    
    _titleArr = [NSArray arrayWithArray:titlesArr];
    _rowHeight = rowHeight;
    
    //下拉列表背景的view
    _listView = [[UIView alloc]init];
    _listView.frame = KSYScreen_Frame(self.frame.origin.x, self.frame.origin.y+ self.frame.size.height, self.frame.size.width, 0);
    _listView.clipsToBounds = YES;
    _listView.layer.masksToBounds = NO;
    _listView.layer.borderColor = [UIColor lightTextColor].CGColor;
    _listView.layer.borderWidth = 0.5f;
    
    //下拉列表的tableView
    _dropDownTableView = [[UITableView alloc]initWithFrame:KSYScreen_Frame(0, 0, _listView.frame.size.width, _listView.frame.size.height) ];
    _dropDownTableView.delegate = self;
    _dropDownTableView.dataSource = self;
    _dropDownTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dropDownTableView.bounces = NO;
    [_listView addSubview:_dropDownTableView];
}

-(void)clickMainBtn:(UIButton*)button{
    //将下拉视图添加到控件的俯视图上
    [self.superview addSubview:_listView];
    
    if (button.selected == NO) {
        [self showDropDown];
    }
    else{
        [self hideDropDown];
    }
}
// 显示下拉列表
-(void)showDropDown{
    //将下拉列表置于最上层
    [_listView.superview bringSubviewToFront:_listView];
    
    if ([self.delegate respondsToSelector:@selector(dropDownMenuDidShow:)]) {
        [self.delegate dropDownMenuDidShow:self];
    }
    
    [UIView animateWithDuration:AnimateTime animations:^{
        _arrowMark.transform = CGAffineTransformMakeRotation(M_PI);
        _listView.frame = KSYScreen_Frame(KSYViewFrame_Origin_X(_listView),KSYViewFramen_Origin_Y(_listView),KSYViewFrame_Size_Width(_listView),_titleArr.count*_rowHeight);
        _dropDownTableView.frame = KSYScreen_Frame(0, 0, KSYViewFrame_Size_Width(_listView), KSYViewFrame_Size_Height(_listView));
        
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(dropDownMenuDidShow:) ]) {
            //已经显示下拉列表
            [self.delegate dropDownMenuDidShow:self];
        }
    }];
    _mainBtn.selected = YES;
}

-(void)hideDropDown{
    if ([self.delegate respondsToSelector:@selector(dropDownMenuWillHide:)]) {
        //将要 隐藏下拉列表
        [self.delegate dropDownMenuWillHide:self];
    }
    [UIView animateWithDuration:AnimateTime animations:^{
        _arrowMark.transform = CGAffineTransformIdentity;
        _listView.frame = KSYScreen_Frame(KSYViewFrame_Origin_X(_listView), KSYViewFramen_Origin_Y(_listView), KSYViewFrame_Size_Width(_listView), 0);
        _dropDownTableView.frame = KSYScreen_Frame(0, 0,KSYViewFrame_Size_Width(_listView), KSYViewFrame_Size_Height(_listView));
        
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(dropDownMenuDidHide:)]) {
            //已经隐藏
            [self.delegate dropDownMenuDidHide:self];
        }
    }];
    _mainBtn.selected = NO;
}

#pragma mark - UITableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _rowHeight;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_titleArr count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"cell";
    
    UITableViewCell* dropListCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (dropListCell == nil) {
        //下拉选项样式
        dropListCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        dropListCell.textLabel.font          = [UIFont systemFontOfSize:11.f];
        dropListCell.textLabel.textColor     = KSYRGB(239,69,84);
        dropListCell.selectionStyle          = UITableViewCellSelectionStyleNone;
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, _rowHeight -0.5, KSYViewFrame_Size_Width(dropListCell), 0.5)];
        line.backgroundColor = [UIColor blackColor];
        [dropListCell addSubview:line];
    }
    dropListCell.textLabel.text = [_titleArr objectAtIndex:indexPath.row];
    return dropListCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [_mainBtn setTitle:cell.textLabel.text forState:UIControlStateNormal];
    
    if ([self.delegate respondsToSelector:@selector(dropDownMenu:selectedCellNumber:)]) {
        [self.delegate dropDownMenu:self selectedCellNumber:indexPath.row]; // 回调代理
    }
    
    [self hideDropDown];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

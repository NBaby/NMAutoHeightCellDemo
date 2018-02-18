//
//  HSAutoHeightTableCell.h
//  HiStor
//
//  Created by panzihao on 2017/3/17.
//  Copyright © 2017年 彭惠珍. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSAutoHeightTableCell : UITableViewCell

/**
 使用该方法给cell赋值，子类继承覆盖

 @param info 赋值
 */
- (void)setInfo:(id)info;

/**
 使用该方法获取Cell高度

 @param info 传入数据
 @return 高度
 */
- (CGFloat)getHeightWithInfo:(id)info;


@end

@interface UITableView(HSCustomTableView)

/**
 保存cell高度缓存
 */
@property (nonatomic, strong) NSCache * cellHeightCache;

/**
 保存获取高度的cell字典
 */
@property (nonatomic, strong) NSMutableDictionary * autoHeightCellDic;

- (UITableViewCell *)hs_customCellWithCellName:(NSString *)cellName;

- (UITableViewCell *)hs_autoHeightCellWithCellName:(NSString *)cellName;

@end

@interface UITableViewCell(HSCustomCell)

@property (nonatomic, weak) UITableView * hs_tableView;


@end

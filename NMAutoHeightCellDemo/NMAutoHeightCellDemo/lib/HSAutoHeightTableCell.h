//
//  HSAutoHeightTableCell.h
//  HiStor
//
//  Created by panzihao on 2017/3/17.
//  Copyright © 2017年 彭惠珍. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NMPropertyType) {
    NMPropertyTypeUnknown    = 0, ///< unknown
    NMPropertyTypeVoid       = 1, ///< void
    NMPropertyTypeBool       = 2, ///< bool
    NMPropertyTypeInt8       = 3, ///< char / BOOL
    NMPropertyTypeUInt8      = 4, ///< unsigned char
    NMPropertyTypeInt16      = 5, ///< short
    NMPropertyTypeUInt16     = 6, ///< unsigned short
    NMPropertyTypeInt32      = 7, ///< int
    NMPropertyTypeUInt32     = 8, ///< unsigned int
    NMPropertyTypeInt64      = 9, ///< long long
    NMPropertyTypeUInt64     = 10, ///< unsigned long long
    NMPropertyTypeFloat      = 11, ///< float
    NMPropertyTypeDouble     = 12, ///< double
    NMPropertyTypeLongDouble = 13, ///< long double
    NMPropertyTypeObject     = 14, ///< id
    NMPropertyTypeClass      = 15, ///< Class
    NMPropertyTypeSEL        = 16, ///< SEL
    NMPropertyTypeBlock      = 17, ///< block
    NMPropertyTypePointer    = 18, ///< void*
    NMPropertyTypeStruct     = 19, ///< struct
    NMPropertyTypeUnion      = 20, ///< union
    NMPropertyTypeCString    = 21, ///< char*
    NMPropertyTypeCArray     = 22, ///< char[10] (for example)
};


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

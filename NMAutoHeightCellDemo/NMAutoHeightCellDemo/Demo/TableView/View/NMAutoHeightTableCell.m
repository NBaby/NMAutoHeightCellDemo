//
//  NMAutoHeightTableCell.m
//  NMAutoHeightCellDemo
//
//  Created by 糯米 on 2018/2/18.
//  Copyright © 2018年 nuomi. All rights reserved.
//

#import "NMAutoHeightTableCell.h"
#import "NMDataModel.h"
@interface NMAutoHeightTableCell(){
    NMDataModel * model;
}
@end

@implementation NMAutoHeightTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 320 + 234;
}

- (void)setInfo:(id)info{
    model = info;
    self.titleLabel.text = model.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

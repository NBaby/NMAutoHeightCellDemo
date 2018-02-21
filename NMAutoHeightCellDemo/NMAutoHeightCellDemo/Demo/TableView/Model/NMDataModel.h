//
//  NMDataModel.h
//  NMAutoHeightCellDemo
//
//  Created by 糯米 on 2018/2/18.
//  Copyright © 2018年 nuomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NMAutoHeightModel.h"
@interface NMDataModel : NMAutoHeightModel
@property (copy, nonatomic) NSString * title;

@property (assign, nonatomic) double numDouble;

@property (assign, nonatomic) int numInt;

@property (strong, nonatomic) NSArray * arr;

@property (strong, nonatomic) NSDictionary * dic;
@end

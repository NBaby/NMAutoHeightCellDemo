//
//  HSAutoHeightTableCell.m
//  HiStor
//
//  Created by panzihao on 2017/3/17.
//  Copyright © 2017年 彭惠珍. All rights reserved.
//

#import "HSAutoHeightTableCell.h"
#import "objc/runtime.h"
#import "NMAutoHeightModel.h"
//#import <CommonCrypto/CommonDigest.h>
@implementation HSAutoHeightTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setInfo:(id)info{
    
}
//- (NSString *)MD5:(id)info{
//    @autoreleasepool {
//        if (info == nil) {
//            return @"";
//        }
//        NSString *mdStr;
//        if ([info isKindOfClass:[NSString class]]) {
//            mdStr =info;
//        }else {
//            mdStr = [info yy_modelToJSONString];
//        }
//
//        const char *original_str = [mdStr UTF8String];
//        unsigned char result[CC_MD5_DIGEST_LENGTH];
//        CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
//        NSMutableString *hash = [NSMutableString string];
//        for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
//        [hash appendFormat:@"%02X", result[i]];
//        return [hash lowercaseString];
//    }
//}
//
////sha1加密
//- (NSString *)sha1:(id)info {
//    if (info == nil) {
//        return @"";
//    }
//    NSString *resultJsonStr;
//    if ([info isKindOfClass:[NSString class]]) {
//        resultJsonStr =info;
//    }else {
//        resultJsonStr = [info yy_modelToJSONString];
//    }
//    NSData *data = [resultJsonStr dataUsingEncoding:NSUTF8StringEncoding];
//    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
//    CC_SHA1(data.bytes, (int)data.length, digest);
//    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
//    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
//    [output appendFormat:@"%02x", digest[i]];
//    return output;
//}
- (void)setAutoHeightWithModel:(id)info{
    [self setInfo:info];
}

- (CGFloat)getHeightWithInfo:(id)info{
    
    NSString *classNameStr = [NSString stringWithUTF8String:object_getClassName(self)];
    NSString *cacheKey = [NSString stringWithFormat:@"%@+%@",classNameStr,[self cacheKeyWithModel:info andArray:[@[] mutableCopy]]];
    CGFloat height = [[self.hs_tableView.cellHeightCache objectForKey:cacheKey] floatValue];
    
    if ( [[self.hs_tableView.cellHeightCache objectForKey:cacheKey] floatValue] != 0) {
        return height;
    }
    
    [self setAutoHeightWithModel:info];
    
    [self layoutSubviews];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    height = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    if (self.hs_tableView.separatorStyle == UITableViewCellSeparatorStyleNone) {
    }else {
        height = height + 1;
    }
    [self.hs_tableView.cellHeightCache setObject:@(height) forKey:cacheKey];
    return height;
}
#pragma 递归计算出key值
- (NSString *)cacheKeyWithModel:(id)target andArray:(NSMutableArray *)currentObjPointArr{
    @autoreleasepool{
        //字符串可能很长，临时字符串使用完就释放
        if ([currentObjPointArr containsObject:target]) {
            return @"objHasInclude";
        }
        [currentObjPointArr addObject:target];
        NSString * resultKey = @"";
        if ([target isKindOfClass:[NSString class]]) {
            return target;
        }
        else if ([target isKindOfClass:[NSArray class]]){
            NSArray * tmpArr = target;
            for (NSInteger i = 0; i < tmpArr.count; i ++) {
                if (i == 0) {
                    resultKey = [NSString stringWithFormat:@"%@[",resultKey];
                }
                else {
                    resultKey = [NSString stringWithFormat:@"%@,",resultKey];
                }
                resultKey = [NSString stringWithFormat:@"%@%@",resultKey,[self cacheKeyWithModel:tmpArr[i] andArray:currentObjPointArr]];
                if (i == tmpArr.count -1) {
                    resultKey = [NSString stringWithFormat:@"%@]",resultKey];
                }
            }
            return resultKey;
        }
        else if ([target isKindOfClass:[NSDictionary class]]){
            NSArray * tmpKeyArr = [target allKeys];
            for (NSInteger i = 0; i < tmpKeyArr.count; i ++) {
                if (i == 0) {
                    resultKey = [NSString stringWithFormat:@"%@{",resultKey];
                }
                else {
                    resultKey = [NSString stringWithFormat:@"%@,",resultKey];
                }
                resultKey = [NSString stringWithFormat:@"%@%@:%@",resultKey,tmpKeyArr[i],[self cacheKeyWithModel:[target valueForKey:tmpKeyArr[i]] andArray:currentObjPointArr]];
                if (i == tmpKeyArr.count -1) {
                    resultKey = [NSString stringWithFormat:@"%@}",resultKey];
                }
            }
            return resultKey;
        }
        else if ([target isKindOfClass:[NMAutoHeightModel class]]){
            NSArray * propertyArr = ((NMAutoHeightModel *)target).autoHeightProperty;
            for (NSInteger i = 0; i < propertyArr.count; i ++) {
                if (i == 0) {
                    resultKey = [NSString stringWithFormat:@"%@{",resultKey];
                }
                else {
                    resultKey = [NSString stringWithFormat:@"%@,",resultKey];
                }
                resultKey = [NSString stringWithFormat:@"%@%@:%@",resultKey,propertyArr[i],[self cacheKeyWithModel:[target valueForKey:propertyArr[i]] andArray:currentObjPointArr]];
                if (i == propertyArr.count -1) {
                    resultKey = [NSString stringWithFormat:@"%@}",resultKey];
                }
            }
            return resultKey;
        }
        else if ([target isKindOfClass:[NSObject class]]){
            return @"";
        }
        else {
            return @"";
        }
        
    }
}

@end

@implementation  UITableView(HSCustomTableView)

- (UITableViewCell *)hs_customCellWithCellName:(NSString *)cellName {
    
    UITableViewCell *cell=(UITableViewCell *)[self dequeueReusableCellWithIdentifier:cellName];
    if(nil==cell) {
        UINib *nib = [UINib nibWithNibName:cellName bundle:[NSBundle bundleForClass:NSClassFromString(cellName)]];
        [self registerNib:nib forCellReuseIdentifier:cellName];
        cell = (UITableViewCell *)[self dequeueReusableCellWithIdentifier:cellName];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.hs_tableView = self;
    return cell;
}

- (UITableViewCell *)hs_autoHeightCellWithCellName:(NSString *)cellName{
    UITableViewCell *cell = [self.autoHeightCellDic objectForKey:cellName];
    if (nil == cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:cellName owner:nil options:nil][0];
        [self.autoHeightCellDic setObject:cell forKey:cellName];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.hs_tableView = self;
    return cell;
}

static char *cellHeightCacheKey = "cellHeightCacheKey";

- (void)setCellHeightCache:(NSCache *)cellHeightCache {
    
    objc_setAssociatedObject(self, cellHeightCacheKey, cellHeightCache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSCache *)cellHeightCache {
    
    NSCache * dic = objc_getAssociatedObject(self,cellHeightCacheKey);
    if (dic== nil) {
        dic = [[NSCache alloc]init];
        self.cellHeightCache = dic;
    }
    return dic;
}


static char *autoHeightCellDicKey = "autoHeightCellDicKey";

- (void)setAutoHeightCellDic:(NSMutableDictionary *)autoHeightCellDic {
    
    objc_setAssociatedObject(self, autoHeightCellDicKey, autoHeightCellDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)autoHeightCellDic{
    
    NSMutableDictionary * dic = objc_getAssociatedObject(self,autoHeightCellDicKey);
    if (dic== nil) {
        dic = [[NSMutableDictionary alloc]init];
        self.autoHeightCellDic = dic;
    }
    return dic;
}

@end

@implementation  UITableViewCell(HSCustomCell)

static char *hs_tableViewKey = "hs_tableViewKey";

- (void)setHs_tableView:(UITableView *)hs_tableView{
    
    objc_setAssociatedObject(self, hs_tableViewKey, hs_tableView, OBJC_ASSOCIATION_ASSIGN);
}

- (UITableView *)hs_tableView{
    
    return objc_getAssociatedObject(self, hs_tableViewKey);
}
@end

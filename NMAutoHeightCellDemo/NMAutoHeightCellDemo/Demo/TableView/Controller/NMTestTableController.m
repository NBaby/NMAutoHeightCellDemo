//
//  NMTestTableController.m
//  NMAutoHeightCellDemo
//
//  Created by 糯米 on 2018/2/17.
//  Copyright © 2018年 nuomi. All rights reserved.
//

#import "NMTestTableController.h"
#import "NMDataModel.h"
#import "NMAutoHeightTableCell.h"
@interface NMTestTableController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray <NMDataModel *>* dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@end

@implementation NMTestTableController

#pragma mark - lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
   
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NMAutoHeightTableCell * cell = (NMAutoHeightTableCell *)[self.mainTableView hs_customCellWithCellName:@"NMAutoHeightTableCell"];
    [cell setInfo:dataArray[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     NMAutoHeightTableCell * cell = (NMAutoHeightTableCell *)[self.mainTableView hs_autoHeightCellWithCellName:@"NMAutoHeightTableCell"];
    CGFloat height = [cell getHeightWithInfo:dataArray[indexPath.row]];
    return height;
}
#pragma mark - custonDelegate

#pragma mark - PriVateMethod
- (void)setUp{
    self.navigationController.navigationBar.translucent = NO;
    dataArray = [[NSMutableArray alloc] init];
}
#pragma mark - EventResponse

/**
 点击添加按钮

 @param sender 添加按钮
 */
- (IBAction)tapAddBtn:(id)sender {
    NMDataModel * model = [[NMDataModel alloc] init];
    model.title = self.inputTextField.text;
    [dataArray addObject:model];
    [self.mainTableView reloadData];
    self.inputTextField.text = nil;
}

/**
 点击清除按钮

 @param sender 清除按钮
 */
- (IBAction)tapCearBtn:(id)sender {
    [dataArray removeAllObjects];
    [self.mainTableView reloadData];
}
#pragma mark - Network

#pragma mark - getter & setter

@end

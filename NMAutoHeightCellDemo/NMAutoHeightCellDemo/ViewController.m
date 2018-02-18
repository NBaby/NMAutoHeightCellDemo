//
//  ViewController.m
//  NMAutoHeightCellDemo
//
//  Created by 糯米 on 2018/2/17.
//  Copyright © 2018年 nuomi. All rights reserved.
//

#import "ViewController.h"
#import "NMTestTableController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapTableViewTest:(id)sender {
    NMTestTableController * controller = [[NMTestTableController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}


@end

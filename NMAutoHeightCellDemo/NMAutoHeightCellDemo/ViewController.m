//
//  ViewController.m
//  NMAutoHeightCellDemo
//
//  Created by 糯米 on 2018/2/17.
//  Copyright © 2018年 nuomi. All rights reserved.
//

#import "ViewController.h"
#import "NMTestTableController.h"
#import "objc/runtime.h"
#import "NMDataModel.h"
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
//    [self test];
    
}
- (void)test{
    unsigned int outCount = 0;
    objc_property_t * properties = class_copyPropertyList([NMDataModel class], &outCount);
    for (unsigned int i = 0; i < outCount; i ++) {
        objc_property_t property = properties[i];
        //属性名
        const char * name = property_getName(property);
        //属性描述
        const char * propertyAttr = property_getAttributes(property);
        NSLog(@"属性描述为 %s 的 %s ", propertyAttr, name);
        
        //属性的特性
        unsigned int attrCount = 0;
        objc_property_attribute_t * attrs = property_copyAttributeList(property, &attrCount);
        for (unsigned int j = 0; j < attrCount; j ++) {
            objc_property_attribute_t attr = attrs[j];
            const char * name = attr.name;
            const char * value = attr.value;
            NSLog(@"属性的描述：%s 值：%s", name, value);
        }
        free(attrs);
        NSLog(@"\n");
    }
    free(properties);
}

@end

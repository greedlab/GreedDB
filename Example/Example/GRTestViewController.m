//
//  GRTestViewController.m
//  GreedDBDemo
//
//  Created by Bell on 15/10/16.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import "GRTestViewController.h"
#import "GreedDB.h"
#import "GRTestModel.h"
#import <MJExtension/MJExtension.h>

@interface GRTestViewController ()

@end

@implementation GRTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    [self test];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test
{
    GRTestModel *model = [[GRTestModel alloc] init];
    model.string = @"string";
    model.integer =  1;
    
    GRDatabaseDefaultModel *dbModel = [[GRDatabaseDefaultModel alloc] init];
    [dbModel setKey:@"key1"];
    [dbModel setValueDictionary:[model keyValues]];
    
    GRDatabaseDefault *database = [[GRDatabaseDefault alloc] init];
    [database setTableName:@"test"];
    NSLog(@"%@",database.dbPath);
    [database createTable];
    [database saveWithModel:dbModel];
    
}

@end

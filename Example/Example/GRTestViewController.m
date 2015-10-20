//
//  GRTestViewController.m
//  GreedDBDemo
//
//  Created by Bell on 15/10/16.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import "GRTestViewController.h"
#import "GRTestDefaultModel.h"
#import "GRTestMultFilterModel.h"

#import <MJExtension/MJExtension.h>

@interface GRTestViewController ()

@end

@implementation GRTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    [self testMultFilter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Default

- (void)testDefault
{
    [self initDefault];
    [self saveDefault];
    [self updateDefault];
}

- (void)initDefault
{
    self.database = [[GRDatabaseDefaultQueue alloc] init];
    NSLog(@"%@",_database.dbPath);
    
    [_database setTableName:@"testDefault"];
    [_database recreateTable];
}

- (void)saveDefault
{
    GRTestDefaultModel *model = [[GRTestDefaultModel alloc] init];
    model.string = @"string";
    model.integer =  1;
    
    GRDatabaseDefaultModel *dbModel = [[GRDatabaseDefaultModel alloc] init];
    [dbModel setKey:@"key1"];
    [dbModel setValueDictionary:[model keyValues]];
    
    [_database saveWithModel:dbModel];
}

- (void)updateDefault
{
    GRTestDefaultModel *model = [[GRTestDefaultModel alloc] init];
    model.string = @"update";
    model.integer =  2;
    
    [_database updateValue:[[model keyValues] JSONString] byKey:@"key1"];
}

#pragma mark - MultFilter

- (void)testMultFilter
{
    [self initMultFilter];
    [self saveMultFilter];
    [self getMultFilter];
    [self delMultFilter];
    [self getMultFilter];
}

- (void)initMultFilter
{
    self.multFilterQueue = [[GRDatabaseMultFilterQueue alloc] init];
    NSLog(@"%@",_multFilterQueue.dbPath);
    [_multFilterQueue setValueName:[GRTestMultFilterModel valueName]];
    [_multFilterQueue setFilterNames:[GRTestMultFilterModel filterNames]];
    [_multFilterQueue setTableName:@"testMultFilter"];
    [_multFilterQueue recreateTable];
}

- (void)saveMultFilter
{
    GRTestMultFilterModel *model = [[GRTestMultFilterModel alloc] init];
    model.value = @"value";
    model.filter1 = @"filter1";
    model.filter4 = @"filter4";
    
    [_multFilterQueue saveWithValueFiltersDictionary:[model gr_keyValues]];
}

- (void)getMultFilter
{
    GRTestMultFilterModel *model = [[GRTestMultFilterModel alloc] init];
    model.filter1 = @"filter1";
    model.filter4 = @"filter4";
    
    NSArray *array = [_multFilterQueue getValuesByFiltersDictionary:[model keyValues]];
    NSLog(@"%@",array);
}

- (void)delMultFilter
{
    GRTestMultFilterModel *model = [[GRTestMultFilterModel alloc] init];
    model.filter1 = @"filter1";
    model.filter4 = @"filter4";
    
    [_multFilterQueue delByValueFiltersDictionary:[model keyValues]];
}

@end

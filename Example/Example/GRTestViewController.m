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

@interface GRTestViewController ()

@end

@implementation GRTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self testDefault];
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
    [self getDefault];
}

- (void)initDefault
{
    self.database = [[GRDatabaseDefaultQueue alloc] init];
    NSLog(@"%@",_database.dbPath);
    
    [_database setTableName:@"testDefault"];
    [_database setCreateFilterIndex:YES];
    [_database setCreateKeyIndex:YES];
    [_database setCreateSortIndex:YES];
    
    [_database recreateTable];
}

- (void)saveDefault
{
    GRTestDefaultModel *model = [[GRTestDefaultModel alloc] init];
    model.string = @"string";
    model.integer =  1;
    NSString *filter = [GRTestDefaultModel filterForFilter1:@"filter1" filter2:@"filter1"];
    
    GRDatabaseDefaultModel *dbModel = [[GRDatabaseDefaultModel alloc] init];
    [dbModel setKey:@1];
    [dbModel setValue:model];
    [dbModel setFilter:filter];
    
    [_database saveWithModel:dbModel];
}

- (void)updateDefault
{
    NSString *filter = [GRTestDefaultModel filterForFilter1:@"filter1" filter2:@"filter1"];
    
    GRTestDefaultModel *model = [[GRTestDefaultModel alloc] init];
    model.string = @"update";
    model.integer =  2;
    
    [_database updateValue:model byKey:@1 filter:filter];
}

- (void)getDefault
{
    NSString *filter = [GRTestDefaultModel filterForFilter1:@"filter1" filter2:@"filter1"];
    
    NSArray *array = [_database getValuesByKey:@1 filter:filter];
    
    NSLog(@"%@",array);
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
    
    [_multFilterQueue saveWithValueFiltersDictionary:[model gr_dictionary]];
}

- (void)getMultFilter
{
    GRTestMultFilterModel *model = [[GRTestMultFilterModel alloc] init];
    model.filter1 = @"filter1";
    model.filter4 = @"filter4";
    NSArray *array = [_multFilterQueue getValuesByFiltersDictionary:[model gr_noNUllDictionary]];
    NSLog(@"%@",array);
}

- (void)delMultFilter
{
    GRTestMultFilterModel *model = [[GRTestMultFilterModel alloc] init];
    model.filter1 = @"filter1";
    model.filter4 = @"filter4";
    
    [_multFilterQueue delByValueFiltersDictionary:[model gr_noNUllDictionary]];
}

@end

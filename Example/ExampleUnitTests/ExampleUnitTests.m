//
//  ExampleUnitTests.m
//  ExampleUnitTests
//
//  Created by Bell on 15/10/26.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <GreedDB/GreedDB.h>

#import "GRTestDefaultModel.h"
#import "GRTestMultFilterModel.h"

@interface ExampleUnitTests : XCTestCase

@property (nonatomic, strong) GRDatabaseDefaultQueue *database;
@property (nonatomic, strong) GRDatabaseMultFilterQueue *multFilterQueue;

@end

@implementation ExampleUnitTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

#pragma mark - Default

- (void)testDefault {
    [self initDefault];
    [self saveDefault];
    [self getDefault];
    [self updateDefault];
    [self getDefault];
}

/**
 *  create table
 */
- (void)initDefault {
    self.database = [[GRDatabaseDefaultQueue alloc] init];
    NSLog(@"%@", _database.dbPath);

    [_database setTableName:@"testDefault"];
    [_database recreateTable];
}

/**
 *  insert data
 */
- (void)saveDefault {
    GRTestDefaultModel *model = [[GRTestDefaultModel alloc] init];
    model.string = @"string";
    model.integer = 1;
    NSString *filter = [GRTestDefaultModel filterForFilter1:@"filter1" filter2:@"filter1"];

    GRDatabaseDefaultModel *dbModel = [[GRDatabaseDefaultModel alloc] init];
    [dbModel setKey:@1];
    [dbModel setValue:model];
    [dbModel setFilter:filter];

    [_database saveWithModel:dbModel];
}

/**
 *  update data
 */
- (void)updateDefault {
    NSString *filter = [GRTestDefaultModel filterForFilter1:@"filter1" filter2:@"filter1"];

    GRTestDefaultModel *model = [[GRTestDefaultModel alloc] init];
    model.string = @"update";
    model.integer = 2;

    [_database updateValue:model byKey:@1 filter:filter];
}

/**
 *  get data
 */
- (void)getDefault {
    NSString *filter = [GRTestDefaultModel filterForFilter1:@"filter1" filter2:@"filter1"];

    NSArray *array = [_database getValuesByKey:@1 filter:filter];

    NSLog(@"%@", array);
}

@end

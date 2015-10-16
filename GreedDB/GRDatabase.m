//
//  GRDatabase.m
//  GreedDBDemo
//
//  Created by Bell on 15/10/16.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import "GRDatabase.h"

@implementation GRDatabase

#pragma mark - init

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - getter

- (NSString *)tableName
{
    if (!_tableName) {
        _tableName = @"defaultTable";
    }
    return _tableName;
}

- (NSString*)dbPath
{
    if (!_dbPath) {
        NSString *bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
        NSString *fileName = [bundleName stringByAppendingString:@".greedBb"];
        _dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
    }
    return _dbPath;
}

- (FMDatabaseQueue *)queue
{
    if (!_queue) {
        _queue = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
    }
    return _queue;
}

#pragma mark - public

- (BOOL)createTable
{
    return YES;
}

- (BOOL)clearTable
{
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString * sql = [NSString stringWithFormat:@"DELETE FROM %@",self.tableName];
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"error to run:%@",sql);
        }
    }];
    return YES;
}

- (BOOL)dropTable
{
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString * sql = [NSString stringWithFormat:@"DROP TABLE %@",self.tableName];
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"error to run:%@",sql);
        }
    }];
    return YES;
}

- (BOOL)recreateTable
{
    [self dropTable];
    return [self createTable];
}

@end

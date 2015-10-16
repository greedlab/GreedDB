//
//  GRDatabaseDefault.m
//  Example
//
//  Created by Bell on 15/10/16.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import "GRDatabaseDefault.h"
#import "FMDatabaseAdditions.h"

@implementation GRDatabaseDefault

#pragma mark - GRDatabase

- (BOOL)createTable
{
    __block BOOL result = YES;
    [self.queue inDatabase:^(FMDatabase *db){
        if (![db tableExists:self.tableName]) {
            {
                NSString *sql = [NSString stringWithFormat:@"CREATE TABLE %@ (key TEXT , value TEXT, filter TEXT ,sort INTEGER)",self.tableName];
                result = [db executeUpdate:sql];
                if (!result) {
                    NSLog(@"error to run %@",sql);
                }
            }
            {
                NSString *sql = [NSString stringWithFormat:@"CREATE INDEX keyIndex ON %@ (key)",self.tableName];
                result = [db executeUpdate:sql];
                if (!result) {
                    NSLog(@"error to run %@",sql);
                }
            }
            {
                NSString *sql = [NSString stringWithFormat:@"CREATE INDEX filterIndex ON %@ (filter)",self.tableName];
                result = [db executeUpdate:sql];
                if (!result) {
                    NSLog(@"error to run %@",sql);
                }
            }
            {
                NSString *sql = [NSString stringWithFormat:@"CREATE INDEX sortIndex ON %@ (sort)",self.tableName];
                result = [db executeUpdate:sql];
                if (!result) {
                    NSLog(@"error to run %@",sql);
                }
            }
        }
    }];
    return result;
}

#pragma mark - save

- (BOOL)saveWithModel:(GRDatabaseDefaultModel*)model delFirst:(BOOL)delFirst;
{
    if (delFirst) {
        [self delByKey:model.key filter:model.filter];
    }
    return [self saveWithModel:model];
}

- (BOOL)saveWithModel:(GRDatabaseDefaultModel*)model
{
    __block BOOL result = NO;
    [self.queue inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ VALUES(:key, :value, :filter, :sort)",self.tableName];
        result = [db executeUpdate:sql withParameterDictionary:[model dbDictionary]];
        if (!result) {
            NSLog(@"error to run %@",sql);
        }
    }];
    return result;
}

#pragma mark - sort - filter

- (NSArray*)getValuesByKey:(NSString*)key filter:(NSString*)filter sort:(BOOL)sort
{
    __block NSMutableArray *array = [[NSMutableArray alloc] init];
    [self.queue inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"SELECT value FROM %@",self.tableName];
        
        sql = [sql stringByAppendingString:@" WHERE"];
        if (key) {
            sql = [sql stringByAppendingFormat:@" key = \"%@\"",key];
        } else {
            sql = [sql stringByAppendingFormat:@" key ISNULL"];
        }
        
        sql = [sql stringByAppendingString:@" AND"];
        if (filter) {
            sql = [sql stringByAppendingFormat:@" filter = \"%@\"",filter];
        } else {
            sql = [sql stringByAppendingFormat:@" filter ISNULL"];
        }
        
        sql = [sql stringByAppendingFormat:@" ORDER BY sort %@",sort ? @"" : @"DESC"];
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSString *value = [rs stringForColumn:@"value"];
            if (value) {
                [array addObject:value];
            }
        }
    }];
    return array.count ? array : nil;
}

- (NSArray*)getKeysByFilter:(NSString*)filter sort:(BOOL)sort
{
    __block NSMutableArray *array = [[NSMutableArray alloc] init];
    [self.queue inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"SELECT key FROM %@",self.tableName];
        
        sql = [sql stringByAppendingString:@" WHERE"];
        if (filter) {
            sql = [sql stringByAppendingFormat:@" filter = \"%@\"",filter];
        } else {
            sql = [sql stringByAppendingFormat:@" filter ISNULL"];
        }
        
        sql = [sql stringByAppendingFormat:@" ORDER BY sort %@",sort ? @"" : @"DESC"];
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSString *key = [rs stringForColumn:@"key"];
            if (key) {
                [array addObject:key];
            }
        }
    }];
    return array.count ? array : nil;
}

- (NSString*)getFirstKeyByFilter:(NSString*)filter
{
    __block NSString *key = nil;
    [self.queue inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"SELECT key FROM %@",self.tableName];
        
        sql = [sql stringByAppendingString:@" WHERE"];
        if (filter) {
            sql = [sql stringByAppendingFormat:@" filter = \"%@\"",filter];
        } else {
            sql = [sql stringByAppendingFormat:@" filter ISNULL"];
        }
        
        sql = [sql stringByAppendingString:@" ORDER BY sort LIMIT 1"];
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            key = [rs stringForColumn:@"key"];
        }
    }];
    return key;
}

- (NSString*)getLastKeyByFilter:(NSString*)filter;
{
    __block NSString *key = nil;
    [self.queue inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"SELECT key FROM %@",self.tableName];
        
        sql = [sql stringByAppendingString:@" WHERE"];
        if (filter) {
            sql = [sql stringByAppendingFormat:@" filter = \"%@\"",filter];
        } else {
            sql = [sql stringByAppendingFormat:@" filter ISNULL"];
        }
        
        sql = [sql stringByAppendingString:@" ORDER BY sort DESC LIMIT 1"];
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            key = [rs stringForColumn:@"key"];
        }
    }];
    return key;
}

/**
 * sort: YES - ascend , NO - descend
 * filter: no filter
 */
#pragma mark - sort  - no filter

- (NSArray*)getValuesByKey:(NSString*)key sort:(BOOL)sort
{
    __block NSMutableArray *array = [[NSMutableArray alloc] init];
    [self.queue inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"SELECT value FROM %@",self.tableName];
        
        sql = [sql stringByAppendingString:@" WHERE"];
        if (key) {
            sql = [sql stringByAppendingFormat:@" key = \"%@\"",key];
        } else {
            sql = [sql stringByAppendingFormat:@" key ISNULL"];
        }
        
        sql = [sql stringByAppendingFormat:@" ORDER BY sort %@",sort ? @"" : @"DESC"];
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSString *value = [rs stringForColumn:@"value"];
            if (value) {
                [array addObject:value];
            }
        }
    }];
    return array.count ? array : nil;
}

- (NSString*)getFirstKey
{
    __block NSString *key = nil;
    [self.queue inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"SELECT key FROM %@",self.tableName];
        
        sql = [sql stringByAppendingString:@" ORDER BY sort LIMIT 1"];
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            key = [rs stringForColumn:@"key"];
        }
    }];
    return key;
}

- (NSString*)getLastKey{
    __block NSString *key = nil;
    [self.queue inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"SELECT key FROM %@",self.tableName];
        
        sql = [sql stringByAppendingString:@" ORDER BY sort DESC LIMIT 1"];
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            key = [rs stringForColumn:@"key"];
        }
    }];
    return key;
}

/**
 * sort: no sort
 * filter: if nil get the value of filter is null
 */
#pragma mark - no sort - filter

- (NSArray*)getValuesByKey:(NSString*)key filter:(NSString*)filter
{
    __block NSMutableArray *array = [[NSMutableArray alloc] init];
    [self.queue inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"SELECT value FROM %@",self.tableName];
        
        sql = [sql stringByAppendingString:@" WHERE"];
        if (key) {
            sql = [sql stringByAppendingFormat:@" key = \"%@\"",key];
        } else {
            sql = [sql stringByAppendingFormat:@" key ISNULL"];
        }
        
        sql = [sql stringByAppendingString:@" AND"];
        if (filter) {
            sql = [sql stringByAppendingFormat:@" filter = \"%@\"",filter];
        } else {
            sql = [sql stringByAppendingFormat:@" filter ISNULL"];
        }
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSString *value = [rs stringForColumn:@"value"];
            if (value) {
                [array addObject:value];
            }
        }
    }];
    return array.count ? array : nil;
}

- (NSString*)getValueByKey:(NSString*)key filter:(NSString*)filter
{
    __block NSString *value = nil;
    [self.queue inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"SELECT value FROM %@",self.tableName];
        
        sql = [sql stringByAppendingString:@" WHERE"];
        if (key) {
            sql = [sql stringByAppendingFormat:@" key = \"%@\"",key];
        } else {
            sql = [sql stringByAppendingFormat:@" key ISNULL"];
        }
        
        sql = [sql stringByAppendingString:@" AND"];
        if (filter) {
            sql = [sql stringByAppendingFormat:@" filter = \"%@\"",filter];
        } else {
            sql = [sql stringByAppendingFormat:@" filter ISNULL"];
        }
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            value = [rs stringForColumn:@"value"];
        }
    }];
    return value;
}

- (BOOL)updateValue:(NSString*)value byKey:(NSString*)key filter:(NSString*)filter
{
    __block BOOL result = NO;
    [self.queue inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET value = \"%@\"",self.tableName,value];
        
        sql = [sql stringByAppendingString:@" WHERE"];
        if (key) {
            sql = [sql stringByAppendingFormat:@" key = \"%@\"",key];
        } else {
            sql = [sql stringByAppendingFormat:@" key ISNULL"];
        }
        
        sql = [sql stringByAppendingString:@" AND"];
        if (filter) {
            sql = [sql stringByAppendingFormat:@" filter = \"%@\"",filter];
        } else {
            sql = [sql stringByAppendingFormat:@" filter ISNULL"];
        }

        result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"error to run %@",sql);
        }
    }];
    return result;
}

- (BOOL)delByKey:(NSString*)key filter:(NSString*)filter
{
    __block BOOL result = NO;
    [self.queue inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",self.tableName];
        
        sql = [sql stringByAppendingString:@" WHERE"];
        if (key) {
            sql = [sql stringByAppendingFormat:@" key = \"%@\"",key];
        } else {
            sql = [sql stringByAppendingFormat:@" key ISNULL"];
        }
        
        sql = [sql stringByAppendingString:@" AND"];
        if (filter) {
            sql = [sql stringByAppendingFormat:@" filter = \"%@\"",filter];
        } else {
            sql = [sql stringByAppendingFormat:@" filter ISNULL"];
        }
        result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"error to run %@",sql);
        }
    }];
    return result;
}

/**
 * sort: no sort
 * filter: no filter
 */
#pragma mark - no sort - no filter

- (NSArray*)getValuesByKey:(NSString*)key
{
    __block NSMutableArray *array = [[NSMutableArray alloc] init];
    [self.queue inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"SELECT value FROM %@",self.tableName];
        
        sql = [sql stringByAppendingString:@" WHERE"];
        if (key) {
            sql = [sql stringByAppendingFormat:@" key = \"%@\"",key];
        } else {
            sql = [sql stringByAppendingFormat:@" key ISNULL"];
        }
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSString *value = [rs stringForColumn:@"value"];
            if (value) {
                [array addObject:value];
            }
        }
    }];
    return array.count ? array : nil;
}

- (NSString*)getValueByKey:(NSString*)key
{
    __block NSString *value = nil;
    [self.queue inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"SELECT value FROM %@",self.tableName];
        
        sql = [sql stringByAppendingString:@" WHERE"];
        if (key) {
            sql = [sql stringByAppendingFormat:@" key = \"%@\"",key];
        } else {
            sql = [sql stringByAppendingFormat:@" key ISNULL"];
        }
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            value = [rs stringForColumn:@"value"];
        }
    }];
    return value;
}

- (BOOL)updateValue:(NSString *)value byKey:(NSString *)key
{
    __block BOOL result = NO;
    [self.queue inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET value = \"%@\"",self.tableName,value];
        
        sql = [sql stringByAppendingString:@" WHERE"];
        if (key) {
            sql = [sql stringByAppendingFormat:@" key = \"%@\"",key];
        } else {
            sql = [sql stringByAppendingFormat:@" key ISNULL"];
        }
        
        result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"error to run %@",sql);
        }
    }];
    return result;
}

- (BOOL)delByKey:(NSString*)key
{
    __block BOOL result = NO;
    [self.queue inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",self.tableName];
        
        sql = [sql stringByAppendingString:@" WHERE"];
        if (key) {
            sql = [sql stringByAppendingFormat:@" key = \"%@\"",key];
        } else {
            sql = [sql stringByAppendingFormat:@" key ISNULL"];
        }
        
        result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"error to run %@",sql);
        }
    }];
    return result;
}


@end

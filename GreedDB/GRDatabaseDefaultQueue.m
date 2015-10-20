//
//  GRDatabaseDefaultQueue.m
//  Example
//
//  Created by Bell on 15/10/16.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import "GRDatabaseDefaultQueue.h"
#import "FMDatabaseAdditions.h"

@implementation GRDatabaseDefaultQueue

- (instancetype)init
{
    self = [super init];
    if (self) {
        _blobValue = NO;
    }
    return self;
}

#pragma mark - getter

- (NSString *)tableName
{
    if (!_tableName) {
        _tableName = @"defaultQueue";
    }
    return _tableName;
}

#pragma mark - GRDatabaseBaseQueue

- (BOOL)createTable
{
    __block BOOL result = YES;
    [self.queue inDatabase:^(FMDatabase *db){
        if (![db tableExists:self.tableName]) {
            {
                NSString *sql;
                if (_blobValue) {
                    sql = [NSString stringWithFormat:@"CREATE TABLE %@ (key TEXT , value BLOB, filter TEXT ,sort INTEGER)",self.tableName];
                } else {
                    sql = [NSString stringWithFormat:@"CREATE TABLE %@ (key TEXT , value TEXT, filter TEXT ,sort INTEGER)",self.tableName];
                }
                
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
        NSMutableString *sql = [NSMutableString stringWithFormat:@"INSERT INTO %@ VALUES(:key, :value, :filter, :sort) ",self.tableName];
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
        NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT value FROM %@",self.tableName];
        
        [sql appendString:@" WHERE"];
        [sql appendString: key ? [NSString stringWithFormat:@" key = \"%@\"",key] : @" key ISNULL"];
        
        [sql appendString:@" AND"];
        [sql appendString: filter ? [NSString stringWithFormat:@" filter = \"%@\"",filter] : @" filter ISNULL"];
        
        [sql appendFormat:@" ORDER BY sort %@",sort ? @"" : @"DESC"];
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            id value = [rs objectForColumnName:@"value"];
            if (value) {
                [array addObject:value];
            }
        }
    }];
    return array;
}

- (NSArray*)getKeysByFilter:(NSString*)filter sort:(BOOL)sort
{
    __block NSMutableArray *array = [[NSMutableArray alloc] init];
    [self.queue inDatabase:^(FMDatabase *db){
        NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT key FROM %@",self.tableName];
        
        [sql appendString:@" WHERE"];
        [sql appendString: filter ? [NSString stringWithFormat:@" filter = \"%@\"",filter] : @" filter ISNULL"];
        
        [sql appendFormat:@" ORDER BY sort %@",sort ? @"" : @"DESC"];
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSString *key = [rs stringForColumn:@"key"];
            if (key) {
                [array addObject:key];
            }
        }
    }];
    return array;
}

- (NSString*)getFirstKeyByFilter:(NSString*)filter
{
    __block NSString *key = nil;
    [self.queue inDatabase:^(FMDatabase *db){
        NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT key FROM %@",self.tableName];
        
        [sql appendString:@" WHERE"];
        [sql appendString: filter ? [NSString stringWithFormat:@" filter = \"%@\"",filter] : @" filter ISNULL"];
        
        [sql appendString:@" ORDER BY sort LIMIT 1"];
        
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
        NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT key FROM %@",self.tableName];
        
        [sql appendString:@" WHERE"];
        [sql appendString: filter ? [NSString stringWithFormat:@" filter = \"%@\"",filter] : @" filter ISNULL"];
        
        [sql appendString:@" ORDER BY sort DESC LIMIT 1"];
        
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
        NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT value FROM %@",self.tableName];
        
        [sql appendString:@" WHERE"];
        [sql appendString: key ? [NSString stringWithFormat:@" key = \"%@\"",key] : @" key ISNULL"];
        
        [sql appendFormat:@" ORDER BY sort %@",sort ? @"" : @"DESC"];
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            id value = [rs objectForColumnName:@"value"];
            if (value) {
                [array addObject:value];
            }
        }
    }];
    return array;
}

- (NSString*)getFirstKey
{
    __block NSString *key = nil;
    [self.queue inDatabase:^(FMDatabase *db){
        NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT key FROM %@",self.tableName];
        
        [sql appendString:@" ORDER BY sort LIMIT 1"];
        
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
        NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT key FROM %@",self.tableName];
        
        [sql appendString:@" ORDER BY sort DESC LIMIT 1"];
        
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
        NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT value FROM %@",self.tableName];
        
        [sql appendString:@" WHERE"];
        [sql appendString: key ? [NSString stringWithFormat:@" key = \"%@\"",key] : @" key ISNULL"];
        
        [sql appendString:@" AND"];
        [sql appendString: filter ? [NSString stringWithFormat:@" filter = \"%@\"",filter] : @" filter ISNULL"];
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            id value = [rs objectForColumnName:@"value"];
            if (value) {
                [array addObject:value];
            }
        }
    }];
    return array;
}

- (id)getValueByKey:(NSString*)key filter:(NSString*)filter
{
    __block id value = nil;
    [self.queue inDatabase:^(FMDatabase *db){
        NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT value FROM %@",self.tableName];
        
        [sql appendString:@" WHERE"];
        [sql appendString: key ? [NSString stringWithFormat:@" key = \"%@\"",key] : @" key ISNULL"];
        
        [sql appendString:@" AND"];
        [sql appendString: filter ? [NSString stringWithFormat:@" filter = \"%@\"",filter] : @" filter ISNULL"];
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            value = [rs objectForColumnName:@"value"];
        }
    }];
    return value;
}

- (BOOL)updateValue:(id)value byKey:(NSString*)key filter:(NSString*)filter
{
    __block BOOL result = NO;
    [self.queue inDatabase:^(FMDatabase *db){
        NSMutableString *sql = [NSMutableString stringWithFormat:@"UPDATE %@ SET value = ?",self.tableName];
        
        [sql appendString:@" WHERE"];
        [sql appendString: key ? [NSString stringWithFormat:@" key = \"%@\"",key] : @" key ISNULL"];
        
        [sql appendString:@" AND"];
        [sql appendString: filter ? [NSString stringWithFormat:@" filter = \"%@\"",filter] : @" filter ISNULL"];
        
        result = [db executeUpdate:sql,value];
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
        NSMutableString *sql = [NSMutableString stringWithFormat:@"DELETE FROM %@",self.tableName];
        
        [sql appendString:@" WHERE"];
        [sql appendString: key ? [NSString stringWithFormat:@" key = \"%@\"",key] : @" key ISNULL"];
        
        [sql appendString:@" AND"];
        [sql appendString: filter ? [NSString stringWithFormat:@" filter = \"%@\"",filter] : @" filter ISNULL"];
        
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
        NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT value FROM %@",self.tableName];
        
        [sql appendString:@" WHERE"];
        [sql appendString: key ? [NSString stringWithFormat:@" key = \"%@\"",key] : @" key ISNULL"];
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            id value = [rs objectForColumnName:@"value"];
            if (value) {
                [array addObject:value];
            }
        }
    }];
    return array;
}

- (NSString*)getValueByKey:(NSString*)key
{
    __block id value = nil;
    [self.queue inDatabase:^(FMDatabase *db){
        NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT value FROM %@",self.tableName];
        
        [sql appendString:@" WHERE"];
        [sql appendString: key ? [NSString stringWithFormat:@" key = \"%@\"",key] : @" key ISNULL"];
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            value = [rs objectForColumnName:@"value"];
        }
    }];
    return value;
}

- (BOOL)updateValue:(id)value byKey:(NSString *)key
{
    __block BOOL result = NO;
    [self.queue inDatabase:^(FMDatabase *db){
        NSMutableString *sql = [NSMutableString stringWithFormat:@"UPDATE %@ SET value = ?",self.tableName];
        
        [sql appendString:@" WHERE"];
        [sql appendString: key ? [NSString stringWithFormat:@" key = \"%@\"",key] : @" key ISNULL"];
        result = [db executeUpdate:sql,value];
        
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
        NSMutableString *sql = [NSMutableString stringWithFormat:@"DELETE FROM %@",self.tableName];
        
        [sql appendString:@" WHERE"];
        [sql appendString: key ? [NSString stringWithFormat:@" key = \"%@\"",key] : @" key ISNULL"];
        
        result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"error to run %@",sql);
        }
    }];
    return result;
}


@end

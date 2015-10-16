//
//  GRDatabase.h
//  GreedDBDemo
//
//  Created by Bell on 15/10/16.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"

/**
 *  表操作
 */
@interface GRDatabase : NSObject

@property(nonatomic,strong)NSString *tableName;

/**
 *  databse operation queue
 */
@property(nonatomic,strong)FMDatabaseQueue *queue;

/**
 *  the path of database file
 */
@property(nonatomic,strong)NSString *dbPath;

#pragma mark - public

/**
 *  must realize in sub class
 */
- (BOOL)createTable;

- (BOOL)clearTable;

- (BOOL)dropTable;

- (BOOL)recreateTable;

@end

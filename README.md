# GreedDB [![Join the chat at https://gitter.im/greedlab/GreedDB](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/greedlab/GreedDB?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) [![Build Status](https://travis-ci.org/greedlab/GreedDB.svg?branch=master)](https://travis-ci.org/greedlab/GreedDB) 

 A storage for ios. based on [FMDB](https://github.com/ccgus/fmdb) and [GreedJSON](https://github.com/greedlab/GreedJSON). could save NSDictionary,NSArray,NSData,NSString,NSNumber or NSObject  directly
 
 [中文版](README-cn.md)
 
# Installation

pod 'GreedDB'

# Usage

## [GRDatabaseDefaultQueue](https://github.com/greedlab/GreedDB/blob/master/GreedDB/GRDatabaseDefaultQueue.h)

storage for the default model [GRDatabaseDefaultModel](https://github.com/greedlab/GreedDB/blob/master/GreedDB/GRDatabaseDefaultModel.h)

``` objc
/**
 *  create table
 */
- (void)initDefault {
    self.database = [[GRDatabaseDefaultQueue alloc] init];
    NSLog(@"%@", _database.dbPath);

    [_database setTableName:@"testDefault"];
    [_database setCreateFilterIndex:YES];
    [_database setCreateKeyIndex:YES];
    [_database setCreateSortIndex:YES];

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
```

## [GRDatabaseMultFilterQueue](https://github.com/greedlab/GreedDB/blob/master/GreedDB/GRDatabaseMultFilterQueue.h)

storage for mult filters. eg :search with more keys

``` objc
/**
 *  create table
 */
- (void)initMultFilter {
    self.multFilterQueue = [[GRDatabaseMultFilterQueue alloc] init];
    NSLog(@"%@", _multFilterQueue.dbPath);
    [_multFilterQueue setValueName:[GRTestMultFilterModel valueName]];
    [_multFilterQueue setFilterNames:[GRTestMultFilterModel filterNames]];
    [_multFilterQueue setTableName:@"testMultFilter"];
    [_multFilterQueue recreateTable];
}

/**
 *  insert data
 */
- (void)saveMultFilter {
    GRTestMultFilterModel *model = [[GRTestMultFilterModel alloc] init];
    model.value = @"value";
    model.filter1 = @"filter1";
    model.filter4 = @"filter4";

    [_multFilterQueue saveWithValueFiltersDictionary:[model gr_dictionary]];
}

/**
 *  get data
 */
- (void)getMultFilter {
    GRTestMultFilterModel *model = [[GRTestMultFilterModel alloc] init];
    model.filter1 = @"filter1";
    model.filter4 = @"filter4";
    NSArray *array = [_multFilterQueue getValuesByFiltersDictionary:[model gr_noNUllDictionary]];
    NSLog(@"%@", array);
}

/**
 *  delete data
 */
- (void)delMultFilter {
    GRTestMultFilterModel *model = [[GRTestMultFilterModel alloc] init];
    model.filter1 = @"filter1";
    model.filter4 = @"filter4";

    [_multFilterQueue delByValueFiltersDictionary:[model gr_noNUllDictionary]];
}
```

# Release Notes

[CHANGELOG.md](CHANGELOG.md)

# LICENSE

[MIT](LICENSE)

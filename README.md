# GreedDB
this is used for storage in ios. based on [FMDB](https://github.com/ccgus/fmdb) . can save json string ,blob and other info direct
# Installation
pod 'GreedDB'
# usage
## [GRDatabaseDefaultQueue](https://github.com/greedlab/GreedDB/blob/master/GreedDB/GRDatabaseDefaultQueue.h)
used for the storage of [GRDatabaseDefaultModel](https://github.com/greedlab/GreedDB/blob/master/GreedDB/GRDatabaseDefaultModel.h)
* * *
    GRDatabaseDefaultQueue *database = [[GRDatabaseDefaultQueue alloc] init];
    // set table name
    [database setTableName:@"testDefault"];
    // create table
    [database createTable];
    GRTestDefaultModel *model = [[GRTestDefaultModel alloc] init];
    model.string = @"string";
    model.integer =  1;
    GRDatabaseDefaultModel *dbModel = [[GRDatabaseDefaultModel alloc] init];
    [dbModel setKey:@"key1"];
    [dbModel setValueDictionary:[model keyValues]];
    // save model
    [database saveWithModel:dbModel];
* * *
## [GRDatabaseMultFilterQueue](https://github.com/greedlab/GreedDB/blob/master/GreedDB/GRDatabaseMultFilterQueue.h)
used for get value from mult filters. eg :search with more keys
* * *
    GRDatabaseMultFilterQueue database = [[GRDatabaseMultFilterQueue alloc] init];
    // set the key name of the value
    [database setValueName:[GRTestMultFilterModel valueName]];
    // set the key names of the filters
    [database setFilterNames:[GRTestMultFilterModel filterNames]];
    // set table name
    [database setTableName:@"testMultFilter"];
    // create table
    [database createTable];
    GRTestMultFilterModel *model = [[GRTestMultFilterModel alloc] init];
    model.value = @"value";
    model.filter1 = @"filter1";
    model.filter4 = @"filter4";
    // save model 
    [database saveWithValueFiltersDictionary:[model gr_keyValues]];
* * *
# LICENSE
MIT

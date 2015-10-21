# GreedDB
this is a storage manager for ios. based on [FMDB](https://github.com/ccgus/fmdb) and [MJExtension](https://github.com/CoderMJLee/MJExtension). can save NSDictionary,NSArray,NSData,NSString,NSNumber or NSObject  directly
# Installation
pod 'GreedDB'
# usage
## [GRDatabaseDefaultQueue](https://github.com/greedlab/GreedDB/blob/master/GreedDB/GRDatabaseDefaultQueue.h)
storage for the model [GRDatabaseDefaultModel](https://github.com/greedlab/GreedDB/blob/master/GreedDB/GRDatabaseDefaultModel.h)
``` objc
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
```
## [GRDatabaseMultFilterQueue](https://github.com/greedlab/GreedDB/blob/master/GreedDB/GRDatabaseMultFilterQueue.h)
used for getting value from mult filters. eg :search with more keys

``` objc
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
```
# LICENSE
MIT

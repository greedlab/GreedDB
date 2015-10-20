//
//  GRDatabaseMultFilterQueue.h
//  Example
//
//  Created by Bell on 15/10/20.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import "GRDatabaseBaseQueue.h"

/**
 *  get the key from mult filters. eg : used for search with mult keys
 */
@interface GRDatabaseMultFilterQueue : GRDatabaseBaseQueue

@property(nonatomic,strong)NSArray *filterNames;
@property(nonatomic,strong)NSString *valueName;

- (BOOL)saveWithValueFiltersDictionary:(NSDictionary*)dictionary;

- (NSMutableArray*)getValuesByFiltersDictionary:(NSDictionary*)dictionary;

- (BOOL)delByValueFiltersDictionary:(NSDictionary*)dictionary;

@end

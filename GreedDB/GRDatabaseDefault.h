//
//  GRDatabaseDefault.h
//  Example
//
//  Created by Bell on 15/10/16.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import "GRDatabase.h"
#import "GRDatabaseDefaultModel.h"

/**
 *  process database
 */
@interface GRDatabaseDefault : GRDatabase

#pragma mark - save
/**
 *  save model
 *
 *  if delFirst is YES call delByKey:filter: first
 *  if delFirst is NO save direct
 *
 *  @param model    model
 *  @param delFirst whether delete first
 *
 *  @return whether success
 */
- (BOOL)saveWithModel:(GRDatabaseDefaultModel*)model delFirst:(BOOL)delFirst;
/**
 *  save direct
 */
- (BOOL)saveWithModel:(GRDatabaseDefaultModel*)model;

/**
 * sort: YES - ascend , NO - descend
 * filter: if nil get the value of filter is null
 */
#pragma mark - sort - filter

- (NSArray*)getValuesByKey:(NSString*)key filter:(NSString*)filter sort:(BOOL)sort;
- (NSArray*)getKeysByFilter:(NSString*)filter sort:(BOOL)sort;
- (NSString*)getFirstKeyByFilter:(NSString*)filter;
- (NSString*)getLastKeyByFilter:(NSString*)filter;

/**
 * sort: YES - ascend , NO - descend
 * filter: no filter
 */
#pragma mark - sort  - no filter

- (NSArray*)getValuesByKey:(NSString*)key sort:(BOOL)sort;
- (NSString*)getFirstKey;
- (NSString*)getLastKey;

/**
 * sort: no sort
 * filter: if nil get the value of filter is null
 */
#pragma mark - no sort - filter

- (NSArray*)getValuesByKey:(NSString*)key filter:(NSString*)filter;
- (NSString*)getValueByKey:(NSString*)key filter:(NSString*)filter;
- (BOOL)updateValue:(NSString*)value byKey:(NSString*)key filter:(NSString*)filter;
- (BOOL)delByKey:(NSString*)key filter:(NSString*)filter;

/**
 * sort: no sort
 * filter: no filter
 */
#pragma mark - no sort - no filter

- (NSArray*)getValuesByKey:(NSString*)key;
- (NSString*)getValueByKey:(NSString*)key;
- (BOOL)updateValue:(NSString*)value byKey:(NSString*)key;
- (BOOL)delByKey:(NSString*)key;

@end

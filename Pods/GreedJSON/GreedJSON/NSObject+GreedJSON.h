//
//  NSObject+GreedJSON.h
//  Pods
//
//  Created by Bell on 15/11/3.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (GreedJSON)

#pragma mark - property getter

/**
 *  all property names only in this class
 */
- (NSArray*)gr_propertyNames;

/**
 *  all property names in this class and all super classes
 */
- (NSMutableArray*)gr_allPropertyNames;

- (NSMutableArray*)gr_allIgnoredPropertyNames;
- (NSMutableDictionary*)gr_allReplacedPropertyNames;
- (NSMutableDictionary*)gr_allClassInArray;

#pragma mark - Property init

/**
 *  whether use [NSNull null] to replace nil
 *  default NO
 *
 *  @return BOOL
 */
+ (BOOL)gr_useNullProperty;

/**
 *  get all ignored property names
 *
 */
+ (NSArray<NSString *> *)gr_ignoredPropertyNames;

/**
 *  @{propertyName:dictionaryKey}
 */
+ (NSDictionary<NSString *, NSString *> *)gr_replacedPropertyNames;

/**
 *  class in array
 */
+ (NSDictionary<NSString *, Class > *)gr_classInArray;

#pragma mark - Foundation

- (BOOL)gr_isFromFoundation;

#pragma mark - format

/**
 *  update Model with NSDictionary
 */
- (instancetype)gr_setDictionary:(NSDictionary*)dictionary;

/**
 *  init Model with NSDictionary
 */
+ (id)gr_objectFromDictionary:(NSDictionary*)dictionary;

/**
 *  get NSMutableDictionary from model, if gr_isFromFoundation return self
 */
- (__kindof NSObject *)gr_dictionary;

@end

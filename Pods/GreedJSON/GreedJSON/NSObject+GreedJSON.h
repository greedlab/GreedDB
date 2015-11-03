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

- (NSArray*)gr_propertyNames;

#pragma mark - Property init

/**
 *  default NO
 *
 *  @return whether use [NSNull null] to replace nil
 */
+ (BOOL)gr_useNullProperty;

+ (NSArray*)gr_ignoredPropertyNames;
+ (NSArray*)gr_allowedPropertyNames;

/**
 *  @{propertyName:dictionaryKey}
 *
 */
+ (NSDictionary*)gr_replacedPropertyNames;

+ (NSDictionary *)gr_classInArray;

#pragma mark - Foundation

- (BOOL)gr_isFromFoundation;

#pragma mark - parse

/**
 *  update Model with NSDictionary
 */
- (instancetype)gr_setDictionary:(NSDictionary*)dictionary;

/**
 *  NSDictionary to Model
 */
+ (id)gr_objectFromDictionary:(NSDictionary*)dictionary;

/**
 *  get NSMutableDictionary for the model based from NSObject, if gr_isFromFoundation will return self
 *
 *  @return if gr_isFromFoundation return self,else return NSMutableDictionary
 */
- (__kindof NSObject *)gr_dictionary;

@end

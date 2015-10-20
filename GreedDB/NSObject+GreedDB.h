//
//  NSObject+GreedDB.h
//  GreedDBDemo
//
//  Created by Bell on 15/10/16.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

@interface NSObject (GreedDB)

+ (id)EntityWithJsonString:(NSString*)jsonString;

/**
 *  if value is nil set [NSNull null]
 *
 *  @return keyValues
 */
- (NSMutableDictionary *)gr_keyValues;

/**
 *  get all valid properties
 */
- (NSMutableArray *)gr_properties;

@end

//
//  GRDatabaseDefaultModel.h
//  GreedDBDemo
//
//  Created by Bell on 15/10/16.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Default Model
 */
@interface GRDatabaseDefaultModel : NSObject

/**
 *  NSString or NSNumber
 */
@property (nonatomic, strong) id key;

/**
 *  NSDictionary,NSArray,NSData,NSString,NSNumber or NSObject
 */
@property (nonatomic, strong) id value;

/**
 *  NSString or NSNumber
 */
@property (nonatomic, strong) id filter;

@property (nonatomic, assign) long long sort;

- (NSMutableDictionary *)dbDictionary;

@end

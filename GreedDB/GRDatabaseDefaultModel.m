//
//  GRDatabaseDefaultModel.m
//  GreedDBDemo
//
//  Created by Bell on 15/10/16.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import "GRDatabaseDefaultModel.h"
#import <MJExtension/MJExtension.h>

@implementation GRDatabaseDefaultModel

+ (NSArray *)ignoredPropertyNames
{
    return @[@"valueDictionary"];
}

- (NSMutableDictionary*)dbDictionary
{
    if (!_value && _valueDictionary) {
        [self setValue:[_valueDictionary JSONString]];
    }
    NSMutableDictionary *dbDictionary = self.keyValues;
    
    if (!_key) {
        [dbDictionary setObject:[NSNull null] forKey:@"key"];
    }
    if (!_filter) {
        [dbDictionary setObject:[NSNull null] forKey:@"filter"];
    }
    if (!_value) {
        [dbDictionary setObject:[NSNull null] forKey:@"value"];
    }
    return dbDictionary;
}

@end

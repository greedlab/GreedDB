//
//  GRDatabaseDefaultModel.m
//  GreedDBDemo
//
//  Created by Bell on 15/10/16.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import "GRDatabaseDefaultModel.h"
#import "NSObject+GreedDB.h"

@implementation GRDatabaseDefaultModel

+ (NSArray *)ignoredPropertyNames
{
    return @[@"valueDictionary"];
}

- (NSMutableDictionary *)dbDictionary
{
    if (!_value && _valueDictionary) {
        [self setValue:[_valueDictionary JSONString]];
    }
    NSMutableDictionary *keyValues = [self gr_keyValues];
    
    return keyValues;
}

@end

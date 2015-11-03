//
//  GRTestMultFilterModel.m
//  Example
//
//  Created by Bell on 15/10/20.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import "GRTestMultFilterModel.h"
#import "GreedJSON.h"

@implementation GRTestMultFilterModel

+ (BOOL)gr_useNullProperty
{
    return YES;
}

+ (NSString*)valueName
{
    return @"value";
}

+ (NSArray*)filterNames
{
    NSMutableArray *array = [[self gr_propertyNames] mutableCopy];
    NSString *valueName = [self valueName];
    if (valueName) {
        [array removeObject:valueName];
    }
    return array;
}

@end

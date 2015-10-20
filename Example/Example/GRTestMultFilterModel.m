//
//  GRTestMultFilterModel.m
//  Example
//
//  Created by Bell on 15/10/20.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import "GRTestMultFilterModel.h"
#import "NSObject+GreedDB.h"


@implementation GRTestMultFilterModel

+ (NSString*)valueName
{
    return @"value";
}

+ (NSArray*)filterNames
{
    NSMutableArray *array = [self gr_properties];
    NSString *valueName = [self valueName];
    if (valueName) {
        [array removeObject:valueName];
    }
    return array;
}

@end

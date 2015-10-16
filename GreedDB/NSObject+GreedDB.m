//
//  NSObject+GreedDB.m
//  GreedDBDemo
//
//  Created by Bell on 15/10/16.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import "NSObject+GreedDB.h"
#import <MJExtension/MJExtension.h>

@implementation NSObject (GreedDB)

+ (id)EntityWithJsonString:(NSString*)jsonString
{
    return [[self class] objectWithKeyValues:jsonString];
}

@end

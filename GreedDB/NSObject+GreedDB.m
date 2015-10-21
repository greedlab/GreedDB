//
//  NSObject+GreedDB.m
//  GreedDBDemo
//
//  Created by Bell on 15/10/16.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import "NSObject+GreedDB.h"

@implementation NSObject (GreedDB)

#pragma mark - public

+ (id)EntityWithJsonString:(NSString*)jsonString
{
    return [[self class] objectWithKeyValues:jsonString];
}

- (NSMutableDictionary *)gr_keyValues
{
    NSMutableDictionary *keyValues = [self keyValues];
    
    Class aClass = [self class];
    NSArray *allowedPropertyNames = [aClass totalAllowedPropertyNames];
    NSArray *ignoredPropertyNames = [aClass totalIgnoredPropertyNames];
    
    [aClass enumerateProperties:^(MJProperty *property, BOOL *stop) {
        if (allowedPropertyNames.count && ![allowedPropertyNames containsObject:property.name]) return;
        if ([ignoredPropertyNames containsObject:property.name]) return;
        
        id value = [property valueForObject:self];
        if (!value) {
            [keyValues setObject:[NSNull null] forKey:property.name];
        }
    }];
    return keyValues;
}

- (NSString *)gr_JSONString
{
    if (self) {
        if ([self isKindOfClass:[NSString class]]) {
            return (NSString*)self;
        } else if ([self isKindOfClass:[NSDictionary class]]
                   || [self isKindOfClass:[NSArray class]]
                   || [self isKindOfClass:[NSData class]]) {
            return [self JSONString];
        } else if ([self isKindOfClass:[NSNumber class]]) {
            return [(NSNumber*)self stringValue];
        } else {
            NSDictionary *dictionary = [self keyValues];
            return [dictionary JSONString];
        }
    } else {
        return nil;
    }
}

- (NSMutableArray *)gr_properties
{
    Class aClass = [self class];
    NSMutableArray *allowedPropertyNames = [aClass totalAllowedPropertyNames];
    if (allowedPropertyNames.count) {
        return allowedPropertyNames;
    };
    
    NSMutableArray *properties = [[NSMutableArray alloc] init];
    NSMutableArray *ignoredPropertyNames = [aClass totalIgnoredPropertyNames];
    
    [aClass enumerateProperties:^(MJProperty *property, BOOL *stop) {
        if (![ignoredPropertyNames containsObject:property.name]) {
            [properties addObject:property.name];
        };
    }];
    return properties;
}

@end

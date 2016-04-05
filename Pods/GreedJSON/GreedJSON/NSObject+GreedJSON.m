//
//  NSObject+GreedJSON.m
//  Pods
//
//  Created by Bell on 15/11/3.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import "NSObject+GreedJSON.h"
#import <objc/runtime.h>
#import "GRJSONHelper.h"

@implementation NSObject (GreedJSON)

#pragma mark - property getter

- (NSArray*)gr_propertyNames
{
    return [GRJSONHelper propertyNames:[self class]];
}

- (NSMutableArray*)gr_allPropertyNames
{
    return [GRJSONHelper allPropertyNames:[self class]];
}

- (NSMutableArray*)gr_allIgnoredPropertyNames
{
    return [GRJSONHelper allIgnoredPropertyNames:[self class]];
}

- (NSMutableDictionary*)gr_allReplacedPropertyNames
{
    return [GRJSONHelper allReplacedPropertyNames:[self class]];
}

- (NSMutableDictionary*)gr_allClassInArray
{
    return [GRJSONHelper allClassInArray:[self class]];
}

#pragma mark - Property init

+ (BOOL)gr_useNullProperty
{
    return NO;
}

+ (NSArray<NSString *> *)gr_ignoredPropertyNames
{
    NSArray *array = nil;
    Class superClass = class_getSuperclass([self class]);
    if (superClass && superClass != [NSObject class]) {
        array = [superClass gr_ignoredPropertyNames];
    }
    return array;
}

+ (NSDictionary<NSString *, NSString *> *)gr_replacedPropertyNames
{
    NSDictionary *dictionary = nil;
    Class superClass = class_getSuperclass([self class]);
    if (superClass && superClass != [NSObject class]) {
        dictionary = [superClass gr_replacedPropertyNames];
    }
    return dictionary;
}

+ (NSDictionary<NSString *, Class > *)gr_classInArray
{
    NSDictionary *dictionary = nil;
    Class superClass = class_getSuperclass([self class]);
    if (superClass && superClass != [NSObject class]) {
        dictionary = [superClass gr_classInArray];
    }
    return dictionary;
}

#pragma mark - Foundation

- (BOOL)gr_isFromFoundation
{
    return [GRJSONHelper isClassFromFoundation:[self class]];
}

#pragma mark - parse

- (instancetype)gr_setDictionary:(NSDictionary*)dictionary
{
    Class aClass = [self class];
    NSArray *ignoredPropertyNames = [self gr_allIgnoredPropertyNames];
    NSDictionary *replacedPropertyNames = [self gr_allReplacedPropertyNames];
    
    NSArray *propertyNames = [GRJSONHelper allPropertyNames:aClass];
    [propertyNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = (NSString *)obj;
        if (ignoredPropertyNames && [ignoredPropertyNames containsObject:key]) {
            return;
        }
        if ([GRJSONHelper isPropertyReadOnly:aClass propertyName:key]) {
            return;
        }
        
        NSString *dictKey= nil;
        dictKey = [replacedPropertyNames objectForKey:key];
        if (!dictKey) {
            dictKey = key;
        }
        
        id value = [dictionary valueForKey:dictKey];
        if (value == [NSNull null] || value == nil) {
            return;
        }
        
        Class klass = [GRJSONHelper propertyClassForPropertyName:key ofClass:aClass];
        if (!klass) {
            return;
        }
        if ([value isKindOfClass:[NSDictionary class]]) { // handle dictionary
            NSDictionary *dictionary = (NSDictionary*)value;
            if (dictionary.count == 0) {
                return;
            }
            if (klass == [NSDictionary class]) {
                [self setValue:value forKey:key];
            } else if (klass == [NSNumber class]
                       || klass == [NSString class]
                       || klass == [NSURL class]
                       || klass == [NSArray class]) {
                return;
            } else {
                [self setValue:[[klass class] gr_objectFromDictionary:value] forKey:key];
            }
        } else if ([value isKindOfClass:[NSArray class]]) { // handle array
            NSArray *array = (NSArray*)value;
            if (array.count == 0) {
                return;
            }
            if (klass != [NSArray class]) {
                return;
            }
            NSMutableArray *childObjects = [[NSMutableArray alloc] init];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                Class bClass = [obj class];
                if ([bClass isSubclassOfClass:[NSDictionary class]]) {
                    NSDictionary *dictionary = (NSDictionary*)obj;
                    if (dictionary.count) {
                        Class arrayItemClass = [[self gr_allClassInArray] objectForKey:key];
                        if (!arrayItemClass || arrayItemClass == [NSDictionary class]) {
                            [childObjects addObject:obj];
                        } else {
                            NSObject *child = [[arrayItemClass class] gr_objectFromDictionary:obj];
                            [childObjects addObject:child];
                        }
                    }
                } else if ([bClass isSubclassOfClass:[NSArray class]]) {
                    NSArray *array = (NSArray*)obj;
                    if (array.count) {
                        [childObjects addObject:array];
                    }
                } else {
                    [childObjects addObject:obj];
                }
            }];
            if (childObjects.count) {
                [self setValue:childObjects forKey:key];
            }
        } else if ([value isKindOfClass:[NSNumber class]]) {
            if (klass == [NSNumber class]) {
                [self setValue:value forKey:key];
            } else if (klass == [NSString class]) {
                // if value is NSNumber and property class is NSString,format value to NSString
                [self setValue:[value stringValue] forKey:key];
            }
        } else if ([value isKindOfClass:[NSString class]])   {
            if (klass == [NSString class]) {
                [self setValue:value forKey:key];
            } else if (klass == [NSNumber class]) {
                // if value is NSString and property class is NSNumber,format value to NSNumber
                [self setValue:[NSNumber numberWithDouble:[value doubleValue]] forKey:key];
            } else if (klass == [NSURL class]) {
                // if value is NSString and property class is NSURL,format value to NSURL
                [self setValue:[NSURL URLWithString:value] forKey:key];
            }
        }
    }];
    return self;
}

+ (instancetype)gr_objectFromDictionary:(NSDictionary*)dictionary
{
    return [[[self alloc] init] gr_setDictionary:dictionary];
}

- (__kindof NSObject *)gr_dictionary
{
    if ([self gr_isFromFoundation]) {
        return self;
    }
    
    Class aClass = [self class];
    NSArray *ignoredPropertyNames = [self gr_allIgnoredPropertyNames];
    NSDictionary *replacedPropertyNames = [self gr_allReplacedPropertyNames];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *propertyNames = [GRJSONHelper allPropertyNames:[self class]];
    
    [propertyNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = (NSString*)obj;
        if (ignoredPropertyNames && [ignoredPropertyNames containsObject:obj]) {
            return;
        }
        id value = [self valueForKey:key];
        NSString *dictKey= nil;
        dictKey = [replacedPropertyNames objectForKey:key];
        if (!dictKey) {
            dictKey = key;
        }
        if (value) {
            if ([value isKindOfClass:[NSArray class]]) {
                NSUInteger count = ((NSArray*)value).count;
                if (count) {
                    NSMutableArray *internalItems = [[NSMutableArray alloc] initWithCapacity:count];
                    [value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [internalItems addObject:[obj gr_dictionary]];
                    }];
                    [dic setObject:internalItems forKey:dictKey];
                }
            } else if ([value gr_isFromFoundation]) {
                [dic setObject:value forKey:dictKey];
            } else {
                [dic setObject:[value gr_dictionary] forKey:dictKey];
            }
        } else {
            if ([aClass gr_useNullProperty]) {
                [dic setObject:[NSNull null] forKey:dictKey];
            }
        }
    }];
    return dic;
}

#pragma mark - private

@end

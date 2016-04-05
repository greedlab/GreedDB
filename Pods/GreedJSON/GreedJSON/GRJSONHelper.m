//
//  GreedJSONHelper.h
//  GreedJSON
//
//  Created by Bell on 15/5/19.
//  Copyright (c) 2015年 GreedLab. All rights reserved.
//

#import <objc/runtime.h>
#import "GRJSONHelper.h"
#import "NSObject+GreedJSON.h"

static const char *property_getTypeName(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T') {
            size_t len = strlen(attribute);
            attribute[len - 1] = '\0';
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:len - 2] bytes];
        }
    }
    return "@";
}

static NSSet *__grFoundationClasses;


@implementation GRJSONHelper : NSObject

static NSMutableDictionary <NSString *, NSMutableArray *> *propertyListByClass;
static NSMutableDictionary <NSString *, NSMutableDictionary *> *propertyClassAndPropertyNameByClass;

+ (BOOL)isPropertyReadOnly:(Class)aClass propertyName:(NSString*)propertyName{
    const char * type = property_getAttributes(class_getProperty(aClass, [propertyName UTF8String]));
    NSString * typeString = [NSString stringWithUTF8String:type];
    NSArray * attributes = [typeString componentsSeparatedByString:@","];
    NSString * typeAttribute = [attributes objectAtIndex:1];
    
    return [typeAttribute rangeOfString:@"R"].length > 0;
}

+ (NSMutableArray *)allPropertyNames:(Class)aClass
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    Class theClass = aClass;
    while (theClass && theClass != [NSObject class]) {
        NSArray *theArray = [self propertyNames:theClass];
        [array addObjectsFromArray:theArray];
        theClass = class_getSuperclass(theClass);
    }
    return array;
}

+ (NSArray *)propertyNames:(Class)aClass
{
    if (!aClass || aClass == [NSObject class]) {
        return [NSArray array];
    }
    if (!propertyListByClass) {
        propertyListByClass = [[NSMutableDictionary alloc] init];
    }
    
    NSString *className = NSStringFromClass(aClass);
    NSArray *value = [propertyListByClass objectForKey:className];
    
    if (value) {
        return value;
    }
    
    NSMutableArray *propertyNamesArray = [NSMutableArray array];
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(aClass, &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        
        [propertyNamesArray addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    
    [propertyListByClass setObject:propertyNamesArray forKey:className];
    
    return propertyNamesArray;
}

+ (NSMutableDictionary <NSString *, NSMutableDictionary *> *)allPropertyClassesInClass:(Class)aClass
{
    if (!propertyClassAndPropertyNameByClass) {
        propertyClassAndPropertyNameByClass = [[NSMutableDictionary alloc] init];
    }
    NSString *classKey = NSStringFromClass(aClass);
    NSMutableDictionary *propertyClassByPropertyName = [propertyClassAndPropertyNameByClass objectForKey:classKey];
    if (!propertyClassByPropertyName) {
        propertyClassByPropertyName = [[NSMutableDictionary alloc] init];
        
        unsigned int propertyCount = 0;
        objc_property_t *properties = class_copyPropertyList(aClass, &propertyCount);
        
        for (unsigned int i = 0; i < propertyCount; ++i) {
            objc_property_t property = properties[i];
            const char *name = property_getName(property);
            const char *charClassName = property_getTypeName(property);
            NSString *propertyName = [NSString stringWithUTF8String:name];
            if (charClassName) {
                NSString *className = [NSString stringWithUTF8String:charClassName];
                [propertyClassByPropertyName setObject:className forKey:propertyName];
            } else {
                Class className = [NSNumber class];
                [propertyClassByPropertyName setObject:NSStringFromClass(className) forKey:propertyName];
            }
        }
        [propertyClassAndPropertyNameByClass setObject:propertyClassByPropertyName forKey:classKey];
        free(properties);
    }
    return propertyClassByPropertyName;
}

+ (Class)propertyClassForPropertyName:(NSString *)propertyName ofClass:(Class)aClass
{
    if (!propertyName || !aClass) {
        return nil;
    }
    NSMutableDictionary *propertyClassByPropertyName = [self allPropertyClassesInClass:aClass];
    id value = [propertyClassByPropertyName objectForKey:propertyName];
    if (value) {
        if (value == [NSNull null]) {
            return nil;
        } else {
            return NSClassFromString(value);
        }
    } else {
        return [self propertyClassForPropertyName:propertyName ofClass:class_getSuperclass(aClass)];
    }
}

+ (NSMutableArray*)allIgnoredPropertyNames:(Class)aClass
{
    Class theClass = aClass;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    while (theClass && theClass != [NSObject class]) {
        NSArray *theArray = [theClass gr_ignoredPropertyNames];
        [theArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![array containsObject:obj]) {
                [array addObject:obj];
            }
        }];
        theClass = class_getSuperclass(theClass);
    }
    return array;
}

+ (NSMutableDictionary*)allReplacedPropertyNames:(Class)aClass
{
    Class theClass = aClass;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    while (theClass && theClass != [NSObject class]) {
        NSDictionary *theDictionary = [theClass gr_replacedPropertyNames];
        [theDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if (![dictionary objectForKey:key]) {
                [dictionary setObject:obj forKey:key];
            }
        }];
        theClass = class_getSuperclass(theClass);
    }
    return dictionary;
}

+ (NSMutableDictionary*)allClassInArray:(Class)aClass
{
    Class theClass = aClass;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    while (theClass && theClass != [NSObject class]) {
        NSDictionary *theDictionary = [theClass gr_classInArray];
        [theDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if (![dictionary objectForKey:key]) {
                [dictionary setObject:obj forKey:key];
            }
        }];
        theClass = class_getSuperclass(theClass);
    }
    return dictionary;
}

#pragma mark - Foundation

+ (NSSet *)foundationClasses
{
    if (!__grFoundationClasses) {
        __grFoundationClasses = [NSSet setWithObjects:
                                 [NSURL class],
                                 [NSDate class],
                                 [NSValue class],
                                 [NSData class],
                                 [NSError class],
                                 [NSArray class],
                                 [NSDictionary class],
                                 [NSString class],
                                 [NSAttributedString class], nil];
    }
    return __grFoundationClasses;
}

+ (BOOL)isClassFromFoundation:(Class)aClass
{
    __block BOOL result = NO;
    [[self foundationClasses] enumerateObjectsUsingBlock:^(Class foundationClass, BOOL *stop) {
        if ([aClass isSubclassOfClass:foundationClass]) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}

@end

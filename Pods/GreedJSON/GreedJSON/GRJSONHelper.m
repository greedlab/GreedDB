//
//  GreedJSONHelper.h
//  GreedJSON
//
//  Created by Bell on 15/5/19.
//  Copyright (c) 2015年 GreedLab. All rights reserved.
//

#import <objc/runtime.h>
#import "GRJSONHelper.h"

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

static NSMutableDictionary *propertyListByClass;
static NSMutableDictionary *propertyClassByClassAndPropertyName;

+ (BOOL)isPropertyReadOnly:(Class)klass propertyName:(NSString*)propertyName{
    const char * type = property_getAttributes(class_getProperty(klass, [propertyName UTF8String]));
    NSString * typeString = [NSString stringWithUTF8String:type];
    NSArray * attributes = [typeString componentsSeparatedByString:@","];
    NSString * typeAttribute = [attributes objectAtIndex:1];

    return [typeAttribute rangeOfString:@"R"].length > 0;
}

+ (NSArray *)propertyNames:(Class)klass {
    if (klass == [NSObject class]) {
        return [NSArray array];
    }
	if (!propertyListByClass) {
        propertyListByClass = [[NSMutableDictionary alloc] init];
    }
	
	NSString *className = NSStringFromClass(klass);
	NSArray *value = [propertyListByClass objectForKey:className];
	
	if (value) {
		return value; 
	}
	
	NSMutableArray *propertyNamesArray = [NSMutableArray array];
	unsigned int propertyCount = 0;
	objc_property_t *properties = class_copyPropertyList(klass, &propertyCount);
	
	for (unsigned int i = 0; i < propertyCount; ++i) {
		objc_property_t property = properties[i];
		const char * name = property_getName(property);
		
		[propertyNamesArray addObject:[NSString stringWithUTF8String:name]];
	}
	free(properties);
	
	[propertyListByClass setObject:propertyNamesArray forKey:className];
    NSArray* arr = [GRJSONHelper propertyNames:class_getSuperclass(klass)];
	[propertyNamesArray addObjectsFromArray:arr];
    return propertyNamesArray;
}

+ (Class)propertyClassForPropertyName:(NSString *)propertyName ofClass:(Class)klass {
	if (!propertyClassByClassAndPropertyName) {
        propertyClassByClassAndPropertyName = [[NSMutableDictionary alloc] init];
    }
	
	NSString *key = [NSString stringWithFormat:@"%@:%@", NSStringFromClass(klass), propertyName];
	NSString *value = [propertyClassByClassAndPropertyName objectForKey:key];
	
	if (value) {
		return NSClassFromString(value);
	}
	
	unsigned int propertyCount = 0;
	objc_property_t *properties = class_copyPropertyList(klass, &propertyCount);
	
	const char * cPropertyName = [propertyName UTF8String];
	
	for (unsigned int i = 0; i < propertyCount; ++i) {
		objc_property_t property = properties[i];
		const char * name = property_getName(property);
		if (strcmp(cPropertyName, name) == 0) {
			free(properties);
			NSString *className = [NSString stringWithUTF8String:property_getTypeName(property)];
			[propertyClassByClassAndPropertyName setObject:className forKey:key];
            //we found the property - we need to free
			return NSClassFromString(className);
		}
	}
    free(properties);
    //this will support traversing the inheritance chain
	return [self propertyClassForPropertyName:propertyName ofClass:class_getSuperclass(klass)];
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

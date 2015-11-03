//
//  GRJSONHelper.h
//  GreedJSON
//
//  Created by Bell on 15/5/19.
//  Copyright (c) 2015年 GreedLab. All rights reserved.
//

@interface GRJSONHelper : NSObject

+ (BOOL)isPropertyReadOnly:(Class)klass propertyName:(NSString*)propertyName;
+ (Class)propertyClassForPropertyName:(NSString *)propertyName ofClass:(Class)klass;
+ (NSArray *)propertyNames:(Class)klass;

#pragma mark - Foundation

+ (NSSet *)foundationClasses;
+ (BOOL)isClassFromFoundation:(Class)aClass;

@end

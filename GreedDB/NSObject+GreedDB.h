//
//  NSObject+GreedDB.h
//  GreedDBDemo
//
//  Created by Bell on 15/10/16.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (GreedDB)

+ (id)EntityWithJsonString:(NSString*)jsonString;

@end

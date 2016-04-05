//
//  NSArray+GreedJSON.h
//  GreedJSON
//
//  Created by Bell on 15/5/19.
//  Copyright (c) 2015年 GreedLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (GreedJSON)

/**
 *  format NSArray to NSString
 */
- (NSString*)gr_JSONString;

/**
 *  format NSArray to NSData
 */
- (NSData*)gr_JSONData;

@end

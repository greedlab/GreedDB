//
//  NSDictionary+GreedJSON.h
//  GreedJSON
//
//  Created by Bell on 15/5/19.
//  Copyright (c) 2015年 GreedLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (GreedJSON)

/**
 *  format NSDictionary to NSString
 */
- (NSString*)gr_JSONString;

/**
 *  format NSDictionary to NSData
 */
- (NSData*)gr_JSONData;

@end

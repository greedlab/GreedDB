//
//  GRTestDefaultModel.m
//  Example
//
//  Created by Bell on 15/10/16.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import "GRTestDefaultModel.h"

@implementation GRTestDefaultModel

+ (NSString *)filterForFilter1:(NSString *)filter1 filter2:(NSString *)filter2 {
    return [NSString stringWithFormat:@"%@_%@", filter1 ? filter1 : @"NULL", filter2 ? filter2 : @"NULL"];
}

@end

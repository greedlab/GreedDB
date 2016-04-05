//
//  GRTestDefaultModel.h
//  Example
//
//  Created by Bell on 15/10/16.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRTestDefaultModel : NSObject

@property (nonatomic, strong) NSString *string;
@property (nonatomic, assign) NSInteger integer;

+ (NSString *)filterForFilter1:(NSString *)filter1 filter2:(NSString *)filter2;

@end

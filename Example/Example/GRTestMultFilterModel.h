//
//  GRTestMultFilterModel.h
//  Example
//
//  Created by Bell on 15/10/20.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRTestMultFilterModel : NSObject

@property(nonatomic,strong)NSString *value;

@property(nonatomic,strong)NSString *filter1;
@property(nonatomic,strong)NSString *filter2;
@property(nonatomic,strong)NSString *filter3;
@property(nonatomic,strong)NSString *filter4;

+ (NSString*)valueName;
+ (NSArray*)filterNames;

@end

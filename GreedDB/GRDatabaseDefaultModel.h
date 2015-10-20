//
//  GRDatabaseDefaultModel.h
//  GreedDBDemo
//
//  Created by Bell on 15/10/16.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Default Model
 */
@interface GRDatabaseDefaultModel : NSObject

@property(nonatomic,strong)NSString *key;
@property(nonatomic,strong)id value;
@property(nonatomic,strong)NSDictionary *valueDictionary;

@property(nonatomic,strong)NSString *filter;
@property(nonatomic,assign)long long sort;

- (NSMutableDictionary*)dbDictionary;

@end

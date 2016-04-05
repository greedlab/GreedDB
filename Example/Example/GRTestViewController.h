//
//  GRTestViewController.h
//  GreedDBDemo
//
//  Created by Bell on 15/10/16.
//  Copyright © 2015年 GreedLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GreedDB.h"

@interface GRTestViewController : UIViewController

@property (nonatomic, strong) GRDatabaseDefaultQueue *database;
@property (nonatomic, strong) GRDatabaseMultFilterQueue *multFilterQueue;

@end

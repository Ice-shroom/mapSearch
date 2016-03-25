//
//  CDSearchViewController.h
//  高德地图搜索、
//
//  Created by 千锋 on 16/3/22.
//  Copyright (c) 2016年 ABC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^CDPlaceHandler)(CLLocation *);

@interface CDSearchViewController : UIViewController

@property (nonatomic,copy) CDPlaceHandler handler;

@end

//
//  WZYTabeBarController.m
//  高德地图搜索、
//
//  Created by 千锋 on 16/3/22.
//  Copyright © 2016年 ABC. All rights reserved.
//

#import "WZYTabeBarController.h"
#import "ViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
@interface WZYTabeBarController ()

@end

@implementation WZYTabeBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ViewController * view = [[ViewController alloc] init];
    view.title = @"地图";

    UINavigationController * nav1 = [[UINavigationController alloc] initWithRootViewController:view];
    
    FirstViewController * first = [[FirstViewController alloc] init];
    first.title = @"搜索";
    UINavigationController * nav2 = [[UINavigationController alloc] initWithRootViewController:first];
    
    SecondViewController * second = [[SecondViewController alloc] init];
    second.title = @"运动";
    
    UINavigationController * nav3 = [[UINavigationController alloc] initWithRootViewController:second];
    self.viewControllers = @[nav1,nav2,nav3];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

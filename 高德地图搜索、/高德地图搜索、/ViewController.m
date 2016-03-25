//
//  ViewController.m
//  高德地图搜索、
//
//  Created by 千锋 on 16/3/22.
//  Copyright © 2016年 ABC. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "CDSearchViewController.h"

@interface ViewController ()<MAMapViewDelegate,AMapSearchDelegate>{

    // 地图View
    MAMapView * _mapView;
    // 搜索类
    AMapSearchAPI * _search;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self mapView];
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(doSearch:)];
    [self.navigationItem setRightBarButtonItem:item];
    
    // 天气查询、
    
    [self weatherSearch];
    
}

// 天气查询、
- (void)weatherSearch{

    _search = [[AMapSearchAPI alloc] init];
    
    _search.delegate = self;
    
    AMapWeatherSearchRequest * request = [[AMapWeatherSearchRequest alloc] init];
    /*
     AMapWeatherTypeLive = 1, //<! 实时
     AMapWeatherTypeForecast //<! 预报
     */
    request.type = AMapWeatherTypeLive;
    request.city = @"成都";
    
    // 发起行政区查询、
    [_search AMapWeatherSearch:request];
    NSLog(@"123");
}

// 实现天气查询的回调函数、
- (void)onWeatherSearchDone:(AMapWeatherSearchRequest *)request response:(AMapWeatherSearchResponse *)response{
    if (request.type == AMapWeatherTypeLive) {
        if (response.lives.count == 0) {
            
            NSLog(@"没有请求到天气数据");
        }else{
        
            for (AMapLocalWeatherLive * live in response.lives) {
                
                NSLog(@"%@",live);
                NSLog(@"%@",live.temperature);
            }
        }
    }

}


// POI 搜索、
- (void)search{

    // 初始化搜索对象、
    _search = [[AMapSearchAPI alloc] init];
    
    /// 实现了AMapSearchDelegate协议的类指针
    _search.delegate = self;
    
    // 构造AMaPPOIAroundSearchRequest对象，设置周边请求参数、
    AMapPOIAroundSearchRequest * request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:30.662221 longitude:104.041367];
    // 查询关键字、
    request.keywords = @"蓝光";
    /*
     // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
     // POI的类型共分为20种大类别，分别为：
     // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
     // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
     // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
     */
    request.types = @"汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施";
    
    request.sortrule = 1;
    
    request.requireExtension = YES;
    
    // 发起周边搜索、
    [_search AMapPOIAroundSearch:request];
    
}

// 实现POI搜索对象的回调函数

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if(response.pois.count == 0)
    {
        return;
    }
    
    //通过 AMapPOISearchResponse 对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %ld",response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
    NSString *strPoi = @"";
    for (AMapPOI *p in response.pois) {
        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
    NSLog(@"Place: %@", result);
}

- (void)mapView{

    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    
    // 设置是否显示交通状况
    _mapView.showTraffic = YES;
    
    // 设置用户位置
//    _mapView.showsUserLocation = YES;
    
    // 设置地图视角
    [_mapView setCameraDegree:0 animated:YES duration:2];
    
    // 开启定位开关
    _mapView.showsUserLocation = YES;
    
    // 开启后台定位
    _mapView.pausesLocationUpdatesAutomatically = NO;
    
    _mapView.allowsBackgroundLocationUpdates = YES;
    
    
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
}

// 当位置更新的时候 会进行位置的回调、
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{

    if(updatingLocation){
    
        NSLog(@"位置发生改变");
        
        /*
         MAUserTrackingModeFollowWithHeading：跟随用户的位置和角度移动。
         MAUserTrackingModeNone：仅在地图上显示，不跟随用户位置。
         MAUserTrackingModeFollow：跟随用户位置移动，并将定位点设置成地图中心点。
         */
        
        [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
        
    }
    
}


- (void) doSearch:(UIBarButtonItem *) sender {
    CDSearchViewController *searchVC = [[CDSearchViewController alloc] init];
    searchVC.handler = ^(CLLocation *loc) {
        [_mapView setRegion:MACoordinateRegionMakeWithDistance(loc.coordinate, 1000, 2000) animated:YES];
    };
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

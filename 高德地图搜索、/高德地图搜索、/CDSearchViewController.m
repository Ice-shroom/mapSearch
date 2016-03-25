//
//  CDSearchViewController.m
//  高德地图搜索、
//
//  Created by 千锋 on 16/3/22.
//  Copyright (c) 2016年 ABC. All rights reserved.
//

#import "CDSearchViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>

@interface CDSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,AMapSearchDelegate>{

    UITableView * _myTableView;
    
    NSMutableArray * _dataArray;
    
    AMapSearchAPI * _searchAPI;
}

@end

@implementation CDSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建一个查询结构对象、
    _searchAPI = [[AMapSearchAPI alloc] init];
    _searchAPI.delegate = self;
    
    // 创建一个TableView
    _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
    [self.view addSubview:_myTableView];
    
    UISearchBar * mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    
    mySearchBar.showsCancelButton = YES;
    
    mySearchBar.delegate = self;
    
    // 将搜索框 放在TableView的头部、
    [_myTableView setTableHeaderView:mySearchBar];

}

#pragma mark --- UISearchBarDelegate回调方法、
// 搜索按钮被点击时 调用的方法、
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    // 从搜索栏得到搜索关键字
    NSString * keyWord = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (keyWord.length > 0) {
        
        // 创建一个地点搜索请求对象、
        AMapInputTipsSearchRequest * request = [[AMapInputTipsSearchRequest alloc] init];
        
        // 设置请求的关键字、
        request.keywords = keyWord;
        
//        @property (nonatomic, copy)   NSString *city; //!< 查询城市，可选值：cityname（中文或中文全拼）、citycode、adcode.
        
        // 发出地点请求
        [_searchAPI AMapInputTipsSearch:request];
        
        
    }
    [searchBar resignFirstResponder];
    
}

#pragma mark -- AMapSearchDelegate回调方法

// 地点查询完毕  调用的方法、

//- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
//
//    if (!_dataArray) {
//        _dataArray = [NSMutableArray array];
//    }else{
//    
//        [_dataArray removeAllObjects];
//    }
//    //AMapInputTipsSearchRequest对象的pois属性是一个数组、
//    for (<#type *object#> in <#collection#>) {
//        <#statements#>
//    }
//    
//    
//}

- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response{
    
        if (!_dataArray) {
            _dataArray = [NSMutableArray array];
        }else{
    
            [_dataArray removeAllObjects];
        }
        //AMapInputTipsSearchRequest对象的pois属性是一个数组、
        for (AMapPOI * tempPOI in response.tips) {
            [_dataArray addObject:tempPOI];
        }
    
    [_myTableView reloadData];
    
}


#pragma mark UITableViewDataSource回调方法
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    
    AMapPOI *model = _dataArray[indexPath.row];
    cell.textLabel.text = model.name;
    
    return cell;
}

#pragma mark UITableViewDelegate回调方法

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AMapPOI *model = _dataArray[indexPath.row];
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:model.location.latitude longitude:model.location.longitude];
    // 通过Block实现反向传值
    if (_handler) {
        _handler(loc);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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

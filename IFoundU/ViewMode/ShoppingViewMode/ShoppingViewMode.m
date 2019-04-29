//
//  ShoppingViewMode.m
//  IFoundU
//
//  Created by Tom-Li on 2019/4/17.
//  Copyright © 2019 litong. All rights reserved.
//

#import "ShoppingViewMode.h"

// 百度地图
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface ShoppingViewMode() <BMKPoiSearchDelegate, CLLocationManagerDelegate> {
    
    CLLocationManager *_locationmanager;//定位服务
    NSString *_currentCity;//当前城市
}
@property (nonatomic, strong) BMKPoiSearch *poiSearch;
@property (nonatomic, strong) BMKPOICitySearchOption *cityOption;
@end

@implementation ShoppingViewMode

+ (instancetype)share {
    static dispatch_once_t onceToken;
    static ShoppingViewMode *shoppingViewMode;
    dispatch_once(&onceToken, ^{
        shoppingViewMode = [[ShoppingViewMode alloc]init];
    });
    return shoppingViewMode;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.poiSearch = [[BMKPoiSearch alloc] init];
        self.poiSearch.delegate = self;
        
        [self initMapParams];
    }
    return self;
}

- (void)poiSearchInCity {
    self.cityOption.keyword = self.storeString;
    self.cityOption.city = [self.cityOption.city stringByAppendingString:self.districtString];
    [self.poiSearch poiSearchInCity:self.cityOption];
}

- (void)poiResearchInCity:(NSInteger)pageIndex {
    [self.cityOption setPageIndex: pageIndex];
    [self.poiSearch poiSearchInCity:self.cityOption];
}

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPOISearchResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    //BMKSearchErrorCode错误码，BMK_SEARCH_NO_ERROR：检索结果正常返回
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSLog(@"检索结果返回成功：%lu",  (unsigned long)poiResult.poiInfoList.count);
        NSMutableArray *tempResultArray = [NSMutableArray array];
        for (NSUInteger i = 0; i < poiResult.poiInfoList.count; i ++) {
            //POI信息类的实例
            BMKPoiInfo *POIInfo = poiResult.poiInfoList[i];
            //初始化标注类BMKPointAnnotation的实例
            [tempResultArray addObject:@{@"addr": POIInfo.address == nil ? @"" : POIInfo.address, @"name": POIInfo.name == nil ? @"" : POIInfo.name, @"phone": POIInfo.phone == nil ? @"" : POIInfo.phone, @"distance": POIInfo.direction == nil ? @"" : POIInfo.direction, @"province": POIInfo.province == nil ? @"" : POIInfo.province, @"city": POIInfo.city == nil ? @"" : POIInfo.city, @"area": POIInfo.area == nil ? @"" : POIInfo.area, @"detailInfo": POIInfo.detailInfo.distance == 0 ? @"-1" : [NSString stringWithFormat:@"%ld", POIInfo.detailInfo.distance], @"latitude": [NSString stringWithFormat:@"%0.6f", POIInfo.pt.latitude], @"longtitude": [NSString stringWithFormat:@"%0.6f", POIInfo.pt.longitude]}];
            
        }
        
        self.resultArray = tempResultArray.copy;
        
    }
    else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD) {
        NSLog(@"检索词有歧义");
    } else {
        NSLog(@"其他检索结果错误码相关处理");
    }
//    _isRefreshing = NO;
}

- (void)initMapParams {
    //初始化请求参数类BMKCitySearchOption的实例
    self.cityOption = [[BMKPOICitySearchOption alloc] init];
    //检索关键字，必选。举例：小吃
    //    self.cityOption.keyword = @"小吃";
    //区域名称(市或区的名字，如北京市，海淀区)，最长不超过25个字符，必选
    self.cityOption.city = @"深圳市";
    //检索分类，可选，与keyword字段组合进行检索，多个分类以","分隔。举例：美食,烧烤,酒店
    //    self.cityOption.tags = @[@"美食",@"烧烤"];
    //区域数据返回限制，可选，为YES时，仅返回city对应区域内数据
    self.cityOption.isCityLimit = YES;
    //POI检索结果详细程度
    //cityOption.scope = BMK_POI_SCOPE_BASIC_INFORMATION;
    //检索过滤条件，scope字段为BMK_POI_SCOPE_DETAIL_INFORMATION时，filter字段才有效
    //cityOption.filter = filter;
    //分页页码，默认为0，0代表第一页，1代表第二页，以此类推
    self.cityOption.pageIndex = 0;
    //单次召回POI数量，默认为10条记录，最大返回20条
    self.cityOption.pageSize = 5;
}

@end

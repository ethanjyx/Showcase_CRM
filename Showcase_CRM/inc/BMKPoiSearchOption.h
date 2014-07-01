/*
 *  BMKPoiSearchOption.h
 *  BMapKit
 *
 *  Copyright 2013 Baidu Inc. All rights reserved.
 *
 */
#import <Foundation/Foundation.h>
#import "BMKTypes.h"
/// 检索基础信息类，所有类型Poi检索的基类
@interface BMKBasePoiSearchOption : NSObject
{
    NSString        *_keyword;
    int             _pageIndex;
    int             _pageCapacity;
}
///搜索关键字
@property (nonatomic, retain) NSString *keyword;
///分页索引，可选，默认为0
@property (nonatomic, assign) int      pageIndex;
///分页数量，可选，默认为10，最多为50
@property (nonatomic, assign) int      pageCapacity;
@end

///本地云检索参数信息类
@interface BMKCitySearchOption : BMKBasePoiSearchOption {
    NSString        *_city;
}
///区域名称(市或区的名字，如北京市，海淀区)，必选, 必须最长25个字符
@property (nonatomic, retain) NSString *city;
@end

///周边云检索参数信息类
@interface BMKNearbySearchOption : BMKBasePoiSearchOption {
    CLLocationCoordinate2D        _location;
    int             _radius;
}
///检索的中心点，经纬度
@property (nonatomic, assign) CLLocationCoordinate2D location;
///周边检索半径
@property (nonatomic, assign) int      radius;
@end

///矩形云检索参数信息类
@interface BMKBoundSearchOption : BMKBasePoiSearchOption {
    CLLocationCoordinate2D _leftBottom;
    CLLocationCoordinate2D _rightTop;
    
}
///矩形区域，左下角和右上角的经纬度坐标点。
@property (nonatomic, assign) CLLocationCoordinate2D leftBottom;
@property (nonatomic, assign) CLLocationCoordinate2D rightTop;
@end



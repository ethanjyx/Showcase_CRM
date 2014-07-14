//
//  MapViewController.m
//  Showcase_CRM
//
//  Created by Logic Solutions on 7/2/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()
- (IBAction)returnButton:(id)sender;
- (IBAction)locateButton:(id)sender;

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Init View for BaiduMap
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, 1024, 724)];
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(31.023884, 121.437449);
    _mapView.centerCoordinate = coor;
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    
    // Add search bar on map view
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(112, 34, 800, 44)];
    [self.view addSubview:searchBar];
    
    // Init and start location service
    _locService = [[BMKLocationService alloc] init];
    [_locService startUserLocationService];
    
    // Create table view for pin annotation
    NSArray *list = [NSArray arrayWithObjects:@"姓名：张军",@"地址：东川路800号",@"电话：18933012031",@"公司：上海电力有限公司",@"签到次数：7次",@"",@"                        签到", nil];
    self.dataList = list;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 300, 400) style:UITableViewStylePlain];
    // 设置tableView的数据源
    tableView.dataSource = self;
    // 设置tableView的委托
    tableView.delegate = self;
    self.myTableView = tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
    }
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [self.dataList objectAtIndex:row];
    //cell.imageView.image = [UIImage imageNamed:@"green.png"];
    //cell.detailTextLabel.text = @"详细信息";
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}

- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

- (void) viewDidAppear:(BOOL)animated {
    NSLog(@"viewDidAppear called");
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = 31.023884;
    coor.longitude = 121.537449;
    annotation.coordinate = coor;
    //annotation.title = @"这里是北京";
    [_mapView addAnnotation:annotation];
}
 
// Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    NSLog(@"viewForAnnotation called");
    /*
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        return newAnnotationView;
    }
    return nil;
    */
    
    //NSString *AnnotationViewID = [NSString stringWithFormat:@"renameMark%d",i];
    NSString *AnnotationViewID = [NSString stringWithFormat:@"viewID"];
    
    BMKPinAnnotationView *newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    // 设置颜色
    ((BMKPinAnnotationView*)newAnnotation).pinColor = BMKPinAnnotationColorPurple;
    // 从天上掉下效果
    ((BMKPinAnnotationView*)newAnnotation).animatesDrop = YES;
    // 设置可拖拽
    ((BMKPinAnnotationView*)newAnnotation).draggable = YES;
    //设置大头针图标
    //((BMKPinAnnotationView*)newAnnotation).image = [UIImage imageNamed:@"zhaohuoche"];
    
    /*
    UIView *popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 300)];
    popView.backgroundColor = [UIColor whiteColor];
    [popView addSubview:self.myTableView];

    //设置弹出气泡图片
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wenzi"]];
    image.frame = CGRectMake(0, 0, 100, 60);
    [popView addSubview:image];
    //自定义显示的内容
    UILabel *driverName = [[UILabel alloc]initWithFrame:CGRectMake(0, 3, 100, 20)];
    driverName.text = @"张XX师傅";
    //driverName.backgroundColor = [UIColor clearColor];
    driverName.font = [UIFont systemFontOfSize:14];
    driverName.textColor = [UIColor blackColor];
    driverName.textAlignment = NSTextAlignmentCenter;
    [popView addSubview:driverName];
    
    UILabel *carName = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, 100, 20)];
    carName.text = @"京A123456";
    //carName.backgroundColor = [UIColor clearColor];
    carName.font = [UIFont systemFontOfSize:14];
    carName.textColor = [UIColor blackColor];
    carName.textAlignment = NSTextAlignmentCenter;
    [popView addSubview:carName];
    */
    
    BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:self.myTableView];
    //pView.backgroundColor = [UIColor whiteColor];
    pView.frame = CGRectMake(0, 0, 300, 400);
    pView.layer.borderWidth = 1;
    pView.layer.borderColor = [[UIColor blackColor] CGColor];
    ((BMKPinAnnotationView*)newAnnotation).paopaoView = nil;
    ((BMKPinAnnotationView*)newAnnotation).paopaoView = pView;
    //i++;
    
    return newAnnotation;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)returnButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)locateButton:(id)sender {
    _mapView.showsUserLocation = YES; // 显示定位图层
    [_mapView setCenterCoordinate:_locService.userLocation.location.coordinate animated:YES];
}

@end
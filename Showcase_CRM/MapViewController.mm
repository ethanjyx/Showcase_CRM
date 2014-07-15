//
//  MapViewController.m
//  Showcase_CRM
//
//  Created by Logic Solutions on 7/2/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import "MapViewController.h"
#import "DatabaseInterface.h"
#import "Contact.h"
#import "Address.h"

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
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(31.023722, 121.437416);
    _mapView.centerCoordinate = coord;
    [self.view addSubview:_mapView];
    
    // Add search bar on map view
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(112, 34, 800, 44)];
    [self.view addSubview:searchBar];
    
    // Init and start location service
    _locService = [[BMKLocationService alloc] init];
    [_locService startUserLocationService];
    
    // Init containers
    self.geocodeSearchs = [[NSMutableArray alloc] init];
    self.dataLists = [[NSMutableArray alloc] init];
    self.tableViews = [[NSMutableArray alloc] init];
    self.annotations = [[NSMutableArray alloc] init];
    
    // Init Geocoder then convert street address to latitude and longitude
    DatabaseInterface *database = [DatabaseInterface databaseInterface];
    self.contacts = [database getAllContacts];
    for (int i = 0; i < [self.contacts count]; i++) {
        BMKGeoCodeSearch* geocodesearch = [[BMKGeoCodeSearch alloc] init];
        geocodesearch.delegate = self;
        [self.geocodeSearchs addObject:geocodesearch];
        BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc] init];
        Contact *contact = [self.contacts objectAtIndex:i];
        Address *address = contact.address;
        //NSLog(@"country:%@, province:%@, city:%@, street:%@, postal:%@", address.country, address.province, address.city, address.street, address.postal);
        geocodeSearchOption.city= address.city;
        geocodeSearchOption.address = address.street;
        BOOL flag = [geocodesearch geoCode:geocodeSearchOption];
        if (flag) {
            NSLog(@"geo检索发送成功");
        }   else {
            NSLog(@"geo检索发送失败");
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dataLists objectAtIndex:0] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
    }
    NSUInteger row = [indexPath row];
    NSUInteger index = [self.tableViews indexOfObject:tableView];
    cell.textLabel.text = [[self.dataLists objectAtIndex:index] objectAtIndex:row];
    //cell.imageView.image = [UIImage imageNamed:@"green.png"];
    //cell.detailTextLabel.text = @"详细信息";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath indexAtPosition:1] == 6) {
        NSUInteger index = [self.tableViews indexOfObject:tableView];
        BMKPointAnnotation *annotation = [self.annotations objectAtIndex:index];
        CLLocationCoordinate2D clientCoord = annotation.coordinate;
        CLLocationCoordinate2D userCoord = _locService.userLocation.location.coordinate;
        float latitudeDiff = fabs(clientCoord.latitude - userCoord.latitude);
        float longitudeDiff = fabs(clientCoord.longitude - userCoord.longitude);
        NSString *msg;
        if (latitudeDiff >= 0.001 || longitudeDiff >= 0.001) {
            msg = @"距离过远，签到失败!";
        } else {
            // update checkin times
            msg = @"签到成功！";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
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

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
	if (error == 0) {
        NSUInteger index = [self.geocodeSearchs indexOfObject:searcher];
        //NSLog(@"index: %lu", (unsigned long)index);
        
        Contact *contact = [self.contacts objectAtIndex:index];
        Address *address = contact.address;
        
        //NSLog(@"corresponding address: %@", address.street);
        //NSLog(@"result: %@", result.address);
        
        NSString *nameStr = [[NSString alloc] initWithFormat:@"姓名：%@%@", contact.lastname, contact.firstname];
        NSString *addressStr = [[NSString alloc] initWithFormat:@"地址：%@", address.street];
        NSString *cellphoneStr = [[NSString alloc] initWithFormat:@"电话：%@", contact.phone_mobile];
        NSString *companyStr = [[NSString alloc] initWithFormat:@"公司：%@", contact.company.name];
        NSString *checkinStr = [[NSString alloc] initWithFormat:@"签到次数：0次"];
        
        NSArray *dataList = [NSArray arrayWithObjects:nameStr, addressStr, cellphoneStr, companyStr, checkinStr, @"", @"                        签到", nil];
        [self.dataLists addObject:dataList];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 400) style:UITableViewStylePlain];
        // 设置tableView的数据源
        tableView.dataSource = self;
        // 设置tableView的委托
        tableView.delegate = self;
        [self.tableViews addObject:tableView];
        
        BMKPointAnnotation* pinAnnotation = [[BMKPointAnnotation alloc] init];
		pinAnnotation.coordinate = result.location;
        [self.annotations addObject:pinAnnotation];
        [_mapView addAnnotation:pinAnnotation];
        
        /*
        NSString* titleStr;
        NSString* showmeg;
        
        titleStr = @"正向地理编码";
        showmeg = [NSString stringWithFormat:@"经度:%f,纬度:%f", pinAnnotation.coordinate.latitude, pinAnnotation.coordinate.longitude];
        
        NSLog(@"%@ %@", titleStr, showmeg);
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [myAlertView show];
        */
	} else {
        NSLog(@"Geocode search fail!");
    }
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
    //_geocodesearch.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    for (int i = 0; i < [self.geocodeSearchs count]; i++) {
        BMKGeoCodeSearch* geocodesearch = [self.geocodeSearchs objectAtIndex:i];
        geocodesearch.delegate = nil;
    }
}

// Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    /*
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        return newAnnotationView;
    }
    return nil;
    */
    
    NSString *AnnotationViewID = [NSString stringWithFormat:@"viewID"];
    BMKPinAnnotationView *annotaionView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    
    // 设置颜色
    ((BMKPinAnnotationView*)annotaionView).pinColor = BMKPinAnnotationColorPurple;
    // 从天上掉下效果
    ((BMKPinAnnotationView*)annotaionView).animatesDrop = YES;
    // 设置可拖拽
    //((BMKPinAnnotationView*)newAnnotation).draggable = YES;
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
    
    NSUInteger index = [self.annotations indexOfObject:annotation];
    UITableView *tableView = [self.tableViews objectAtIndex:index];
    BMKActionPaopaoView *paopaoView = [[BMKActionPaopaoView alloc]initWithCustomView:tableView];
    paopaoView.frame = CGRectMake(0, 0, 300, 400);
    paopaoView.layer.borderWidth = 1;
    paopaoView.layer.borderColor = [[UIColor blackColor] CGColor];
    ((BMKPinAnnotationView*)annotaionView).paopaoView = nil;
    ((BMKPinAnnotationView*)annotaionView).paopaoView = paopaoView;
    
    return annotaionView;
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
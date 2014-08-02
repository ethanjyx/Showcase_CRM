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
#import "RouteplanningViewController.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface RouteAnnotation : BMKPointAnnotation
{
	int _type; // 0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
	int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;

@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;

@end

@interface UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

@end

@implementation UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
	CGSize rotatedSize;
    
    rotatedSize.width = width;
    rotatedSize.height = height;
    
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	CGContextRotateCTM(bitmap, degrees * M_PI / 180);
	CGContextRotateCTM(bitmap, M_PI);
	CGContextScaleCTM(bitmap, -1.0, 1.0);
	CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

@end

@interface MapViewController ()
- (IBAction)returnButton:(id)sender;
- (IBAction)locateButton:(id)sender;
- (IBAction)startNav:(id)sender;
- (IBAction)endNav:(id)sender;
- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomOut:(id)sender;

- (void)calculateVisitOrder:(NSArray *)indicator;
- (void)genPerms:(NSMutableArray *)queue Stack:(NSMutableArray *)stack Distances:(int **)distances Size:(int)size;

@end

@implementation MapViewController

- (NSString*)getMyBundlePath1:(NSString *)filename
{
	
	NSBundle * libBundle = MYBUNDLE ;
	if ( libBundle && filename ){
		NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
		return s;
	}
	return nil;
}

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
    _mapView.showsUserLocation = YES; // 显示定位图层
    //[self.view addSubview:_mapView];
    [self.view insertSubview:_mapView atIndex:0];
    
    // Add search bar on map view
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(112, 40, 800, 44)];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 800, 44)];
    //self.searchBar.showsCancelButton = YES;
    self.searchBar.placeholder = @"请输入客户姓名";
    self.searchBar.delegate = self;
    [searchBarView addSubview:self.searchBar];
    [self.view addSubview:searchBarView];
    
    // Init search display controller
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchController.delegate = self;
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.searchDataList = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", nil];
    
    // Add buttons on map view
    self.startNavButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.startNavButton.frame = CGRectMake(60, 620, 80, 40);
    [self.startNavButton.layer setMasksToBounds:YES];
    //[self.startNavButton setCornerRadius:10.0];
    [self.startNavButton.layer setBorderWidth:1.0];
    self.startNavButton.backgroundColor = [UIColor whiteColor];
    [self.startNavButton setTitle:@"开始导航" forState:UIControlStateNormal];
    [self.startNavButton addTarget:self action:@selector(startNav:) forControlEvents:UIControlEventTouchUpInside];
    [self.startNavButton setEnabled:NO];
    [self.view addSubview:self.startNavButton];
    
    self.endNavButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.endNavButton.frame = CGRectMake(140, 620, 80, 40);
    [self.endNavButton.layer setMasksToBounds:YES];
    //[self.endNavButton.layer setCornerRadius:10.0];
    [self.endNavButton.layer setBorderWidth:1.0];
    self.endNavButton.backgroundColor = [UIColor whiteColor];
    [self.endNavButton setTitle:@"停止" forState:UIControlStateNormal];
    [self.endNavButton addTarget:self action:@selector(endNav:) forControlEvents:UIControlEventTouchUpInside];
    [self.endNavButton setEnabled:NO];
    [self.view addSubview:self.endNavButton];
    
    self.zoomInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.zoomInButton.frame = CGRectMake(900, 620, 40, 40);
    [self.zoomInButton.layer setMasksToBounds:YES];
    //[self.zoomInButton.layer setCornerRadius:10.0];
    [self.zoomInButton.layer setBorderWidth:1.0];
    self.zoomInButton.backgroundColor = [UIColor whiteColor];
    [self.zoomInButton setTitle:@"+" forState:UIControlStateNormal];
    [self.zoomInButton addTarget:self action:@selector(zoomIn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.zoomInButton];
    
    self.zoomOutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.zoomOutButton.frame = CGRectMake(940, 620, 40, 40);
    [self.zoomOutButton.layer setMasksToBounds:YES];
    //[self.zoomOutButton.layer setCornerRadius:10.0];
    [self.zoomOutButton.layer setBorderWidth:1.0];
    self.zoomOutButton.backgroundColor = [UIColor whiteColor];
    [self.zoomOutButton setTitle:@"-" forState:UIControlStateNormal];
    [self.zoomOutButton addTarget:self action:@selector(zoomOut:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.zoomOutButton];
    
    // Init and start location service
    _locService = [[BMKLocationService alloc] init];
    [_locService startUserLocationService];
    
    // Init route search
    _routesearch = [[BMKRouteSearch alloc]init];
    
    // Init members
    DatabaseInterface *database = [DatabaseInterface databaseInterface];
    self.contacts = [[NSMutableArray alloc] initWithArray:[database getAllContacts]];
    self.geocodeSearchs = [[NSMutableArray alloc] init];
    self.dataLists = [[NSMutableArray alloc] init];
    self.tableViews = [[NSMutableArray alloc] init];
    self.annotations = [[NSMutableArray alloc] init];
    self.visitOrder = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.contacts count]; i++) {
        [self.dataLists addObject:[NSNull null]];
        [self.tableViews addObject:[NSNull null]];
        [self.annotations addObject:[NSNull null]];
    }
    self.visitedNum = 0;
    self.minDistance = INT_MAX;
    
    // Init Geocoder then convert street address to latitude and longitude
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    _routesearch.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _routesearch.delegate = nil;
    for (int i = 0; i < [self.geocodeSearchs count]; i++) {
        BMKGeoCodeSearch* geocodesearch = [self.geocodeSearchs objectAtIndex:i];
        geocodesearch.delegate = nil;
    }
    for (int i = 0; i < [self.tableViews count]; i++) {
        UITableView* tableView = [self.tableViews objectAtIndex:i];
        if (tableView != [NSNull null]) {
            tableView.delegate = nil;
        }
    }
}


/* search bar function */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchTerm=[searchBar text];
    for (int i = 0; i < [self.contacts count]; i++) {
        Contact *contact = [self.contacts objectAtIndex:i];
        NSString *fullname = [[NSString alloc] initWithFormat:@"%@%@", contact.lastname, contact.lastname];
        if ([searchTerm isEqualToString:fullname] || [searchTerm isEqualToString:contact.lastname] || [searchTerm isEqualToString:contact.firstname]) {
            BMKPointAnnotation* annotation = [self.annotations objectAtIndex:i];
            [_mapView setCenterCoordinate:annotation.coordinate animated:YES];
            [_mapView selectAnnotation:annotation animated:YES];
            searchBar.text=@"";
            break;
        }
    }
    [self.searchController setActive:NO];
}


/* search display controller function */
- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
    [tableView setFrame:CGRectMake(112, 0, 800, 400)];
    tableView.layer.borderWidth = 1;
    tableView.layer.borderColor = [[UIColor blackColor] CGColor];
}


/* table view functions */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchDataList count];
    } else {
        return 7;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [self.searchDataList objectAtIndex:[indexPath row]];
    } else {
        NSUInteger row = [indexPath row];
        NSUInteger index = [self.tableViews indexOfObject:tableView];
        cell.textLabel.text = [[self.dataLists objectAtIndex:index] objectAtIndex:row];
        //cell.imageView.image = [UIImage imageNamed:@"green.png"];
        //cell.detailTextLabel.text = @"详细信息";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSLog(@"selected");
    } else {
        if ([indexPath indexAtPosition:1] == 6) {
            NSUInteger index = [self.tableViews indexOfObject:tableView];
            BMKPointAnnotation *annotation = [self.annotations objectAtIndex:index];
            BMKMapPoint clientCoord = BMKMapPointForCoordinate(annotation.coordinate);
            BMKMapPoint userCoord = BMKMapPointForCoordinate(_locService.userLocation.location.coordinate);
            CLLocationDistance distance = BMKMetersBetweenMapPoints(clientCoord,userCoord);
            NSString *msg;
            //NSLog(@"distance:%f", distance);
            if (distance > 1500) {
                msg = @"距离过远，签到失败!";
            } else {
                // update checkin times
                msg = @"签到成功！";
                Contact *contact = [self.contacts objectAtIndex:index];
                NSNumber *updated_sign_up_times = [[NSNumber alloc] initWithInt:contact.sign_up_times.intValue + 1];
                contact.sign_up_times = updated_sign_up_times;
                DatabaseInterface *database = [DatabaseInterface databaseInterface];
                [database editContact:contact];
                [self.contacts replaceObjectAtIndex:index withObject:contact];
                NSMutableArray *datalist = [self.dataLists objectAtIndex:index];
                NSString *checkinStr = [[NSString alloc] initWithFormat:@"签到次数：%i次", [updated_sign_up_times intValue]];
                [datalist replaceObjectAtIndex:4 withObject:checkinStr];
                [self.dataLists replaceObjectAtIndex:index withObject:datalist];
                [tableView reloadData];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


/* location service functions */
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


/* geo-coder function */
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
	if (error == 0) {
        NSUInteger index = [self.geocodeSearchs indexOfObject:searcher];
        //NSLog(@"index: %lu", (unsigned long)index);
        
        Contact *contact = [self.contacts objectAtIndex:index];
        Address *address = contact.address;
        
        //NSLog(@"corresponding address: %@", address.street);
        //NSLog(@"result: %@", result.address);
        
        NSString *nameStr = [[NSString alloc] initWithFormat:@"姓名：%@ %@", contact.firstname, contact.lastname];
        NSString *addressStr = [[NSString alloc] initWithFormat:@"地址：%@", address.street];
        NSString *cellphoneStr = [[NSString alloc] initWithFormat:@"电话：%@", contact.phone_mobile];
        NSString *companyStr = [[NSString alloc] initWithFormat:@"公司：%@", contact.company.name];
        NSString *checkinStr = [[NSString alloc] initWithFormat:@"签到次数：%i次", [contact.sign_up_times intValue]];
        
        NSMutableArray *dataList = [NSMutableArray arrayWithObjects:nameStr, addressStr, cellphoneStr, companyStr, checkinStr, @"", @"                        签到", nil];
        [self.dataLists replaceObjectAtIndex:index withObject:dataList];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 400) style:UITableViewStylePlain];
        // 设置tableView的数据源
        tableView.dataSource = self;
        // 设置tableView的委托
        tableView.delegate = self;
        [self.tableViews replaceObjectAtIndex:index withObject:tableView];
        
        BMKPointAnnotation* pinAnnotation = [[BMKPointAnnotation alloc] init];
		pinAnnotation.coordinate = result.location;
        [self.annotations replaceObjectAtIndex:index withObject:pinAnnotation];
        [_mapView addAnnotation:pinAnnotation];
	} else {
        NSLog(@"Geocode search fail!");
    }
}


/* map view functions */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
		return [self getRouteAnnotationView:mapView viewForAnnotation:(RouteAnnotation*)annotation];
	} else {
        NSString *AnnotationViewID = [NSString stringWithFormat:@"viewID"];
        BMKPinAnnotationView *annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        
        // 设置颜色
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorPurple;
        // 从天上掉下效果
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
        // 设置可拖拽
        ((BMKPinAnnotationView*)annotationView).draggable = YES;
        //设置大头针图标
        //((BMKPinAnnotationView*)newAnnotation).image = [UIImage imageNamed:@"zhaohuoche"];
        
        NSUInteger index = [self.annotations indexOfObject:annotation];
        UITableView *tableView = [self.tableViews objectAtIndex:index];
        BMKActionPaopaoView *paopaoView = [[BMKActionPaopaoView alloc]initWithCustomView:tableView];
        paopaoView.frame = CGRectMake(0, 0, 300, 400);
        paopaoView.layer.borderWidth = 1;
        paopaoView.layer.borderColor = [[UIColor blackColor] CGColor];
        ((BMKPinAnnotationView*)annotationView).paopaoView = nil;
        ((BMKPinAnnotationView*)annotationView).paopaoView = paopaoView;
        CGPoint offset = CGPointMake(0.0, 200.0);
        ((BMKPinAnnotationView*)annotationView).calloutOffset = offset;
        
        return annotationView;
    }
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
	if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
	return nil;
}


/* search drive route functions */
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
	array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
    
	if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
		int size = [plan.steps count];
		int planPointCounts = 0;
		for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
            }
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
        }
        // 通过points构建BMKPolyline
		BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
		[_mapView addOverlay:polyLine]; // 添加路线overlay
		delete []temppoints;
        
        // enable buttons for navigation
        [self.startNavButton setEnabled:YES];
        [self.endNavButton setEnabled:YES];
	} else {
        NSLog(@"route search failed!");
    }
}

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
	BMKAnnotationView* view = nil;
	switch (routeAnnotation.type) {
		case 0:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 1:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 2:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 3:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 4:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
				view.canShowCallout = TRUE;
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
			view.annotation = routeAnnotation;
			
		}
			break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
				view.canShowCallout = TRUE;
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
			view.annotation = routeAnnotation;
        }
            break;
		default:
			break;
	}
	
	return view;
}


/* route planning view controller delegate function */
- (void)onGetselectedContacts:(NSArray *)indicator; {
    [self calculateVisitOrder:indicator];
    
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = _locService.userLocation.location.coordinate;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    NSMutableArray *wayPoints = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.visitOrder count]; i++) {
        //Contact *contact = [self.contacts objectAtIndex:[[indexs objectAtIndex:i] intValue]];
        BMKPointAnnotation *annotation = [self.annotations objectAtIndex:[[self.visitOrder objectAtIndex:i] intValue]];
        if (i == [self.visitOrder count] - 1) {
            //end.name = contact.address.street;
            //end.cityName = contact.address.city;
            end.pt = annotation.coordinate;
        } else {
            BMKPlanNode *wayPoint = [[BMKPlanNode alloc] init];
            //wayPoint.name = contact.address.street;
            //wayPoint.cityName = contact.address.city;
            wayPoint.pt = annotation.coordinate;
            [wayPoints addObject:wayPoint];
        }
    }
    
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    drivingRouteSearchOption.wayPointsArray = wayPoints;
    BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
    if(flag)
    {
        NSLog(@"route检索发送成功");
    }
    else
    {
        NSLog(@"route检索发送失败");
    }
}


/* alert delegate function */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //NSLog(@"button index: %ld", (long)buttonIndex);
    if (buttonIndex == 0) {
        NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
        [_mapView removeAnnotations:array];
        array = [NSArray arrayWithArray:_mapView.overlays];
        [_mapView removeOverlays:array];
        
        self.visitedNum = 0;
        self.minDistance = INT_MAX;
        [self.startNavButton setTitle:@"开始导航" forState:UIControlStateNormal];
        [self.startNavButton setEnabled:NO];
        [self.endNavButton setEnabled:NO];
        
        for (BMKPointAnnotation* annotation in self.annotations) {
            [_mapView addAnnotation:annotation];
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIStoryboardPopoverSegue *popoverSegue = (UIStoryboardPopoverSegue *) segue;
    RouteplanningViewController *newViewController = [segue destinationViewController];
    newViewController.delegate = self;
    newViewController.mypopoverController = popoverSegue.popoverController;
}


/* map view member functions */
- (IBAction)returnButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)locateButton:(id)sender {
    [_mapView setCenterCoordinate:_locService.userLocation.location.coordinate animated:YES];
}

- (IBAction)startNav:(id)sender {
    //初始化调启导航时的参数管理类
    BMKNaviPara* para = [[BMKNaviPara alloc]init];
    //指定导航类型
    para.naviType = BMK_NAVI_TYPE_WEB;
        
    CLLocationCoordinate2D current, next;
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
        
    if (self.visitedNum == 0) {
        [self.startNavButton setTitle:@"继续导航" forState:UIControlStateNormal];
        current = _locService.userLocation.location.coordinate;
        BMKPointAnnotation* annotation = [self.annotations firstObject];
        next = annotation.coordinate;
    } else {
        BMKPointAnnotation* annotation1 = [self.annotations objectAtIndex:self.visitedNum - 1];
        BMKPointAnnotation* annotation2 = [self.annotations objectAtIndex:self.visitedNum];
        current = annotation1.coordinate;
        next = annotation2.coordinate;
    }
        
    start.pt = current;
    end.pt = next;
    para.startPoint = start;
    para.endPoint = end;
    para.appName = [NSString stringWithFormat:@"%@", @"Showcase_CRM"];
        
    //调启web导航
    [BMKNavigation openBaiduMapNavigation:para];
    self.visitedNum++;
    
    if (self.visitedNum == [self.visitOrder count]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"到达终点，导航结束！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
        [_mapView removeAnnotations:array];
        array = [NSArray arrayWithArray:_mapView.overlays];
        [_mapView removeOverlays:array];
        
        self.visitedNum = 0;
        self.minDistance = INT_MAX;
        [self.startNavButton setTitle:@"开始导航" forState:UIControlStateNormal];
        [self.startNavButton setEnabled:NO];
        [self.endNavButton setEnabled:NO];
        
        for (BMKPointAnnotation* annotation in self.annotations) {
            [_mapView addAnnotation:annotation];
        }
    }
}

- (IBAction)endNav:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定停止导航？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
}

- (IBAction)zoomIn:(id)sender {
    _mapView.zoomLevel++;
}

- (IBAction)zoomOut:(id)sender {
    _mapView.zoomLevel--;
}

- (void)calculateVisitOrder:(NSArray *)indicator {
    NSMutableArray *indexs = [[NSMutableArray alloc] init];
    for (int i = 0; i < [indicator count]; i++) {
        if ([[indicator objectAtIndex:i] intValue] == 1) {
            [indexs addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    int** distances = (int **) malloc((1 + [indexs count]) * sizeof(int *));
    for (int i = 0; i < 1 + [indexs count]; i++) {
        distances[i] = (int *) malloc((1 + [indexs count]) * sizeof(int));
    }
    BMKMapPoint userCoord = BMKMapPointForCoordinate(_locService.userLocation.location.coordinate);
    for (int i = 0; i < 1 + [indexs count]; i++) {
        for (int j = 0; j < 1 + [indexs count]; j++) {
            if (i == j) {
                distances[i][j] = 0;
            } else if (i == [indexs count]) {
                BMKPointAnnotation *annotation = [self.annotations objectAtIndex:j];
                BMKMapPoint clientCoord = BMKMapPointForCoordinate(annotation.coordinate);
                CLLocationDistance distance = BMKMetersBetweenMapPoints(clientCoord,userCoord);
                distances[i][j] = distance;
            } else if (j == [indexs count]) {
                BMKPointAnnotation *annotation = [self.annotations objectAtIndex:i];
                BMKMapPoint clientCoord = BMKMapPointForCoordinate(annotation.coordinate);
                CLLocationDistance distance = BMKMetersBetweenMapPoints(clientCoord,userCoord);
                distances[i][j] = distance;
            } else {
                BMKPointAnnotation *annotation1 = [self.annotations objectAtIndex:i];
                BMKMapPoint clientCoord1 = BMKMapPointForCoordinate(annotation1.coordinate);
                BMKPointAnnotation *annotation2 = [self.annotations objectAtIndex:j];
                BMKMapPoint clientCoord2 = BMKMapPointForCoordinate(annotation2.coordinate);
                CLLocationDistance distance = BMKMetersBetweenMapPoints(clientCoord1,clientCoord2);
                distances[i][j] = distance;
            }
        }
    }
    
    /*
     for (int i = 0; i < 1 + [indexs count]; i++) {
     for (int j = 0; j < 1 + [indexs count]; j++) {
     printf("distance between %i and %i is: %i\n", i, j, distances[i][j]);
     }
     }
     */
    
    self.minDistance = INT_MAX;
    NSMutableArray *stack = [[NSMutableArray alloc] init];
    NSMutableArray *queue = [[NSMutableArray alloc] init];
    for (int i = 0; i < [indexs count]; i++) {
        [queue addObject:[NSNumber numberWithInt:i]];
    }
    [self genPerms:queue Stack:stack Distances:distances Size:[indexs count]];
    
    for (int i = 0; i < 1 + [indexs count]; i++) {
        free(distances[i]);
    }
    free(distances);
}

- (void)genPerms:(NSMutableArray *)queue Stack:(NSMutableArray *)stack Distances:(int **)distances Size:(int)size {
    if ([queue count] == 0) {
        int current = size;
        int distance = 0;
        for (int i = 0; i < [stack count]; i++) {
            int next = [[stack objectAtIndex:i] intValue];
            distance += distances[current][next];
            current = [[stack objectAtIndex:i] intValue];
        }
        if (distance < self.minDistance) {
            self.minDistance = distance;
            self.visitOrder = [[NSArray alloc] initWithArray:stack];
            /*
             printf("min distance: %i\n", self.minDistance);
             printf("visit order: ");
             for (int i = 0; i < [stack count]; i++) {
             printf("%i", [[stack objectAtIndex:i] intValue]);
             }
             printf("\n");
             */
        }
        return;
    }
    for (int i = 0; i < size; i++) {
        NSNumber *front = [queue firstObject];
        [stack addObject:front];
        [queue removeObjectAtIndex:0];
        [self genPerms:queue Stack:stack Distances:distances Size:size];
        NSNumber *top = [stack lastObject];
        [queue addObject:top];
        [stack removeObjectAtIndex:[stack count] - 1];
    }
}

@end

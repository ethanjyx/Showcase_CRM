//
//  MapViewController.h
//  Showcase_CRM
//
//  Created by Logic Solutions on 7/2/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "RouteplanningViewController.h"

@interface MapViewController : UIViewController <BMKMapViewDelegate, BMKLocationServiceDelegate, UITableViewDataSource, UITableViewDelegate, BMKGeoCodeSearchDelegate, UISearchBarDelegate, RouteplanningViewControllerDelegate, BMKRouteSearchDelegate, UIAlertViewDelegate> {
    BMKMapView* _mapView;
    BMKLocationService* _locService;
    BMKRouteSearch* _routesearch;
}

@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UIButton *startNavButton;
@property (nonatomic, retain) UIButton *endNavButton;
@property (nonatomic, retain) UIButton *zoomInButton;
@property (nonatomic, retain) UIButton *zoomOutButton;
@property (nonatomic, retain) NSMutableArray *geocodeSearchs;
@property (nonatomic, retain) NSMutableArray *contacts;
@property (nonatomic, retain) NSMutableArray *dataLists;
@property (nonatomic, retain) NSMutableArray *tableViews;
@property (nonatomic, retain) NSMutableArray *annotations;
@property (nonatomic, retain) NSArray *visitOrder;
@property (nonatomic, assign) int visitedNum;
@property (nonatomic, assign) int minDistance;

@end

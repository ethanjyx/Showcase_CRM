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
#import "NSDictionary+MutableDeepCopy.h"
#import "ContactNearbyViewController.h"

@interface MapViewController : UIViewController <BMKMapViewDelegate, BMKLocationServiceDelegate, UITableViewDataSource, UITableViewDelegate, BMKGeoCodeSearchDelegate, UISearchBarDelegate, RouteplanningViewControllerDelegate,ContactNearbyViewControllerDelegate, BMKRouteSearchDelegate, UIAlertViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate> {
    BMKMapView* _mapView;
    BMKLocationService* _locService;
    BMKRouteSearch* _routesearch;
}

@property (nonatomic,retain) UISearchDisplayController *searchController;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) NSMutableDictionary *names;
@property (nonatomic, retain) NSMutableDictionary *mutableNames;
@property (nonatomic, retain) NSMutableArray *mutableKeys;
@property (nonatomic, retain) UIButton *startNavButton;
@property (nonatomic, retain) UIButton *endNavButton;
@property (nonatomic, retain) UIButton *zoomInButton;
@property (nonatomic, retain) UIButton *zoomOutButton;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) NSMutableArray *geocodeSearchs;
@property (nonatomic, retain) NSMutableArray *contacts;
@property (nonatomic, retain) NSMutableArray *dataLists;
@property (nonatomic, retain) NSMutableArray *tableViews;
@property (nonatomic, retain) NSMutableArray *annotations;
@property (nonatomic, retain) NSArray *visitOrder;
@property (nonatomic, assign) int visitedNum;
@property (nonatomic, assign) int minDistance;
@property (nonatomic, retain) IBOutlet UITableView *NearContacttableview;
@property (nonatomic, retain) NSMutableArray *nearContactdata;
@property (nonatomic, retain) UIButton *confirmButton;

@end

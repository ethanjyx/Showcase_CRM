//
//  MapViewController.h
//  Showcase_CRM
//
//  Created by Logic Solutions on 7/2/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface MapViewController : UIViewController <BMKMapViewDelegate, BMKLocationServiceDelegate, UITableViewDataSource, UITableViewDelegate, BMKGeoCodeSearchDelegate, UISearchBarDelegate> {
    BMKMapView* _mapView;
    BMKLocationService* _locService;
}

@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) NSMutableArray *geocodeSearchs;
@property (nonatomic, retain) NSMutableArray *contacts;
@property (nonatomic, retain) NSMutableArray *dataLists;
@property (nonatomic, retain) NSMutableArray *tableViews;
@property (nonatomic, retain) NSMutableArray *annotations;

@end
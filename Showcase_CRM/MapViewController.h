//
//  MapViewController.h
//  Showcase_CRM
//
//  Created by Logic Solutions on 7/2/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface MapViewController : UIViewController <BMKMapViewDelegate, BMKLocationServiceDelegate, UITableViewDataSource, UITableViewDelegate> {
    BMKMapView* _mapView;
    BMKLocationService* _locService;
}

@property (nonatomic, retain) NSArray *dataList;
@property (nonatomic, retain) UITableView *myTableView;

@end

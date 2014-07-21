//
//  RouteplanningViewController.h
//  Showcase_CRM
//
//  Created by Logic Solutions on 7/21/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteplanningViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *datalist;
@property (nonatomic, retain) NSArray *contacts;

@end
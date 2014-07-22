//
//  RouteplanningViewController.h
//  Showcase_CRM
//
//  Created by Logic Solutions on 7/21/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RouteplanningViewController;

@protocol RouteplanningViewControllerDelegate <NSObject>
- (void)onGetselectedContacts:(NSArray *)indicator;

@end

@interface RouteplanningViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <RouteplanningViewControllerDelegate> delegate;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *datalist;
@property (nonatomic, retain) NSArray *contacts;
@property (nonatomic, retain) NSMutableArray *indicator;
@property (nonatomic, retain) UIPopoverController *mypopoverController;

@end

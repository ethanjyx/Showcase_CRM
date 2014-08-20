//
//  ContactNearbyViewController.h
//  Showcase_CRM
//
//  Created by user on 14-8-15.
//  Copyright (c) 2014年 Linfeng Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactNearbyViewController;

@protocol ContactNearbyViewControllerDelegate<NSObject>

-(void)selecteddistance:(NSString*)distance;

@end

@interface ContactNearbyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) NSString *distance;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *datalist;
@property (nonatomic, retain) UIPopoverController *mypopoverController;
@property (nonatomic, weak) id<ContactNearbyViewControllerDelegate> delegate;


@end

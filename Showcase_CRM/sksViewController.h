//
//  ViewController.h
//  SKSTableView
//
//  Created by Sakkaras on 26/12/13.
//  Copyright (c) 2013 Sakkaras. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"
#import "Company.h"
#import "SplitViewSelectionDelegate.h"

@interface sksViewController : UIViewController <SKSTableViewDelegate, SplitViewSelectionDelegate>

@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *industryType;
@property (weak, nonatomic) IBOutlet UILabel *website;
@property (weak, nonatomic) IBOutlet UILabel *CompanyName;
@property (nonatomic, assign) IBOutlet SKSTableView *tableView;

@property (nonatomic, strong) Company *company;

@end

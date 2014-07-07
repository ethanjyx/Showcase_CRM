//
//  ViewController.h
//  SKSTableView
//
//  Created by Sakkaras on 26/12/13.
//  Copyright (c) 2013 Sakkaras. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"

@interface sksViewController : UIViewController <SKSTableViewDelegate>

@property (nonatomic, assign) IBOutlet SKSTableView *tableView;

@end

//
//  ViewController.h
//  Showcase_CRM
//
//  Created by Linfeng Shi on 6/10/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "TKPeoplePickerController.h"

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate, TKPeoplePickerControllerDelegate> {
    
}
@property(nonatomic,retain) NSMutableDictionary *states;
@property(nonatomic,retain) NSArray *datasource;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

-(void)setupArray;
- (IBAction)showPeoplePicker:(id)sender;

@end


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
#import "NSDictionary+MutableDeepCopy.h"
#import "SplitViewSelectionDelegate.h"

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate, TKPeoplePickerControllerDelegate, UISearchBarDelegate> {
    
}


@property (retain,nonatomic) NSMutableDictionary *names;
@property (retain,nonatomic) NSMutableDictionary *mutableNames;
@property (retain,nonatomic) NSMutableArray *mutableKeys;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UISearchBar *search;


@property (nonatomic, assign) id<SplitViewSelectionDelegate> delegate;
@property (weak, nonatomic) IBOutlet UISegmentedControl *Segment;
@property (weak, nonatomic) IBOutlet UIButton *CompanyButton;
@property (weak, nonatomic) IBOutlet UIButton *ContactButton;

- (void)setupNames;
- (void)updateTable;
- (IBAction)showPeoplePicker:(id)sender;

- (IBAction)SegmentControl:(id)sender;
- (IBAction)switchview:(id)sender;

@end
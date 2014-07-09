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

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate, TKPeoplePickerControllerDelegate, UISearchBarDelegate> {
    
}

@property(nonatomic,retain) NSArray *fetchedCompaniesArray;
@property (retain,nonatomic) NSMutableDictionary *names;
@property (retain,nonatomic) NSMutableDictionary *mutableNames;
@property (retain,nonatomic) NSMutableArray *mutableKeys;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *search;


-(void)setupNames;
- (IBAction)showPeoplePicker:(id)sender;

@end
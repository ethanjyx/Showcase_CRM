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

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate, UISearchBarDelegate,TKPeoplePickerControllerDelegate> {
    
}
//@property(nonatomic,retain) NSArray *fetchedCompaniesArray;
//@property(nonatomic,retain) NSArray *fetchedContacts;

@property (strong,nonatomic) NSDictionary *names;
@property (strong,nonatomic) NSMutableDictionary *mutableNames;
@property (strong,nonatomic) NSMutableArray *mutableKeys;
//@property(nonatomic,retain) NSArray *datasource;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *search;

-(void)resetSearch;
//重置搜索，即恢复到没有关键字的状态

-(void)handleSearchForTerm: (NSString*)searchTerm;
//处理搜索，把不包含searchTerm的值从可变数组中去除

//-(void)setupArray;
- (IBAction)showPeoplePicker:(id)sender;

@end


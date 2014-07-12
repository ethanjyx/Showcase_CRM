//
//  ViewController.m
//  SKSTableView
//
//  Created by Sakkaras on 26/12/13.
//  Copyright (c) 2013 Sakkaras. All rights reserved.
//

#import "sksViewController.h"
#import "SKSTableView.h"
#import "SKSTableViewCell.h"
#import "Industry.h"

@interface sksViewController ()

@property (nonatomic, strong) NSArray *contents;

@end

@implementation sksViewController

@synthesize phone,industryType,website,CompanyName,company;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//
//- (NSArray *)contents
//{
//    if (!_contents) {
//        
//    }
//    
//    return _contents;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.SKSTableViewDelegate = self;
    
    
    _contents = @[
                  /*@[
                      @[@"公司详细信息", @"Row0_Subrow1",@"Row0_Subrow2"]
                      ],*/
                  @[
                      @[@"地址信息", @"开单地址", @"收货地址"]
                      ],
                  @[
                      @[@"联系人信息", @"Row1_Subrow1", @"Row1_Subrow2", @"Row1_Subrow3", @"Row1_Subrow4", @"Row1_Subrow5", @"Row1_Subrow6", @"Row1_Subrow7", @"Row1_Subrow8", @"Row1_Subrow9", @"Row1_Subrow10", @"Row1_Subrow11", @"Row1_Subrow12"]
                      ],
                  @[
                      @[@"业务进程", @"Row1_Subrow1", @"Row1_Subrow2", @"Row1_Subrow3"]
                      ],
                  @[
                      @[@"活动历史", @"Row1_Subrow1"]
                      ]
                  ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.contents count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contents[section] count];
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.contents[indexPath.section][indexPath.row] count] - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SKSTableViewCell";
    
    SKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = self.contents[indexPath.section][indexPath.row][0];
    
    //NSLog(@"%@", cell.textLabel.text);
    
    //if ((indexPath.section == 0 && (indexPath.row == 1 || indexPath.row == 0)) || (indexPath.section == 1 && (indexPath.row == 0 || indexPath.row == 2)))
    
    cell.isExpandable = YES; // will call setIsExpandable
    //else
        // cell.isExpandable = NO;
    
    return cell;
}

// called in SKSTableView.m to create cell for subRows
- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.contents[indexPath.section][indexPath.row][indexPath.subRow]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // add button as subView to control subRow
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [editButton addTarget:self
               action:@selector(aMethod:)
     forControlEvents:UIControlEventTouchUpInside];
    [editButton setTitle:@"Edit" forState:UIControlStateNormal];
    editButton.frame = CGRectMake(500, 0, 160.0, 40.0); // x, y, width, height
    [cell.contentView addSubview:editButton];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [deleteButton addTarget:self
                   action:@selector(aMethod:)
         forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    deleteButton.frame = CGRectMake(540, 0, 160.0, 40.0); // x, y, width, height
    [cell.contentView addSubview:deleteButton];
    
//    UIView *buttonViews = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 232)];
//    [buttonViews addSubview:editButton];
//    [buttonViews addSubview:deleteButton];
//    cell.accessoryView = buttonViews;
    
    return cell;
}

-(void)setSelectedCompany:(Company *)comp {
    _contents = @[
                  /*@[
                      @[@"公司详细", comp.name, @"Row0_Subrow2"]
                      ],*/
                  @[
                      @[@"地址信息", @"开单地址", @"收货地址"]
                      ],
                  @[
                      @[@"联系人信息", @"Row1_Subrow1", @"Row1_Subrow2", @"Row1_Subrow3", @"Row1_Subrow4", @"Row1_Subrow5", @"Row1_Subrow6", @"Row1_Subrow7", @"Row1_Subrow8", @"Row1_Subrow9", @"Row1_Subrow10", @"Row1_Subrow11", @"Row1_Subrow12"]
                      ],
                  @[
                      @[@"业务进程", @"Row1_Subrow1", @"Row1_Subrow2", @"Row1_Subrow3"]
                      ],
                  @[
                      @[@"活动历史", @"Row1_Subrow1"]
                      ]
                  ];
    
    //NSLog(@"%@", _contents[0][0][1]);
    
    [self.tableView reloadData];
    //NSLog(@"%@", _contents[0][0][0]);
}

@end

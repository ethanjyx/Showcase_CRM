//
//  ContactNearbyViewController.m
//  Showcase_CRM
//
//  Created by user on 14-8-15.
//  Copyright (c) 2014年 Linfeng Shi. All rights reserved.
//

#import "ContactNearbyViewController.h"

@interface ContactNearbyViewController ()

@end

@implementation ContactNearbyViewController
@synthesize datalist;
@synthesize delegate;
@synthesize distance;
@synthesize mypopoverController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //mypopoverController.popoverContentSize=CGSizeMake(300, 300);
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 150,250) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.datalist = [[NSMutableArray alloc] init];
    [self.datalist addObject:@"1 km以内"];
    [self.datalist addObject:@"2 km以内"];
    [self.datalist addObject:@"3 km以内"];
    [self.datalist addObject:@"5 km以内"];
    [self.datalist addObject:@"10 km以内"];
    [self.datalist addObject:@"全部"];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [datalist count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [datalist objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    distance = [datalist objectAtIndex:indexPath.row];
    
    //Create a variable to hold the color, making its default
    //color something annoying and obvious so you can see if
    //you've missed a case here.
    if ([self.delegate respondsToSelector:@selector(selecteddistance:)]) {
        [self.delegate selecteddistance:self.distance];
    }
    [self.mypopoverController dismissPopoverAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

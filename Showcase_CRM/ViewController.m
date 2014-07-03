//
//  ViewController.m
//  Showcase_CRM
//
//  Created by Linfeng Shi on 6/10/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//
#import "ViewController.h"
#import "DetailViewController.h"
#import "UIImage+TKUtilities.h"
#import "DatabaseInterface.h"
#import "Company.h"

#define thumbnailSize 75
@implementation ViewController
@synthesize scrollView = _scrollView;
@synthesize tableView = _tableView;
@synthesize fetchedCompaniesArray;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidLoad
{
    [self setupArray];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setTitle:@"Contacts"];
    //[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showPeoplePicker:)] autorelease]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)setupArray{
    DatabaseInterface *database = [DatabaseInterface databaseInterface];
    fetchedCompaniesArray = [database getAllCompanies];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    //TODO: consider adjust this value later
    return [fetchedCompaniesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //---------- CELL BACKGROUND IMAGE -----------------------------
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];
    UIImage *image = [UIImage imageNamed:@"LightGrey@2x.png"];
    imageView.image = image;
    cell.backgroundView = imageView;
    [[cell textLabel] setBackgroundColor:[UIColor clearColor]];
    [[cell detailTextLabel] setBackgroundColor:[UIColor clearColor]];
    
    Company *oneCompany = [fetchedCompaniesArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = oneCompany.name;
    
    //Arrow
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /*DetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
    detail.state = [datasource objectAtIndex:indexPath.row];
    detail.capital = [states objectForKey:detail.state];
    [self.navigationController pushViewController:detail animated:YES];*/
    
}

//------------------TableView Cell Height------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



- (IBAction)showPeoplePicker:(id)sender
{
    TKPeoplePickerController *controller = [[[TKPeoplePickerController alloc] initPeoplePicker] autorelease];
    controller.actionDelegate = self;
    controller.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - TKContactsMultiPickerControllerDelegate

- (void)tkPeoplePickerController:(TKPeoplePickerController*)picker didFinishPickingDataWithInfo:(NSArray*)contacts
{
    
    [self dismissModalViewControllerAnimated:YES];
    for (id view in self.scrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]])
            [(UIButton*)view removeFromSuperview];
    }
    
    [contacts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TKContact *contact = (TKContact*)obj;
        
        //TODO: add new contacts to database and reload
        //[states setObject:contact.firstName forKey:contact.name];
        
        NSLog(@"%@", contact.name);
    }];
    
    [self.tableView reloadData];
}

- (void)tkPeoplePickerControllerDidCancel:(TKPeoplePickerController*)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
    [_tableView release];
    [_tableView release];
    [super dealloc];
}
@end
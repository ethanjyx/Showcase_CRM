//
//  RouteplanningViewController.m
//  Showcase_CRM
//
//  Created by Logic Solutions on 7/21/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import "RouteplanningViewController.h"
#import "DatabaseInterface.h"
#import "Hanzi2Pinyin.h"

@interface RouteplanningViewController ()
- (IBAction)confirmButton:(id)sender;

- (BOOL)isAddressEmpty:(Address *) address;

@end

@implementation RouteplanningViewController

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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 600, 600) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    DatabaseInterface *database = [DatabaseInterface databaseInterface];
    self.contacts = [[NSMutableArray alloc] initWithArray:[database getAllContacts]];
    self.datalist = [[NSMutableArray alloc] init];
    self.emptyAddressIndicator = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.contacts count]; i++) {
        [self.emptyAddressIndicator addObject:[NSNumber numberWithInt:0]];
    }
    
    for (int i = 0; i < [self.contacts count]; i++) {
        Contact *contact = [self.contacts objectAtIndex:i];
        NSString *name;
        NSString *company;
        NSString *phone = [[NSString alloc] initWithFormat:@"电话: %@", contact.phone_mobile];
        phone = [phone stringByPaddingToLength:18 withString:@" " startingAtIndex:0];
        
        if ([Hanzi2Pinyin hasChineseCharacter:contact.lastname] == YES) {
            name = [[NSString alloc] initWithFormat:@"%@ %@", contact.lastname, contact.firstname];
            if ([contact.firstname length] == 0) {
                name = [name stringByPaddingToLength:16 withString:@" " startingAtIndex:0];
            } else if ([contact.firstname length] == 1) {
                name = [name stringByPaddingToLength:15 withString:@" " startingAtIndex:0];
            } else {
                name = [name stringByPaddingToLength:15 withString:@" " startingAtIndex:0];
            }
        } else {
            name = [[NSString alloc] initWithFormat:@"%@ %@", contact.firstname, contact.lastname];
            name = [name stringByPaddingToLength:16 withString:@" " startingAtIndex:0];
        }
        
        if (contact.company == nil) {
            company = @"公司:";
        } else {
            company = [[NSString alloc] initWithFormat:@"公司: %@", contact.company.name];
        }
        
        NSString *contactInfo = [[NSString alloc] initWithFormat:@"%@ %@ %@", name, phone, company];
        [self.datalist addObject:contactInfo];
        if ([self isAddressEmpty:contact.address] == YES) {
            [self.emptyAddressIndicator replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:1]];
        }
    }
    [self.view addSubview:self.tableView];
    
    self.selectionIndicator = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.contacts count]; i++) {
        [self.selectionIndicator addObject:[NSNumber numberWithInt:0]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.datalist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
    }
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [self.datalist objectAtIndex:row];
    cell.textLabel.font = [UIFont fontWithName:@"Courier" size:16];
    if ([[self.emptyAddressIndicator objectAtIndex:row] intValue] == 1) {
        cell.userInteractionEnabled = NO;
        cell.textLabel.enabled = NO;
    }
    //cell.imageView.image = [UIImage imageNamed:@"green.png"];
    //cell.detailTextLabel.text = @"详细信息";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = [indexPath indexAtPosition:1];
    if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark) {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        [self.selectionIndicator replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:0]];
    } else {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectionIndicator replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:1]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (IBAction)confirmButton:(id)sender {
    for (NSNumber *num in self.selectionIndicator) {
        if ([num intValue] == 1) {
            if ([self.delegate respondsToSelector:@selector(onGetselectedContacts:)]) {
                [self.delegate onGetselectedContacts:self.selectionIndicator];
            }
            [self.mypopoverController dismissPopoverAnimated:YES];
            return;
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请至少选择一个客户！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (BOOL)isAddressEmpty:(Address *)address {
    if ([address.street isEqualToString:@""] || [address.city isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

@end

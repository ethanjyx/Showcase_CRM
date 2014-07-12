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
#import "DatabaseInterface.h"
#import "AddContactViewController.h"

@interface sksViewController ()

@property (nonatomic, strong) NSMutableArray *contents;
- (void)updateContents;
- (void)addContact;
@end

@implementation sksViewController {
    Company *globalCompany;
}

@synthesize phone,industryType,website,CompanyName,company;
@synthesize contents;

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

    self.tableView.SKSTableViewDelegate = self;
    
    DatabaseInterface *database = [DatabaseInterface databaseInterface];
    globalCompany = [database fetchCompanyByName:company];
    
    phone.text = globalCompany.phone;
    CompanyName.text = globalCompany.name;
    website.text = globalCompany.website;
    Industry *industry = globalCompany.industry;
    industryType.text = industry.industry_type;
    //NSMutableArray *contents = [NSMutableArray array];
    
    
    contents = @[
                  @[
                      @[@"地址信息", @"开单地址", @"收货地址"]
                      ],
                  @[
                      @[@"联系人信息"]
                      ],
                  @[
                      @[@"业务进程"]
                      ],
                  @[
                      @[@"活动历史"]
                      ]
                  ];
    //[self updateContents];
}

- (void)updateContents
{
    NSSet *contacts = globalCompany.contacts;
    NSSortDescriptor *contactDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastname" ascending:YES];
    NSArray *contactDescriptors = @[contactDescriptor];
    NSArray *sortedContacts = [contacts sortedArrayUsingDescriptors:contactDescriptors];
    NSMutableArray *sortedContactNames = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[sortedContacts count]; i++) {
        Contact *oneContact = sortedContacts[i];
        NSString *name = [NSString stringWithFormat:@"%@%@", oneContact.firstname, oneContact.lastname];
        NSLog(@"%@", name);
        [sortedContactNames addObject:name];
        NSMutableArray *contact1 = contents[1][0];
        [contact1 addObject:name];
        contents[1][0] = contact1;
    }
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
    
    if ([contents[indexPath.section][indexPath.row] count] == 1)
        cell.isExpandable = NO; // will call setIsExpandable
    else
        cell.isExpandable = YES;
    
    
    if (indexPath.section == 1) {

        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
        [addButton addTarget:self
                      action:@selector(addContact)
            forControlEvents:UIControlEventTouchUpInside];
        [addButton setTitle:@"Add" forState:UIControlStateNormal];
        addButton.frame = CGRectMake(500, 0, 160.0, 40.0); // x, y, width, height
        [cell.contentView addSubview:addButton];
    }
    
    
    
    return cell;
}

- (void)addContact
{
    [self performSegueWithIdentifier: @"addContactSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addContactSegue"]) {
        AddContactViewController *addContact = segue.destinationViewController;
        addContact.company = company;
    }
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
    contents = @[
                  @[
                      @[@"地址信息", @"开单地址", @"收货地址"]
                      ],
                  @[
                      @[@"联系人信息"]
                      ],
                  @[
                      @[@"业务进程"]
                      ],
                  @[
                      @[@"活动历史"]
                      ]
                  ];
    [self.tableView reloadData];
}

@end

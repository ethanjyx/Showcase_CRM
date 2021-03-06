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
#import "AddProjectViewController.h"
#import "AddEventViewController.h"
#import "DetailContact2ViewController.h"
#import "ViewBillingAddressController.h"
#import "ViewShippingAddressController.h"
#import "Project.h"
#import "Event.h"
#import "EditProjectViewController.h"
#import "EditEventViewController.h"
#import "BillAddressViewController.h"
#import "ShippingAddressViewController.h"
#import "Hanzi2Pinyin.h"
#import "Contact.h"
#import "EditCompanyViewController.h"

@interface sksViewController ()

@property (nonatomic, strong) NSArray *contents;
- (void)updateContents;
- (void)initButtons;
- (void)addContact;
- (void)importContacts;
- (void)generateExportView;
- (void)finishExport;
- (void)cancelExport;
- (void)exportEndsViewChange;
- (void)addProject;
- (void)addEvent;



// a wrap-up helper function to perform the click on indexPath at this customized tableview
- (void)performClickOnRowAtIndexPath:(NSIndexPath*) indexPath;
- (void)updateUI;
@end

@implementation sksViewController {
    Company *globalCompany;
    Contact *globalSelectedContact;
    Project *globalSelectedProject;
    Event *globalSelectedEvent;
    NSMutableArray *allContacts;
    NSMutableArray *allProjects;
    NSMutableArray *allEvents;
    NSMutableSet* selectedContactsForExport;
    bool exportingContact;
    UIButton* createContactButton;
    UIButton* importContactButton;
    UIButton* exportContactButton;
    UIButton* exportSaveButton;
    UIButton* exportCancelButton;
    UIButton* addProjectButton;
    UIButton* addEventButton;
}

@synthesize phone,industryType,website,CompanyName,company;
@synthesize contents;
@synthesize nnn;

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
    //nnn=[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 1, 104, 500)];
   // [nnn drawRect:CGRectMake(0, 1, 104, 500)];
    nnn.frame=CGRectMake(0, 0, 768, 73);
    //nnn.translucent= NO;
   //nnn.backgroundColor=[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];


    self.tableView.SKSTableViewDelegate = self;
    
    DatabaseInterface *database = [DatabaseInterface databaseInterface];
    globalCompany = [database fetchCompanyByName:company];
    
    phone.text = globalCompany.phone;
    CompanyName.text = globalCompany.name;
    website.text = globalCompany.website;
    Industry *industry = globalCompany.industry;
    industryType.text = industry.industry_type;
    allContacts = [[NSMutableArray alloc] init];
    allProjects = [[NSMutableArray alloc] init];
    allEvents = [[NSMutableArray alloc] init];
    selectedContactsForExport = [[NSMutableSet alloc] init];
    
    exportingContact = false;
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
    [self updateContents];
    [self initButtons];
    [self performSelector:@selector(updateUI) withObject:nil afterDelay:0.0];
}

- (void)updateUI
{
    for (int i = 0; i < 4; ++i) {
        [self performClickOnRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:i]];
    }

}

- (void)updateContents
{
    NSSet *contacts = globalCompany.contacts;
    NSSortDescriptor *contactDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastname" ascending:YES];
    NSArray *contactDescriptors = @[contactDescriptor];
    NSArray *localContacts = [contacts sortedArrayUsingDescriptors:contactDescriptors];
    NSArray *sortedContacts = [localContacts sortedArrayUsingComparator:^NSComparisonResult(Contact* a, Contact* b) {
        
        NSString *first = [NSString stringWithFormat:@"%@%@",a.lastname, a.firstname];
        NSString *second = [NSString stringWithFormat:@"%@%@",b.lastname, b.firstname];
        
        if ([Hanzi2Pinyin hasChineseCharacter:first]) {
            first = [Hanzi2Pinyin convert:first];
            first = [NSString stringWithFormat:@"%@%@%@",[first substringToIndex:1] ,@" ", [first substringFromIndex:1]];
        }
        if ([Hanzi2Pinyin hasChineseCharacter:second]) {
            second = [Hanzi2Pinyin convert:second];
            second = [NSString stringWithFormat:@"%@%@%@",[second substringToIndex:1] ,@" ", [second substringFromIndex:1]];
        }
        return [first compare:second];
    }];
    allContacts = [NSMutableArray arrayWithArray:sortedContacts];
    
    
    
    NSSet *projects = globalCompany.projects;
    NSSortDescriptor *contactDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *contactDescriptors2 = @[contactDescriptor2];
    NSArray *localProjects = [projects sortedArrayUsingDescriptors:contactDescriptors2];
    NSArray *sortedProjects = [localProjects sortedArrayUsingComparator:^NSComparisonResult(Project* a, Project* b) {
        
        NSString *first = a.name;
        NSString *second = b.name;
        
        if ([Hanzi2Pinyin hasChineseCharacter:first]) {
            first = [Hanzi2Pinyin convert:first];
            first = [NSString stringWithFormat:@"%@%@%@",[first substringToIndex:1] ,@" ", [first substringFromIndex:1]];
        }
        if ([Hanzi2Pinyin hasChineseCharacter:second]) {
            second = [Hanzi2Pinyin convert:second];
            second = [NSString stringWithFormat:@"%@%@%@",[second substringToIndex:1] ,@" ", [second substringFromIndex:1]];
        }
        return [first compare:second];
    }];
    allProjects = [NSMutableArray arrayWithArray:sortedProjects];
    
    
    
    
    
    NSSet *events = globalCompany.events;
    NSSortDescriptor *contactDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *contactDescriptors3 = @[contactDescriptor3];
    NSArray *localEvents = [events sortedArrayUsingDescriptors:contactDescriptors3];
    NSArray *sortedEvents = [localEvents sortedArrayUsingComparator:^NSComparisonResult(Event* a, Event* b) {
        
        NSString *first = a.name;
        NSString *second = b.name;
        
        if ([Hanzi2Pinyin hasChineseCharacter:first]) {
            first = [Hanzi2Pinyin convert:first];
            first = [NSString stringWithFormat:@"%@%@%@",[first substringToIndex:1] ,@" ", [first substringFromIndex:1]];
        }
        if ([Hanzi2Pinyin hasChineseCharacter:second]) {
            second = [Hanzi2Pinyin convert:second];
            second = [NSString stringWithFormat:@"%@%@%@",[second substringToIndex:1] ,@" ", [second substringFromIndex:1]];
        }
        return [first compare:second];
    }];
    allEvents = [NSMutableArray arrayWithArray:sortedEvents];
}

- (void)initButtons
{
    createContactButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [createContactButton addTarget:self
                            action:@selector(addContact)
                  forControlEvents:UIControlEventTouchUpInside];
    [createContactButton setTitle:@"新建" forState:UIControlStateNormal];
    createContactButton.frame = CGRectMake(480, 0, 55, 40.0); // x, y, width, height

    importContactButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [importContactButton addTarget:self
                            action:@selector(importContacts)
                  forControlEvents:UIControlEventTouchUpInside];
    [importContactButton setTitle:@"导入" forState:UIControlStateNormal];
    importContactButton.frame = CGRectMake(540, 0, 55, 40.0); // x, y, width, height
    
    exportContactButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [exportContactButton addTarget:self
                            action:@selector(generateExportView)
                  forControlEvents:UIControlEventTouchUpInside];
    [exportContactButton setTitle:@"批量导出" forState:UIControlStateNormal];
    exportContactButton.frame = CGRectMake(590, 0, 80, 40.0); // x, y, width, height
    
    
    exportSaveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [exportSaveButton addTarget:self
                            action:@selector(finishExport)
                  forControlEvents:UIControlEventTouchUpInside];
    [exportSaveButton setTitle:@"确认" forState:UIControlStateNormal];
    exportSaveButton.frame = CGRectMake(480, 0, 55, 40.0); // x, y, width, height
    
    exportCancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [exportCancelButton addTarget:self
                            action:@selector(cancelExport)
                  forControlEvents:UIControlEventTouchUpInside];
    [exportCancelButton setTitle:@"取消" forState:UIControlStateNormal];
    exportCancelButton.frame = CGRectMake(540, 0, 55, 40.0); // x, y, width, height
    
    
    addProjectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addProjectButton addTarget:self
                            action:@selector(addProject)
                  forControlEvents:UIControlEventTouchUpInside];
    [addProjectButton setTitle:@"新建" forState:UIControlStateNormal];
    addProjectButton.frame = CGRectMake(480, 0, 55, 40.0); // x, y, width, height

    addEventButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addEventButton addTarget:self
                         action:@selector(addEvent)
               forControlEvents:UIControlEventTouchUpInside];
    [addEventButton setTitle:@"新建" forState:UIControlStateNormal];
    addEventButton.frame = CGRectMake(480, 0, 55, 40.0); // x, y, width, height

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
    if (indexPath.section == 1)
        return [allContacts count];
    else if(indexPath.section == 2)
        return [allProjects count];
    else if(indexPath.section == 3)
        return [allEvents count];
    else
        return [contents[indexPath.section][indexPath.row] count] - 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    printf("select row at section %d row %d\n", indexPath.section, indexPath.row);
    if (indexPath.section == 0 && indexPath.row == 1) {
        
        if (globalCompany.billing_address == nil) {
            [self performSegueWithIdentifier:@"editBillAddressDirectly" sender:self];
        }
        else {
            [self performSegueWithIdentifier:@"viewBillingAddress" sender:self];
        }
        
    }
    else if (indexPath.section == 0 && indexPath.row == 2) {
        if (globalCompany.shipping_address == nil) {
            [self performSegueWithIdentifier:@"editShippingAddressDirectly" sender:self];
        }
        else {
            [self performSegueWithIdentifier:@"viewShippingAddress" sender:self];
        }
    }
    
    
    if (indexPath.section == 1) {
        if (indexPath.row != 0) {
            if (exportingContact) {
                // exporting contact, click on one of the contacts to select to export
                UITableViewCell *cell =[self.tableView cellForRowAtIndexPath:indexPath];
                UIButton *button = (UIButton *)cell.accessoryView;
                Contact* con = [allContacts objectAtIndex:indexPath.row - 1];
                if (button.selected) {
                    [selectedContactsForExport removeObject:con];
                } else {
                    [selectedContactsForExport addObject:con];
                    printf("%d\n", [selectedContactsForExport count]);
                }
                button.selected = !button.selected;
            } else {
                // not exporting, a contact is clicked to view details
                globalSelectedContact = [allContacts objectAtIndex:indexPath.row - 1];
                [self performSegueWithIdentifier:@"contactDetailSegue" sender:self];
            }
        } else {
            if (exportingContact) {
                // exporting contact, the section header clicked to shrink, and cancel exporting contact
                [self exportEndsViewChange];
            }
        }
    }
    else if(indexPath.section == 2 && indexPath.row != 0) {
        globalSelectedProject = [allProjects objectAtIndex:indexPath.row - 1];
        [self performSegueWithIdentifier:@"viewProject" sender:self];
    }
    else if(indexPath.section == 3 && indexPath.row != 0) {
        globalSelectedEvent = [allEvents objectAtIndex:indexPath.row - 1];
        [self performSegueWithIdentifier:@"viewEvent" sender:self];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SKSTableViewCell";
    
    SKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = self.contents[indexPath.section][indexPath.row][0];
    
    if (indexPath.section == 1 && [allContacts count] == 0)
        cell.isExpandable = NO;
    else if(indexPath.section == 2 && [allProjects count] == 0)
        cell.isExpandable = NO;
    else if(indexPath.section == 3 && [allEvents count] == 0)
        cell.isExpandable = NO;
    else
        cell.isExpandable = YES;

    if (indexPath.section == 1) {
        [cell.contentView addSubview:createContactButton];
        [cell.contentView addSubview:importContactButton];
        [cell.contentView addSubview:exportContactButton];
    } else if (indexPath.section == 2) {
        [cell.contentView addSubview:addProjectButton];
    } else if (indexPath.section == 3) {
        [cell.contentView addSubview:addEventButton];
    }
    
    cell.backgroundColor=[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addContactSegue"]) {
        AddContactViewController *addContact = segue.destinationViewController;
        addContact.company = company;
    } else if ([segue.identifier isEqualToString:@"contactDetailSegue"]) {
        DetailContact2ViewController *detailcontact=segue.destinationViewController;
        detailcontact.contact = globalSelectedContact;
        detailcontact.company = globalCompany;
    }
    else if ([segue.identifier isEqualToString:@"viewShippingAddress"]) {
        ViewShippingAddressController *shippingAddressController = segue.destinationViewController;
        shippingAddressController.company = globalCompany;
    }
    else if([segue.identifier isEqualToString:@"editShippingAddressDirectly"]) {
        ShippingAddressViewController *shippingAddressController = segue.destinationViewController;
        shippingAddressController.company = globalCompany;
    }
    else if([segue.identifier isEqualToString:@"viewBillingAddress"]) {
        ViewBillingAddressController *billingAddressController = segue.destinationViewController;
        billingAddressController.company = globalCompany;
    }
    else if([segue.identifier isEqualToString:@"editBillAddressDirectly"]) {
        BillAddressViewController *billAddressController = segue.destinationViewController;
        billAddressController.company = globalCompany;
    }
    else if([segue.identifier isEqualToString:@"addProject"]) {
        AddProjectViewController *projectController = segue.destinationViewController;
        projectController.company = company;
    }
    else if([segue.identifier isEqualToString:@"viewProject"]) {
        EditProjectViewController *projectController = segue.destinationViewController;
        projectController.company = globalCompany;
        projectController.project = globalSelectedProject;
    }
    else if([segue.identifier isEqualToString:@"viewEvent"]) {
        EditEventViewController *c = segue.destinationViewController;
        c.company = globalCompany;
        c.event = globalSelectedEvent;
        c.allProjects = allProjects;
        c.allContacts = allContacts;
    }
    else if([segue.identifier isEqualToString:@"addEvent"]) {
        AddEventViewController* c = segue.destinationViewController;
        c.company = company;
        c.allContacts = allContacts;
        c.allProjects = allProjects;
    }
    else if([segue.identifier isEqualToString:@"editCompany"]) {
        EditCompanyViewController* localCompany = segue.destinationViewController;
        localCompany.company = globalCompany;
    }
}

// called in SKSTableView.m to create cell for subRows
- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    
    if (indexPath.section == 0)
        cell.textLabel.text = [NSString stringWithFormat:@"%@", self.contents[indexPath.section][indexPath.row][indexPath.subRow]];
    if (indexPath.section == 1) {
        Contact *oneContact = [allContacts objectAtIndex:indexPath.subRow-1];
        NSString *name = [NSString stringWithFormat:@"%@ %@", oneContact.lastname, oneContact.firstname];
        cell.textLabel.text = name;
    } else if(indexPath.section == 2) {
        Project *oneProject = [allProjects objectAtIndex:indexPath.subRow-1];
        cell.textLabel.text = oneProject.name;
    } else if (indexPath.section == 3) {
        Event* eve = [allEvents objectAtIndex:indexPath.subRow - 1];
        cell.textLabel.text = eve.name;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 1) {
        // add button as subView to control subRow here
    }
    return cell;
}

- (void)addContact
{
    [self performSegueWithIdentifier: @"addContactSegue" sender:self];
}

- (void)importContacts
{
    TKPeoplePickerController *controller = [[TKPeoplePickerController alloc] initPeoplePicker];
    controller.actionDelegate = self;
    controller.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)generateExportView
{
    if([allContacts count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"导出失败"
                                                        message:@"该公司没有可以导出的联系人，请先新建联系人"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    if([[self tableView] numberOfRowsInSection:1] == 1) {
    // contacts not expanded, expand them
        [self performClickOnRowAtIndexPath:indexPath];
    }
    [createContactButton removeFromSuperview];
    [importContactButton removeFromSuperview];
    [exportContactButton removeFromSuperview];
    
    [[[[self tableView] cellForRowAtIndexPath:indexPath] contentView] addSubview: exportSaveButton];
    [[[[self tableView] cellForRowAtIndexPath:indexPath] contentView] addSubview: exportCancelButton];
    
    for (int i = 1; i <= [allContacts count]; ++i) {
        UITableViewCell* cell = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(30.0, 0.0, 28, 28)];
        [button setBackgroundImage:[UIImage imageNamed:@"uncheckBox.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
        [button setSelected:false];
        
        cell.accessoryView = button;
    }
    
    exportingContact = true;
}

- (void)checkButtonTapped:(id)sender event:(id)event
{
    // check button tapped
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:self.tableView];
	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
	
	if (indexPath != nil)
	{
		[self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
	}
}

- (void)finishExport
{
    for (Contact* cont in selectedContactsForExport) {
        ABAddressBookRef addressBook = ABAddressBookCreate(); // create address book record
        ABRecordRef person = ABPersonCreate(); // create a person
        
        //Phone number is a list of phone number, so create a multivalue
        ABMutableMultiValueRef phoneNumberMultiValue =
        ABMultiValueCreateMutable(kABPersonPhoneProperty);
        ABMultiValueAddValueAndLabel(phoneNumberMultiValue ,(__bridge CFTypeRef)(cont.phone_home), kABPersonPhoneMainLabel, NULL);
        ABMultiValueAddValueAndLabel(phoneNumberMultiValue ,(__bridge CFTypeRef)(cont.phone_work), kABPersonPhoneIPhoneLabel, NULL);
        ABMultiValueAddValueAndLabel(phoneNumberMultiValue ,(__bridge CFTypeRef)(cont.phone_mobile), kABPersonPhoneMobileLabel, NULL);
        
        ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFTypeRef)(cont.firstname), nil); // first name of the new person
        ABRecordSetValue(person, kABPersonLastNameProperty, (__bridge CFTypeRef)(cont.lastname), nil); // his last name
        ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, nil); // set the phone number property
        ABAddressBookAddRecord(addressBook, person, nil); //add the new person to the record
        
        ABAddressBookSave(addressBook, nil); //save the record
        
        CFRelease(person); // relase the ABRecordRef variable
        
        // TODO: add more attributes to export
    }
    
    NSString* msg = [[NSString alloc] initWithFormat:@"已成功导出%d位联系人到本地", [selectedContactsForExport count]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"导出生成"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];

    
    [self exportEndsViewChange];
}

- (void)cancelExport
{
    [self exportEndsViewChange];
}


- (void)exportEndsViewChange
{
    exportingContact = false;
    UITableViewCell* cell = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [cell.contentView addSubview:createContactButton];
    [cell.contentView addSubview:importContactButton];
    [cell.contentView addSubview:exportContactButton];
    [exportSaveButton removeFromSuperview];
    [exportCancelButton removeFromSuperview];
    
    
    for (int i = 1; i <= [allContacts count]; ++i) {
        UITableViewCell* cell = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
        cell.accessoryView = nil;
    }
    
    [selectedContactsForExport removeAllObjects];
}

- (void)addProject
{
    [self performSegueWithIdentifier: @"addProject" sender:self];
}

- (void)addEvent
{
    [self performSegueWithIdentifier: @"addEvent" sender:self];
}

#pragma mark - TKContactsMultiPickerControllerDelegate

- (void)tkPeoplePickerController:(TKPeoplePickerController*)picker didFinishPickingDataWithInfo:(NSArray*)contacts
{
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
    DatabaseInterface *database = [DatabaseInterface databaseInterface];
    
    // contacts are the contacts selected in the import contact view
    for (TKContact* contact in contacts) {
        [database addContactWithLastname:contact.lastName firstname:contact.firstName title:@"" phoneWork:@"" phoneHome:@"" phoneMobile:contact.tel emailWork:contact.email emailPersonal:@"" note:@"" country:@"" province:@"" city:@"" street:@"" postcode:@"" companyName:CompanyName.text QQ:@"" weChat:@"" skype:@"" weibo:@""];
    }
    
    if([[self tableView] numberOfRowsInSection:1] == 1) {
        [self updateContents];
        [self.tableView reloadData];
    } else {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [self performClickOnRowAtIndexPath:indexPath];
        [self updateContents];
        [self performClickOnRowAtIndexPath:indexPath];
    }
}

- (void)tkPeoplePickerControllerDidCancel:(TKPeoplePickerController*)picker
{
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)performClickOnRowAtIndexPath:(NSIndexPath*) indexPath
{
    [[self tableView] selectRowAtIndexPath:indexPath animated:false scrollPosition:UITableViewScrollPositionNone];
    [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}
@end

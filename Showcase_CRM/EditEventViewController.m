//
//  EditEventViewController.m
//  Showcase_CRM
//
//  Created by Yixing Jiang on 7/29/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import "EditEventViewController.h"
#import "sksViewController.h"
#import "DatabaseInterface.h"
#import "PickerHelper.h"

@interface EditEventViewController ()

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *contact;
@property (weak, nonatomic) IBOutlet UITextField *project;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *date;
@property (weak, nonatomic) IBOutlet UITextField *memo;
@property (weak, nonatomic) IBOutlet UINavigationBar *header;
@property (weak, nonatomic) IBOutlet UINavigationItem *header_title;

@property (weak, nonatomic) IBOutlet UIButton *returnButton;
@property (weak, nonatomic) IBOutlet UIButton *saveEditButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelEditButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (nonatomic, retain) NSDate * globalDate;

- (void)updateTextField:(id)sender;

@end

@implementation EditEventViewController

@synthesize name, address, date, memo, contact, project, event, company, returnButton, saveEditButton, cancelEditButton, editButton, deleteButton, globalDate,header,header_title;

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
    [self setAllField];
    [self disableAllField];
    saveEditButton.hidden = YES;
    deleteButton.hidden = YES;
    cancelEditButton.hidden = YES;
    header.frame=CGRectMake(0, 0, 768, 73);
    header_title.title = company.name;
    globalDate = [NSDate date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (IBAction)beginEditDateField:(id)sender {
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setDate:globalDate];
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.date setInputView:datePicker];
}

- (void)updateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.date.inputView;
    self.date.text = [PickerHelper formatDate:picker.date];;
    globalDate = picker.date;
}

- (IBAction)beginEditContactTextField:(id)sender {
}

- (IBAction)focusContact:(id)sender {
}

- (IBAction)beginEditProjectTextField:(id)sender {
}

- (IBAction)focusProject:(id)sender {
}

- (void)setAllField
{
    name.text = event.name;
    address.text = event.location;
    NSDate *local_date = event.date;
    date.text = [NSDateFormatter localizedStringFromDate:local_date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
    memo.text = event.memo;
    
    if ([event.contacts count] != 0) {
        Contact* c = [[event.contacts allObjects] objectAtIndex:0];
        contact.text = [NSString stringWithFormat:@"%@ %@",c.lastname, c.firstname];
    } else {
        contact.text = @"";
    }
    
    if (event.project) {
        project.text = event.project.name;
    } else {
        project.text = @"";
    }
}

- (void)enableAllField
{
    name.enabled = YES;
    address.enabled = YES;
    date.enabled = YES;
    memo.enabled = YES;
    contact.enabled = YES;
    project.enabled = YES;
}

- (void)disableAllField
{
    name.enabled = NO;
    address.enabled = NO;
    date.enabled = NO;
    memo.enabled = NO;
    contact.enabled = NO;
    project.enabled = NO;
}

- (IBAction)returnFromViewEvent:(id)sender {
    [self performSegueWithIdentifier:@"returnFromViewEvent" sender:nil];
}

- (IBAction)deleteEvent:(id)sender {
    [self performSegueWithIdentifier:@"deleteEvent" sender:nil];
}

- (IBAction)saveEditEvent:(id)sender {
    event.name = name.text;
    
    if ([name.text length]<=0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改失败"
                                                        message:@"项目名不能为空"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    event.memo = memo.text;
    event.date = globalDate;
    
    DatabaseInterface *database = [DatabaseInterface databaseInterface];
    [database editEvent:event];
    
    [self disableAllField];
    editButton.hidden = NO;
    returnButton.hidden = NO;
    saveEditButton.hidden = YES;
    deleteButton.hidden = YES;
    cancelEditButton.hidden = YES;
}

- (IBAction)editEvent:(id)sender {
    [self enableAllField];
    editButton.hidden = YES;
    returnButton.hidden = YES;
    saveEditButton.hidden = NO;
    cancelEditButton.hidden = NO;
    deleteButton.hidden = NO;
}

- (IBAction)cancelEditEvent:(id)sender {
    [self disableAllField];
    [self setAllField];
    editButton.hidden = NO;
    returnButton.hidden = NO;
    saveEditButton.hidden = YES;
    deleteButton.hidden = YES;
    cancelEditButton.hidden = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"returnFromViewEvent"]) {
        sksViewController *companyViewController = segue.destinationViewController;
        companyViewController.company = company.name;
    }
    else if ([segue.identifier isEqualToString:@"deleteEvent"]) {
        DatabaseInterface *database = [DatabaseInterface databaseInterface];
        [database deleteEvent:event];
        sksViewController *companyViewController = segue.destinationViewController;
        companyViewController.company = company.name;
    }
    
}

@end

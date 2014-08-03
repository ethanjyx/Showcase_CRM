//
//  AddEventViewController.m
//  Showcase_CRM
//
//  Created by Yixing Jiang on 7/25/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import "AddEventViewController.h"
#import "DatabaseInterface.h"
#import "sksViewController.h"
#import "PickerHelper.h"
#import "Contact.h"
#import "Project.h"

@interface AddEventViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;
@property (weak, nonatomic) IBOutlet UITextField *projectTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextField *contextTextField;

@property (weak, nonatomic) IBOutlet UINavigationBar *header;
@property (weak, nonatomic) IBOutlet UINavigationItem *headerTitle;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (nonatomic, strong) UIPickerView *contactSelect;
@property (nonatomic, strong) UIPickerView *projectSelect;
@property (nonatomic, strong) UIPickerView *activePicker;

- (IBAction)beginEditDateTextField:(id)sender;
- (void)updateDateTextField:(id)sender;
- (IBAction)finish:(id)sender;

- (IBAction)saveAddEvent:(id)sender;
- (IBAction)cancelAddEvent:(id)sender;

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Contact * selectedContact;
@property (nonatomic, retain) Project * selectedProject;

@end

@implementation AddEventViewController

@synthesize company, date, dateTextField, nameTextField, addressTextField, contextTextField,header,headerTitle, allContacts, allProjects, contactTextField, projectTextField, contactSelect, projectSelect, toolbar, activePicker, selectedContact, selectedProject;

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
    date = [[NSDate alloc] init];
    dateTextField.text = [PickerHelper formatDate:date];
    header.frame=CGRectMake(0, 0, 768, 73);
    headerTitle.title = company;
    date = [NSDate date];
    
    if ([allContacts count] == 0) {
        contactTextField.text = @"没有可供选择的联系人";
        contactTextField.textColor = [UIColor grayColor];
        contactTextField.enabled = false;
    }
    
    if ([allProjects count] == 0) {
        projectTextField.text = @"没有可供选择的项目";
        projectTextField.textColor = [UIColor grayColor];
        projectTextField.enabled = false;
    }
    
    contactSelect = [[UIPickerView alloc] initWithFrame:CGRectMake(140, 122, 850, 74)];
    contactSelect.showsSelectionIndicator = YES;
    contactSelect.hidden = NO;
    contactSelect.delegate = self;
    contactSelect.dataSource = self;
    contactTextField.inputAccessoryView = toolbar;
    contactTextField.inputView = contactSelect;
    
    projectSelect = [[UIPickerView alloc] initWithFrame:CGRectMake(140, 122, 850, 74)];
    projectSelect.showsSelectionIndicator = YES;
    projectSelect.hidden = NO;
    projectSelect.delegate = self;
    projectSelect.dataSource = self;
    projectTextField.inputAccessoryView = toolbar;
    projectTextField.inputView = projectSelect;

    toolbar.hidden = YES;
    
    if ([allContacts count] == 1) {
        selectedContact = [allContacts objectAtIndex:0];
    }
    
    if ([allProjects count] == 1) {
        selectedProject = [allProjects objectAtIndex:0];
    }
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

- (IBAction)beginEditDateTextField:(id)sender {
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setDate:date];
    [datePicker addTarget:self action:@selector(updateDateTextField:) forControlEvents:UIControlEventValueChanged];
    [dateTextField setInputView:datePicker];
}

- (void)updateDateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.dateTextField.inputView;
    self.dateTextField.text = [PickerHelper formatDate:picker.date];;
    date = picker.date;
}

- (IBAction)finish:(id)sender {
    if (activePicker == contactSelect) {
        contactSelect.hidden = YES;
        toolbar.hidden = YES;
        contactTextField.text = [NSString stringWithFormat:@"%@ %@",selectedContact.lastname, selectedContact.firstname];
    } else if (activePicker == projectSelect) {
        projectSelect.hidden = YES;
        toolbar.hidden = YES;
        projectTextField.text = selectedProject.name;
    }
}

- (IBAction)beginEditContactTextField:(id)sender {
    contactSelect.hidden = NO;
    toolbar.hidden = NO;
    activePicker = contactSelect;
}

- (IBAction)focusOnContactTextField:(id)sender {
    contactSelect.hidden = NO;
    toolbar.hidden = NO;
    activePicker = contactSelect;
}

- (IBAction)beginEditProjectTextField:(id)sender {
    projectSelect.hidden = NO;
    toolbar.hidden = NO;
    activePicker = projectSelect;
}

- (IBAction)focusOnProjectTextField:(id)sender {
    projectSelect.hidden = NO;
    toolbar.hidden = NO;
    activePicker = projectSelect;
}

- (IBAction)saveAddEvent:(id)sender {
    if ([nameTextField.text length]<=0 ) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新建失败"
                                                        message:@"活动名不能为空"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self performSegueWithIdentifier:@"saveEvent" sender:nil];
}


- (IBAction)cancelAddEvent:(id)sender {
    [self performSegueWithIdentifier:@"cancelAddEvent" sender:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"cancelAddEvent"]) {
        
    } else if ([segue.identifier isEqualToString:@"saveEvent"]) {
        DatabaseInterface *database = [DatabaseInterface databaseInterface];
        [database addEventWithName:nameTextField.text date:date locations:addressTextField.text memo:contextTextField.text companyName:company contact:selectedContact project:selectedProject];
        
        sksViewController *c = segue.destinationViewController;
        c.company = company;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView; {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component; {
    if (pickerView == contactSelect) {
        return [allContacts count];
    } else if (pickerView == projectSelect) {
        return [allProjects count];
    }
    
    return 0;
}

-(NSString*) pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == contactSelect) {
        Contact* contact = [allContacts objectAtIndex:row];
        return [NSString stringWithFormat:@"%@ %@",contact.lastname, contact.firstname];
    } else if (pickerView == projectSelect) {
        return [[allProjects objectAtIndex:row] name];
    }
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    if (pickerView == contactSelect) {
        selectedContact = [allContacts objectAtIndex:row];
    } else if (pickerView == projectSelect) {
        selectedProject = [allProjects objectAtIndex:row];
    }
}


@end

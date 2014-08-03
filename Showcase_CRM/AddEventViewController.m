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

@interface AddEventViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextField *contextTextField;
@property (weak, nonatomic) IBOutlet UINavigationBar *header;
@property (weak, nonatomic) IBOutlet UINavigationItem *headerTitle;

- (IBAction)beginEditDateTextField:(id)sender;
- (void)updateTextField:(id)sender;

- (IBAction)saveAddEvent:(id)sender;
- (IBAction)cancelAddEvent:(id)sender;

@property (nonatomic, retain) NSDate * date;

@end

@implementation AddEventViewController

@synthesize company, date, dateTextField, nameTextField, addressTextField, contextTextField,header,headerTitle;

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
    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.dateTextField setInputView:datePicker];
}

- (void)updateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.dateTextField.inputView;
    self.dateTextField.text = [PickerHelper formatDate:picker.date];;
    date = picker.date;
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
        [database addEventWithName:nameTextField.text date:date locations:addressTextField.text memo:contextTextField.text companyName:company];
        
        sksViewController *c = segue.destinationViewController;
        c.company = company;
    }
}

@end

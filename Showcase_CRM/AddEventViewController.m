//
//  AddEventViewController.m
//  Showcase_CRM
//
//  Created by Yixing Jiang on 7/25/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import "AddEventViewController.h"

@interface AddEventViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextField *contextTextField;

- (IBAction)beginEditDateTextField:(id)sender;
- (void)updateTextField:(id)sender;
- (NSString *)formatDate:(NSDate *)d;

- (IBAction)saveAddEvent:(id)sender;
- (IBAction)cancelAddEvent:(id)sender;

@property (nonatomic, retain) NSDate * date;

@end

@implementation AddEventViewController

@synthesize date, dateTextField;

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
    dateTextField.text = [self formatDate:date];
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
    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.dateTextField setInputView:datePicker];
}

-(void)updateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.dateTextField.inputView;
    self.dateTextField.text = [self formatDate:picker.date];;
    date = picker.date;
}

- (NSString *)formatDate:(NSDate *)d
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"MM'/'dd'/'yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:d];
    return formattedDate;
}

- (IBAction)saveAddEvent:(id)sender {
    [self performSegueWithIdentifier:@"saveEvent" sender:nil];
}


- (IBAction)cancelAddEvent:(id)sender {
    [self performSegueWithIdentifier:@"cancelAddEvent" sender:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"cancelAddEvent"]) {
        
    } else if ([segue.identifier isEqualToString:@"saveEvent"]) {
        
    }
}

@end

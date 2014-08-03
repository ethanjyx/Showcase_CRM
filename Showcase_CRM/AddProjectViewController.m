//
//  AddProjectViewController.m
//  Showcase_CRM
//
//  Created by Yixing Jiang on 7/25/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import "AddProjectViewController.h"
#import "DatabaseInterface.h"
#import "sksViewController.h"

@interface AddProjectViewController ()
@property (weak, nonatomic) IBOutlet UINavigationBar *header;
@property (weak, nonatomic) IBOutlet UINavigationItem *headertitle;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *possibility;

@property (weak, nonatomic) IBOutlet UITextField *amount;
@property (weak, nonatomic) IBOutlet UITextField *note;
@property (weak, nonatomic) IBOutlet UIDatePicker *date;
@property (weak, nonatomic) IBOutlet UITextField *progress;

- (IBAction)save:(id)sender;
- (IBAction)returnFromProject:(id)sender;


@end

@implementation AddProjectViewController {
    NSNumber *possibility_number;
    NSNumber *amount_number;
}
@synthesize picker,toolbar;
@synthesize headertitle,header;
@synthesize company,name,possibility,amount,note,date,progress;

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
    header.frame=CGRectMake(0, 0, 768, 73);
    headertitle.title=company;
    pickerArray=[NSArray arrayWithObjects:@"0",@"10",@"20",@"30",@"40",@"50",@"60",@"70",@"80",@"90",@"100",nil];
    possibility.inputView=picker;
    possibility.inputAccessoryView=toolbar;
    possibility.delegate=self;
    picker.delegate=self;
    // Do any additional setup after loading the view.
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示
    date.locale = locale;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"saveProject"]) {
        DatabaseInterface *database = [DatabaseInterface databaseInterface];
        [database addProjectWithName:name.text possibility:possibility_number amount:amount_number memo:note.text deadline:date.date progress:progress.text companyName:company];
        
        
        sksViewController *localContact = segue.destinationViewController;
        localContact.company = company;
    }
    else if([segue.identifier isEqualToString:@"returnFromCreateProject"]) {
        sksViewController *localContact = segue.destinationViewController;
        localContact.company = company;
    }
}


- (IBAction)save:(id)sender {
    if ([name.text length]<=0 ) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新建失败"
                                                        message:@"项目名不能为空"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    if ([amount.text length]<=0) {
        amount_number = nil;
    }
    else {
        NSNumber *amount_f = [f numberFromString:amount.text];
        if (amount_f == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新建失败"
                                                            message:@"金额不是数字"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            amount.text = nil;
            return;
        }
        else {
            amount_number = amount_f;
        }
    }
    if ([possibility.text length]<=0) {
        possibility_number = nil;
    }
    else {
        NSNumber *possibility_f = [f numberFromString:possibility.text];
        if (possibility_f == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新建失败"
                                                            message:@"可能性不是数字"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            possibility.text = nil;
            return;
        }
        else {
            possibility_number = possibility_f;
        }
    }
    
    
    [self performSegueWithIdentifier:@"saveProject" sender:nil];
}

- (IBAction)returnFromProject:(id)sender {
}
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerArray count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [pickerArray objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.possibility.text=[pickerArray objectAtIndex:row];
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger row=[picker selectedRowInComponent:0];
    self.possibility.text=[pickerArray objectAtIndex:row];
    NSNumberFormatter * A = [[NSNumberFormatter alloc] init];
    NSNumber *number= [A numberFromString:possibility.text];
    possibility_number=number;
    picker.hidden=YES;
    toolbar.hidden=YES;
}
- (IBAction)finish:(id)sender {
    [possibility endEditing:YES];
}

- (IBAction)edit:(id)sender {
    toolbar.hidden=NO;
    picker.hidden=NO;
}
@end

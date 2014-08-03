//
//  EditProjectViewController.m
//  Showcase_CRM
//
//  Created by Linfeng Shi on 7/28/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import "EditProjectViewController.h"
#import "Status.h"
#import "sksViewController.h"
#import "DatabaseInterface.h"

@interface EditProjectViewController ()
@property (weak, nonatomic) IBOutlet UINavigationBar *header;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *possibility;
@property (weak, nonatomic) IBOutlet UITextField *amount;
@property (weak, nonatomic) IBOutlet UITextField *memo;
@property (weak, nonatomic) IBOutlet UITextField *progress;
@property (weak, nonatomic) IBOutlet UIDatePicker *date;
@property (weak, nonatomic) IBOutlet UITextField *date_uneditable;
@property (weak, nonatomic) IBOutlet UINavigationItem *headerTitle;


@property (weak, nonatomic) IBOutlet UIButton *return_button;
@property (weak, nonatomic) IBOutlet UIButton *save_button;
@property (weak, nonatomic) IBOutlet UIButton *edit_button;
@property (weak, nonatomic) IBOutlet UIButton *cancel_button;
@property (weak, nonatomic) IBOutlet UIButton *delete_button;

- (IBAction)return_action:(id)sender;
- (IBAction)save_action:(id)sender;
- (IBAction)edit_action:(id)sender;
- (IBAction)cancel_action:(id)sender;
- (IBAction)delete_action:(id)sender;


@end

@implementation EditProjectViewController
@synthesize header;
@synthesize project, company;
@synthesize name,possibility,amount,memo,progress,date,return_button,save_button,edit_button,cancel_button,delete_button,date_uneditable,headerTitle;

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
    headerTitle.title = company.name;
    // Do any additional setup after loading the view.
    [self setAllField];
    [self disableAllField];
    save_button.hidden = YES;
    delete_button.hidden = YES;
    cancel_button.hidden = YES;
    date.hidden = YES;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示
    date.locale = locale;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setAllField
{
    name.text = project.name;
    possibility.text = [NSString stringWithFormat:@"%d", [project.possibility intValue]];
    amount.text = [NSString stringWithFormat:@"%d", [project.amount intValue]];
    memo.text = project.memo;
    Status *project_status = project.status;
    progress.text = project_status.status_type;
    NSDate *local_date = project.deadline;
    date_uneditable.text = [NSDateFormatter localizedStringFromDate:local_date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
}

- (void)enableAllField
{
    name.enabled = YES;
    possibility.enabled = YES;
    amount.enabled = YES;
    memo.enabled = YES;
    progress.enabled = YES;
    date.enabled = YES;
}

- (void)disableAllField
{
    name.enabled = NO;
    possibility.enabled = NO;
    amount.enabled = NO;
    memo.enabled = NO;
    progress.enabled = NO;
    date.enabled = NO;
    date_uneditable.enabled = NO;
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

- (IBAction)return_action:(id)sender {
    [self performSegueWithIdentifier:@"returnFromViewProject" sender:nil];
}

- (IBAction)save_action:(id)sender {
    project.name = name.text;
    NSNumber *amount_number, *possibility_number;
    if ([name.text length]<=0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改失败"
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改失败"
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改失败"
                                                            message:@"可能性不是数字"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            possibility.text = nil;
            return;
        }
        else {
            possibility_f = possibility_f;
        }
    }
    project.amount = amount_number;
    project.possibility = possibility_number;
    project.deadline = date.date;
    project.memo = memo.text;
    project.status.status_type = progress.text;
    
    DatabaseInterface *database = [DatabaseInterface databaseInterface];
    [database editProject:project];
    
    
    
    [self disableAllField];
    edit_button.hidden = NO;
    return_button.hidden = NO;
    save_button.hidden = YES;
    delete_button.hidden = YES;
    cancel_button.hidden = YES;
    date.hidden = YES;
    date_uneditable.hidden = NO;
    date_uneditable.text = [NSDateFormatter localizedStringFromDate:date.date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
}

- (IBAction)edit_action:(id)sender {
    [self enableAllField];
    date_uneditable.hidden = YES;
    edit_button.hidden = YES;
    return_button.hidden = YES;
    save_button.hidden = NO;
    cancel_button.hidden = NO;
    delete_button.hidden = NO;
    date.hidden = NO;
    date.date = project.deadline;
}

- (IBAction)cancel_action:(id)sender {
    [self disableAllField];
    [self setAllField];
    edit_button.hidden = NO;
    return_button.hidden = NO;
    save_button.hidden = YES;
    delete_button.hidden = YES;
    cancel_button.hidden = YES;
    date.hidden = YES;
    date_uneditable.hidden = NO;
}

- (IBAction)delete_action:(id)sender {
    [self performSegueWithIdentifier:@"deleteProject" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"returnFromViewProject"]) {
        sksViewController *companyViewController = segue.destinationViewController;
        companyViewController.company = company.name;
    }
    else if ([segue.identifier isEqualToString:@"deleteProject"]) {
        DatabaseInterface *database = [DatabaseInterface databaseInterface];
        [database deleteProject:project];
        sksViewController *companyViewController = segue.destinationViewController;
        companyViewController.company = company.name;
    }
}


@end

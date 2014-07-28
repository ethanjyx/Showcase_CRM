//
//  EditProjectViewController.m
//  Showcase_CRM
//
//  Created by Linfeng Shi on 7/28/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import "EditProjectViewController.h"
#import "Status.h"

@interface EditProjectViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *possibility;
@property (weak, nonatomic) IBOutlet UITextField *amount;
@property (weak, nonatomic) IBOutlet UITextField *memo;
@property (weak, nonatomic) IBOutlet UITextField *progress;
@property (weak, nonatomic) IBOutlet UIDatePicker *date;
@property (weak, nonatomic) IBOutlet UITextField *date_uneditable;


@property (weak, nonatomic) IBOutlet UIButton *return_button;
@property (weak, nonatomic) IBOutlet UIButton *save_button;
@property (weak, nonatomic) IBOutlet UIButton *edit_button;
@property (weak, nonatomic) IBOutlet UIButton *cancel_button;
@property (weak, nonatomic) IBOutlet UIButton *delete_button;

- (IBAction)return_action:(id)sender;
- (IBAction)save_action:(id)sender;
- (IBAction)edit_action:(id)sender;
- (IBAction)cancel_action:(id)sender;


@end

@implementation EditProjectViewController

@synthesize project, company;
@synthesize name,possibility,amount,memo,progress,date,return_button,save_button,edit_button,cancel_button,delete_button;

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
    [self setAllField];
    [self disableAllField];
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
    date.date = project.deadline;
    Status *project_status = project.status;
    progress.text = project_status.status_type;
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
}

- (IBAction)save_action:(id)sender {
}

- (IBAction)edit_action:(id)sender {
}

- (IBAction)cancel_action:(id)sender {
}

@end

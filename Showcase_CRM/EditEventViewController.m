//
//  EditEventViewController.m
//  Showcase_CRM
//
//  Created by Yixing Jiang on 7/29/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import "EditEventViewController.h"

@interface EditEventViewController ()

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *date;
@property (weak, nonatomic) IBOutlet UITextField *memo;

@property (weak, nonatomic) IBOutlet UIButton *returnButton;
@property (weak, nonatomic) IBOutlet UIButton *saveEditButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelEditButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation EditEventViewController

@synthesize name, address, date, memo, event, company, returnButton, saveEditButton, cancelEditButton, editButton, deleteButton;

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

- (void)setAllField
{
    name.text = event.name;
    address.text = event.location;
    NSDate *local_date = event.date;
    date.text = [NSDateFormatter localizedStringFromDate:local_date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
    memo.text = event.memo;
}

- (void)enableAllField
{
    name.enabled = YES;
    address.enabled = YES;
    date.enabled = YES;
    memo.enabled = YES;
}

- (void)disableAllField
{
    name.enabled = NO;
    address.enabled = NO;
    date.enabled = NO;
    memo.enabled = NO;
}

- (IBAction)returnFromViewEvent:(id)sender {
    
}

- (IBAction)deleteEvent:(id)sender {

}

- (IBAction)saveEditEvent:(id)sender {

}


- (IBAction)editEvent:(id)sender {
    
}

- (IBAction)cancelEditEvent:(id)sender {

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"cancelAddEvent"]) {
        
    } else if ([segue.identifier isEqualToString:@"saveEvent"]) {

    }
}

@end

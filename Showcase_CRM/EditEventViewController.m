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



@end

@implementation EditEventViewController

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

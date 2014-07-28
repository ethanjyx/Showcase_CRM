//
//  AddEventViewController.m
//  Showcase_CRM
//
//  Created by Yixing Jiang on 7/25/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import "AddEventViewController.h"

@interface AddEventViewController ()



@end

@implementation AddEventViewController

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

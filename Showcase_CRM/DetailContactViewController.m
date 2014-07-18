//
//  DetailContactViewController.m
//  Showcase_CRM
//
//  Created by user on 14-7-16.
//  Copyright (c) 2014年 Linfeng Shi. All rights reserved.
//

#import "DetailContactViewController.h"

@interface DetailContactViewController ()

@end

@implementation DetailContactViewController
@synthesize lastname;
@synthesize firstname;
@synthesize contact;

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
    lastname.text=contact.firstname;
    firstname.text=contact.lastname;
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

@end
